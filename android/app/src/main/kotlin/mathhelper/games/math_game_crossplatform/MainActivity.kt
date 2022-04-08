package mathhelper.games.math_game_crossplatform

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import mathhelper.twf.api.expressionToStructureString
import mathhelper.utility.math_resolver_lib.MathResolver
import mathhelper.utility.math_resolver_lib.MathResolverPair

//import mathresolverlib.android.MathResolverLib

class MainActivity: FlutterActivity() {
    private val CHANNEL = "math_helper_util"
    private lateinit var currentExpressionPair: MathResolverPair

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "resolveExpression" -> {
                    val expression = call.argument<String>("expression")
                    val structured = call.argument<Boolean>("structured")
                    //val map = hashMapOf(OperationType.DIV to "―", OperationType.MULT to "*", OperationType.MINUS to "-")
                    if (expression != null && structured != null) {
                        currentExpressionPair = MathResolver.resolveToPlain(expression, structureString = structured)
                        result.success(currentExpressionPair.matrix.joinToString("\n"))
                    } else {
                        result.error("resolveExpression", "Bad arguments: ${call.arguments}", null)
                    }
                }
                "getNodeByTouch" -> {
                    val coords = call.argument<List<Int>>("coords")
                    if (coords != null) {
                        val nodeCoords = currentExpressionPair.getNodeByCoords(coords[0], coords[1])
                        if (nodeCoords != null) {
                            val msg = hashMapOf<String, Any?>(
                                "node" to expressionToStructureString(nodeCoords.node),
                                "lt" to listOf(nodeCoords.lt.x, nodeCoords.lt.y),
                                "rb" to listOf(nodeCoords.rb.x, nodeCoords.rb.y)
                            )
                            result.success(msg)
                        } else {
                            result.error("getNodeByTouch",
                                "Node not found for x: ${coords[0]}, y: ${coords[1]}", null)
                        }
                    } else {
                        result.error("getNodeByTouch", "Bad arguments: ${call.argument<Any>("coords")}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
