import UIKit
import Flutter
import MathResolverLib

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let CHANNEL = "mathhelper.games.crossplatform/math_util"
    var currentExpressionPair: MathResolverPair?
    var compiledConfiguration: CompiledConfiguration?
    var ruleIndToResult: [Int: ExpressionNode]?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "resolveExpression": self.resolveExpression(call, result)
            case "getNodeByTouch": self.getNodeByTouch(call, result)
            case "compileConfiguration": self.compileConfiguration(call, result)
            case "performSubstitution": self.performSubstitution(call, result)
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
        let structured = args?["structured"] as? Bool
        let isRule = args?["isRule"] as? Bool ?? false
        if let ex = expression, let st = structured {
            let map = KotlinMutableDictionary<OperationType, NSString>(dictionary: [OperationType.div: "—"])
            let pair = MathResolver.companion.resolveToPlain(expression: ex, style: .default_,
                taskType: .default_, structureString: st, customSymbolMap: map)
            if (!isRule) {
                self.currentExpressionPair = pair
            }
            let matrix = pair.matrix as NSArray as! [String]
            result(matrix.joined(separator: "\n"))
        } else {
            result(FlutterError(code: "resolveExpression", message: "Bad arguments: \(call.arguments as? [String: Any])", details: nil))
        }
    }
    
    private func getNodeByTouch(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let coords = args?["coords"] as? [Int32]
        if let coords = coords, let nodeCoords = self.currentExpressionPair?.getNodeByCoords(x: coords[0], y: coords[1]) {
            let nodes = KotlinArray<KotlinInt>(size: 1, init: { _ in
                return KotlinInt(value: nodeCoords.node.nodeId)
            })
            let substitutionApplication = ExpressionSubstitutionsAPIKt.findApplicableSubstitutionsInSelectedPlace(
                expression: currentExpressionPair!.tree!.origin.parent!,
                selectedNodeIds: nodes,
                compiledConfiguration: compiledConfiguration!,
                simplifyNotSelectedTopArguments: false,
                withReadyApplicationResult: true,
                withFullExpressionChangingPart: true
            )
            var results = [String]()
            ruleIndToResult = [:]
            for application in substitutionApplication {
                ruleIndToResult?[results.count] = application.resultExpression
                results.append(
                    ExpressionParserAPIKt.expressionToStructureString(expressionNode: application.resultExpressionChangingPart)
                )
            }
            let msg: [String: Any] = [
                "node": ExpressionParserAPIKt.expressionToStructureString(expressionNode: nodeCoords.node),
                "lt": [nodeCoords.lt.x, nodeCoords.lt.y],
                "rb": [nodeCoords.rb.x, nodeCoords.rb.y],
                "results": results
            ]
            result(msg)
        } else {
            result(FlutterError(code: "getNodeByTouch", message: "Node not found for x: \(coords?[0]), y: \(coords?[1])", details: nil))
        }
    }
    
    private func compileConfiguration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let rules = args?["rules"] as? [[String: Any]]
        var subs = [ExpressionSubstitution]()
        for rule in rules ?? [] {
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
                normalizationType: ExpressionSubstitutionNormType
                    .value(forKey: (rule["normalizationType"] as? String ?? "ORIGINAL").lowercased()) as! ExpressionSubstitutionNormType,
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
            additionalParamsMap: [:]
        )
        result(nil)
    }
    
    private func performSubstitution(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Int]
        if let i = args?["index"], let resExpr = ruleIndToResult?[i] {
            //§
            //val pair = MathResolver.resolveToPlain(resExpr, customSymbolMap = map)
            //currentExpressionPair = pair
            ruleIndToResult = nil
            result(ExpressionParserAPIKt.expressionToStructureString(expressionNode: resExpr))
        } else {
            result(FlutterError(code: "performSubstitution", message: "Bad arguments: ${call.arguments}", details: nil))
        }
    }
    
    private func checkEnd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as? [String: String]
        if let expression = args?["expression"], let goal = args?["goal"], let pattern = args?["pattern"] {
            if pattern.isEmpty {
                result(expression == goal)
            } else {
                let base = FunctionConfiguration(scopeFilter: [], notChangesOnVariablesInComparisonFunctionFilter: [])
                let ex = ExpressionParserAPIKt.structureStringToExpression(structureString: expression, scope: "",
                    functionConfiguration: base)
                let pat = ExpressionParserAPIKt.stringToExpressionStructurePattern(string: pattern, scope: "", functionConfiguration: base)
                result(ExpressionComparisonsAPIKt.compareByPattern(expression: ex, pattern: pat))
            }
        } else {
            result(FlutterError(code: "checkEnd", message: "Bad arguments: ${call.arguments}", details: nil))
        }
    }
}
