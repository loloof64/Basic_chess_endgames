class VariableIsNotAffectedException implements Exception {
  String varName;

  VariableIsNotAffectedException(this.varName);
}

abstract class ScriptLanguageGenericExpr {}

class UnitScriptLanguageGenericExpr extends ScriptLanguageGenericExpr {}

abstract class ScriptLanguageBooleanExpr extends ScriptLanguageGenericExpr {}

abstract class ScriptLanguageNumericExpr extends ScriptLanguageGenericExpr {}

/* Boolean variants */

class ParenthesisScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageBooleanExpr expression;

  ParenthesisScriptLanguageBooleanExpr(this.expression);
}

class ConditionalScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageBooleanExpr condition;
  final ScriptLanguageBooleanExpr successExpression;
  final ScriptLanguageBooleanExpr failureExpression;

  ConditionalScriptLanguageBooleanExpr({
    required this.condition,
    required this.successExpression,
    required this.failureExpression,
  });
}

class VariableScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final String name;

  VariableScriptLanguageBooleanExpr(this.name);
}

class LowerThanScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  LowerThanScriptLanguageBooleanExpr(this.expressionLeft, this.expressionRight);
}

class GreaterThanScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  GreaterThanScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class LowerOrEqualToScriptLanguageBooleanExpr
    extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  LowerOrEqualToScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class GreaterOrEqualToScriptLanguageBooleanExpr
    extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  GreaterOrEqualToScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class EqualToScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  EqualToScriptLanguageBooleanExpr(this.expressionLeft, this.expressionRight);
}

class NotEqualToScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  NotEqualToScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class AndComparisonScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageBooleanExpr expressionLeft;
  final ScriptLanguageBooleanExpr expressionRight;

  AndComparisonScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class OrComparisonScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final ScriptLanguageBooleanExpr expressionLeft;
  final ScriptLanguageBooleanExpr expressionRight;

  OrComparisonScriptLanguageBooleanExpr(
      this.expressionLeft, this.expressionRight);
}

class LiteralScriptLanguageBooleanExpr extends ScriptLanguageBooleanExpr {
  final bool value;

  LiteralScriptLanguageBooleanExpr(this.value);
}

/* Numeric variants */

class ParenthesisScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageNumericExpr expression;

  ParenthesisScriptLanguageNumericExpr(this.expression);
}

class ConditionalScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageBooleanExpr condition;
  final ScriptLanguageNumericExpr successExpression;
  final ScriptLanguageNumericExpr failureExpression;

  ConditionalScriptLanguageNumericExpr({
    required this.condition,
    required this.successExpression,
    required this.failureExpression,
  });
}

class AbsoluteScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageNumericExpr expression;

  AbsoluteScriptLanguageNumericExpr(this.expression);
}

class LiteralScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final int value;

  LiteralScriptLanguageNumericExpr(this.value);
}

class VariableScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final String name;

  VariableScriptLanguageNumericExpr(this.name);
}

class ModuloScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  ModuloScriptLanguageNumericExpr(this.expressionLeft, this.expressionRight);
}

class PlusOperatorScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  PlusOperatorScriptLanguageNumericExpr(
      this.expressionLeft, this.expressionRight);
}

class MinusOperatorScriptLanguageNumericExpr extends ScriptLanguageNumericExpr {
  final ScriptLanguageNumericExpr expressionLeft;
  final ScriptLanguageNumericExpr expressionRight;

  MinusOperatorScriptLanguageNumericExpr(
      this.expressionLeft, this.expressionRight);
}

int evaluateIntExpression(
  ScriptLanguageNumericExpr expression,
  Map<String, int> intVariablesValues,
  Map<String, bool> boolVariablesValues,
) {
  switch (expression) {
    case ParenthesisScriptLanguageNumericExpr(expression: var expression):
      return evaluateIntExpression(
          expression, intVariablesValues, boolVariablesValues);
    case ConditionalScriptLanguageNumericExpr(
        condition: var condition,
        successExpression: var successExpression,
        failureExpression: var failureExpression,
      ):
      {
        final conditionEvaluated = evaluateBoolExpression(
          condition,
          intVariablesValues,
          boolVariablesValues,
        );
        return conditionEvaluated
            ? evaluateIntExpression(
                successExpression,
                intVariablesValues,
                boolVariablesValues,
              )
            : evaluateIntExpression(
                failureExpression,
                intVariablesValues,
                boolVariablesValues,
              );
      }
    case AbsoluteScriptLanguageNumericExpr(expression: var expression):
      return evaluateIntExpression(
        expression,
        intVariablesValues,
        boolVariablesValues,
      );
    case LiteralScriptLanguageNumericExpr(value: var value):
      return value;
    case VariableScriptLanguageNumericExpr(name: var name):
      if (intVariablesValues.containsKey(name)) {
        return intVariablesValues[name]!;
      } else {
        throw VariableIsNotAffectedException(name);
      }
    case ModuloScriptLanguageNumericExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) %
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case PlusOperatorScriptLanguageNumericExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) +
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case MinusOperatorScriptLanguageNumericExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) -
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    default:
      throw Exception("Int operation not recognized: $expression");
  }
}

bool evaluateBoolExpression(
  ScriptLanguageBooleanExpr expression,
  Map<String, int> intVariablesValues,
  Map<String, bool> boolVariablesValues,
) {
  switch (expression) {
    case ParenthesisScriptLanguageBooleanExpr(expression: var expression):
      return evaluateBoolExpression(
        expression,
        intVariablesValues,
        boolVariablesValues,
      );
    case ConditionalScriptLanguageBooleanExpr(
        condition: var condition,
        successExpression: var successExpression,
        failureExpression: var failureExpression,
      ):
      return evaluateBoolExpression(
        condition,
        intVariablesValues,
        boolVariablesValues,
      )
          ? evaluateBoolExpression(
              successExpression,
              intVariablesValues,
              boolVariablesValues,
            )
          : evaluateBoolExpression(
              failureExpression,
              intVariablesValues,
              boolVariablesValues,
            );
    case VariableScriptLanguageBooleanExpr(name: var name):
      if (boolVariablesValues.containsKey(name)) {
        return boolVariablesValues[name]!;
      } else {
        throw VariableIsNotAffectedException(name);
      }
    case LowerThanScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) <
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case GreaterThanScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) >
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case LowerOrEqualToScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) <=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case GreaterOrEqualToScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) >=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case EqualToScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) ==
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case NotEqualToScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) !=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case AndComparisonScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateBoolExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) &&
          evaluateBoolExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case OrComparisonScriptLanguageBooleanExpr(
        expressionLeft: var left,
        expressionRight: var right
      ):
      return evaluateBoolExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) &&
          evaluateBoolExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          );
    case LiteralScriptLanguageBooleanExpr(value: var value):
      return value;
    default:
      throw Exception("Bool operation not recognized: $expression");
  }
}
