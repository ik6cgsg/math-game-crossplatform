import UIKit
import Flutter
import MathResolverLib
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let CHANNEL = "mathhelper.games.crossplatform/math_util"
    var currentExpressionPair: MathResolverPair?
    var compiledConfiguration: CompiledConfiguration?
    var taskSubject: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "resolveExpression": self.resolveExpression(call, result)
            case "getNodeByTouch": self.getNodeByTouch(call, result)
            case "getSubstitutionInfo": self.getSubstitutionInfo(call, result)
            case "compileConfiguration": self.compileConfiguration(call, result)
            case "checkEnd": self.checkEnd(call, result)
            default: result(FlutterMethodNotImplemented)
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func resolveExpression(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let expression = args?["expression"] as? String
        taskSubject = args?["subject"] as? String
        var taskType = TaskType.default_
        if taskSubject == "setTheory" || taskSubject == "set" {
            taskType = TaskType.set
        }
        let structured = args?["structured"] as? Bool
        let interactive = args?["interactive"] as? Bool ?? false
        if let ex = expression, let st = structured {
            let pair = MathResolver.companion.resolveToPlain(expression: ex, style: .default_,
                taskType: taskType, structureString: st, customSymbolMap: nil, shrink: !interactive)
            if (interactive) {
                self.currentExpressionPair = pair
            }
            if (pair.tree != nil) {
                let matrix = pair.matrix as NSArray as! [String]
                result(matrix.joined(separator: "\n"))
            } else {
                result(FlutterError(code: "resolveExpression", message: "Failed to resolve \(expression)", details: nil))
            }
        } else {
            result(FlutterError(code: "resolveExpression", message: "Bad arguments: \(args)", details: nil))
        }
    }
    
    private func getNodeByTouch(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let coords = args?["coords"] as? [Int32]
        if let coords = coords, let nodeCoords = self.currentExpressionPair?.getNodeByCoords(x: coords[0], y: coords[1]) {
            let msg: [String: Any] = [
                "node": ExpressionParserAPIKt.expressionToStructureString(expressionNode: nodeCoords.node),
                "id": nodeCoords.node.nodeId,
                "lt": [nodeCoords.lt.x, nodeCoords.lt.y],
                "rb": [nodeCoords.rb.x, nodeCoords.rb.y]
            ]
            result(msg)
        } else {
            result(FlutterError(code: "getNodeByTouch", message: "Node not found for x: \(coords?[0]), y: \(coords?[1])", details: nil))
        }
    }
    
    private func getSubstitutionInfo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        if let ids = args?["ids"] as? [Int32] {
            let nodes = KotlinArray<KotlinInt>(size: Int32(ids.count), init: { i in
                return KotlinInt(value: ids[i.intValue])
            })
            let substitutionApplication = ExpressionSubstitutionsAPIKt.findApplicableSubstitutionsInSelectedPlace(
                expression: currentExpressionPair!.tree!.origin.parent!,
                selectedNodeIds: nodes,
                compiledConfiguration: compiledConfiguration!,
                simplifyNotSelectedTopArguments: false,
                withReadyApplicationResult: true,
                withFullExpressionChangingPart: true
            )
            var rules = [String]()
            var results = [String]()
            for application in substitutionApplication {
                rules.append(
                    ExpressionParserAPIKt.expressionToStructureString(expressionNode: application.resultExpressionChangingPart)
                )
                results.append(
                    ExpressionParserAPIKt.expressionToStructureString(expressionNode: application.resultExpression)
                )
            }
            let msg: [String: Any] = [
                "rules": rules,
                "results": results
            ]
            result(msg)
        } else {
            result(FlutterError(code: "getSubstitutionInfo", message: "Bad arguments: \(args)", details: nil))
        }
    }
    
    private func compileConfiguration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let rules = args?["rules"] as? [[String: Any]]
        let additional = args?["additional"] as? [String: String] ?? [:]
        var subs = [ExpressionSubstitution]()
        for rule in rules ?? [] {
            var normType = ExpressionSubstitutionNormType.original
            switch (rule["normalizationType"] as? String)?.lowercased() {
            case "sorted_and_i_multiplicated":
                normType = ExpressionSubstitutionNormType.sortedAndIMultiplicated
            case "i_multiplicated":
                normType = ExpressionSubstitutionNormType.iMultiplicated
            case "sorted":
                normType = ExpressionSubstitutionNormType.sorted
            default:
                normType = ExpressionSubstitutionNormType.original
            }
            let substitution = ExpressionSubstitutionsAPIKt.expressionSubstitutionFromStructureStrings(
                leftStructureString: rule["leftStructureString"] as? String ?? "",
                rightStructureString: rule["rightStructureString"] as? String ?? "",
                basedOnTaskContext: rule["basedOnTaskContext"] as? Bool ?? false,
                matchJumbledAndNested: rule["matchJumbledAndNested"] as? Bool ?? false,
                simpleAdditional: rule["simpleAdditional"] as? Bool ?? false,
                isExtending: rule["isExtending"] as? Bool ?? false,
                priority: rule["priority"] as? Int32 ?? 0,
                code: rule["code"] as? String ?? "",
                nameEn: rule["nameEn"] as? String ?? "",
                nameRu: rule["nameRu"] as? String ?? "",
                normalizationType: normType,
                weight: rule["weight"] as? Double ?? 0,
                weightInTaskAutoGeneration: rule["weightInTaskAutoGeneration"] as? Double ?? 0,
                useWhenPostprocessGeneratedExpression: rule["weightInTaskAutoGeneration"] as? Bool ?? false
            )
            subs.append(substitution)
        }
        let array = KotlinArray<ExpressionSubstitution>(size: Int32(subs.count), init: { i in
            return subs[i.intValue]
        })
        compiledConfiguration = ExpressionSubstitutionsAPIKt.createCompiledConfigurationFromExpressionSubstitutionsAndParams(
            expressionSubstitutions: array,
            additionalParamsMap: additional
        )
        result(nil)
    }
    
    private func checkEnd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: String]
        if let expression = args?["expression"], let goal = args?["goal"], let pattern = args?["pattern"] {
            if pattern.isEmpty {
                result(expression == goal)
            } else {
                let base = FunctionConfiguration(scopeFilter: [], notChangesOnVariablesInComparisonFunctionFilter: [])
                let ex = ExpressionParserAPIKt.structureStringToExpression(
                    structureString: expression,
                    scope: taskSubject ?? "",
                    functionConfiguration: base
                )
                let pat = ExpressionParserAPIKt.stringToExpressionStructurePattern(
                    string: pattern,
                    scope: taskSubject ?? "",
                    functionConfiguration: base
                )
                result(ExpressionComparisonsAPIKt.compareByPattern(expression: ex, pattern: pat))
            }
        } else {
            result(FlutterError(code: "checkEnd", message: "Bad arguments: \(args)", details: nil))
        }
    }
}
