package mathhelper.games.math_game_crossplatform

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import mathhelper.twf.api.*
import mathhelper.twf.config.CompiledConfiguration
import mathhelper.twf.expressiontree.ExpressionNode
import mathhelper.twf.expressiontree.ExpressionSubstitution
import mathhelper.twf.expressiontree.ExpressionSubstitutionNormType
import mathhelper.utility.math_resolver_lib.MathResolver
import mathhelper.utility.math_resolver_lib.MathResolverPair
import mathhelper.utility.math_resolver_lib.OperationType

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mathhelper.games.crossplatform/math_util"
    private var currentExpressionPair: MathResolverPair? = null
    private var compiledConfiguration: CompiledConfiguration? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "resolveExpression" -> resolveExpression(call, result)
                "getNodeByTouch" -> getNodeByTouch(call, result)
                "getSubstitutionInfo" -> getSubstitutionInfo(call, result)
                "compileConfiguration" -> compileConfiguration(call, result)
                "checkEnd" -> checkEnd(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun resolveExpression(call: MethodCall, res: MethodChannel.Result) {
        val expression = call.argument<String>("expression")
        val structured = call.argument<Boolean>("structured") ?: true
        val isRule = call.argument<Boolean>("isRule") ?: false
        if (expression != null) {
            val pair = MathResolver.resolveToPlain(expression, structureString = structured)
            if (!isRule) {
                currentExpressionPair = pair
            }
            res.success(pair.matrix.joinToString("\n"))
        } else {
            res.error("resolveExpression", "Bad arguments: ${call.arguments}", null)
        }
    }

    private fun getNodeByTouch(call: MethodCall, res: MethodChannel.Result) {
        println("ANDROID getNodeByTouch")
        val coords = call.argument<List<Int>>("coords")
        if (coords != null) {
            val nodeCoords = currentExpressionPair?.getNodeByCoords(coords[0], coords[1])
            if (nodeCoords != null) {
                val msg = hashMapOf<String, Any?>(
                    "node" to expressionToStructureString(nodeCoords.node),
                    "id" to nodeCoords.node.nodeId,
                    "lt" to listOf(nodeCoords.lt.x, nodeCoords.lt.y),
                    "rb" to listOf(nodeCoords.rb.x, nodeCoords.rb.y),
                )
                res.success(msg)
            } else {
                res.error("getNodeByTouch",
                    "Node not found for x: ${coords[0]}, y: ${coords[1]}", null)
            }
        } else {
            res.error("getNodeByTouch", "Bad arguments: ${call.argument<Any>("coords")}", null)
        }
    }

    private fun getSubstitutionInfo(call: MethodCall, res: MethodChannel.Result) {
        println("ANDROID getSubstitutionInfo")
        val ids = call.argument<List<Int>>("ids")
        if (ids != null) {
            val substitutionApplication = findApplicableSubstitutionsInSelectedPlace(
                currentExpressionPair!!.tree!!.origin.parent!!,
                ids.toTypedArray(),
                compiledConfiguration!!
            )
            /*val rules = substitutionApplication.map{ it.expressionSubstitution }.toMutableList()
            rules = rules.distinctBy { Pair(it.left.identifier, it.right.identifier) }.toMutableList()
            rules.sortByDescending { it.left.toString().length }
            rules.sortBy { it.priority }
            val leftRight = rules.map { hashMapOf(
                "left" to expressionToStructureString(it.left),
                "right" to expressionToStructureString(it.right)
            )}*/
            val rules = arrayListOf<String>()
            val results = arrayListOf<String>()
            for (application in substitutionApplication) {
                rules += expressionToStructureString(application.resultExpressionChangingPart)
                results += expressionToStructureString(application.resultExpression)
            }
            val msg = hashMapOf<String, Any?>(
                "rules" to rules,
                "results" to results,
            )
            res.success(msg)
        } else {
            res.error("getSubstitutionInfo", "Bad arguments: ${call.argument<Any>("ids")}", null)
        }
    }

    private fun compileConfiguration(call: MethodCall, res: MethodChannel.Result) {
        val rules = call.argument<List<Map<String, *>>>("rules")
        val subs = arrayListOf<ExpressionSubstitution>()
        for (rule in rules ?: listOf()) {
            val substitution = expressionSubstitutionFromStructureStrings(
                leftStructureString = rule["leftStructureString"] as String,
                rightStructureString = rule["rightStructureString"] as String,
                basedOnTaskContext = rule["basedOnTaskContext"] as Boolean,
                matchJumbledAndNested = rule["matchJumbledAndNested"] as Boolean,
                simpleAdditional = rule["simpleAdditional"] as Boolean,
                isExtending = rule["isExtending"] as Boolean,
                priority = rule["priority"] as Int,
                code = rule["code"] as String,
                nameEn = rule["nameEn"] as String,
                nameRu = rule["nameRu"] as String,
                normalizationType = ExpressionSubstitutionNormType.valueOf(rule["normalizationType"] as String)
            )
            subs.add(substitution)
        }
        compiledConfiguration = createCompiledConfigurationFromExpressionSubstitutionsAndParams(
            subs.toTypedArray())
        res.success(null)
    }

    private fun checkEnd(call: MethodCall, res: MethodChannel.Result) {
        val expression = call.argument<String>("expression") ?: ""
        val goal = call.argument<String>("goal") ?: ""
        val pattern = call.argument<String>("pattern") ?: ""
        if (pattern.isBlank()) {
            res.success(expression == goal)
        } else {
            val ex = structureStringToExpression(expression)
            val pat = stringToExpressionStructurePattern(pattern)
            res.success(compareByPattern(ex, pat))
        }
    }
}
