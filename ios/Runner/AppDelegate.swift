import UIKit
import Flutter
import MathResolverLib

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var currentExpressionPair: MathResolverPair?
    var currentSelectedAtom: ExpressionNode?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "mathhelper.games.crossplatform/math_util", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "resolveExpression":
                let args = call.arguments as? [String: Any]
                let expression = args?["expression"] as? String
                let structured = args?["structured"] as? Bool
                if let ex = expression, let st = structured {
                    self.currentExpressionPair = MathResolver.companion.resolveToPlain(expression: ex, style: .default_,
                        taskType: .default_, structureString: st, customSymbolMap: nil)
                    let matrix = self.currentExpressionPair!.matrix as NSArray as! [String]
                    result(matrix.joined(separator: "\n"))
                } else {
                    result(FlutterError(code: "resolveExpression", message: "bad arguments: \(call.arguments as? [String: Any])", details: nil))
                }
            case "getNodeByTouch":
                let args = call.arguments as? [String: Any]
                let coords = args?["coords"] as? [Int32]
                if let coords = coords, let nodeCoords = self.currentExpressionPair?.getNodeByCoords(x: coords[0], y: coords[1]) {
                    let msg: [String: Any] = [
                        "node": ExpressionParserAPIKt.expressionToStructureString(expressionNode: nodeCoords.node),
                        "lt": [nodeCoords.lt.x, nodeCoords.lt.y],
                        "rb": [nodeCoords.rb.x, nodeCoords.rb.y]
                    ]
                    self.currentSelectedAtom = nodeCoords.node
                    result(msg)
                } else {
                    result(FlutterError(code: "getNodeByTouch", message: "Node not found for x: \(coords?[0]), y: \(coords?[1])", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
