import 'package:basicchessendgamestrainer/antlr4/script_language_builder.dart';

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

/*
ScriptLanguageGenericExpr transformIntExpression(
  ScriptLanguageNumericExpr expression,
  BuiltVariablesHolder builtVariables,
) {}

ScriptLanguageGenericExpr transformBooleanExpression(
  ScriptLanguageBooleanExpr expression,
  BuiltVariablesHolder builtVariables,
) {}
*/

int evaluateIntExpression(
  ScriptLanguageNumericExpr expression,
  Map<String, int> intVariablesValues,
  Map<String, bool> boolVariablesValues,
) {
  return switch (expression) {
    ParenthesisScriptLanguageNumericExpr(expression: var expression) =>
      evaluateIntExpression(
          expression, intVariablesValues, boolVariablesValues),
    ConditionalScriptLanguageNumericExpr(
      condition: var condition,
      successExpression: var successExpression,
      failureExpression: var failureExpression,
    ) =>
      evaluateBoolExpression(
        condition,
        intVariablesValues,
        boolVariablesValues,
      )
          ? evaluateIntExpression(
              successExpression,
              intVariablesValues,
              boolVariablesValues,
            )
          : evaluateIntExpression(
              failureExpression,
              intVariablesValues,
              boolVariablesValues,
            ),
    AbsoluteScriptLanguageNumericExpr(expression: var expression) =>
      evaluateIntExpression(
        expression,
        intVariablesValues,
        boolVariablesValues,
      ),
    LiteralScriptLanguageNumericExpr(value: var value) => value,
    VariableScriptLanguageNumericExpr(name: var name) =>
      intVariablesValues.containsKey(name)
          ? intVariablesValues[name]!
          : throw VariableIsNotAffectedException(name),
    ModuloScriptLanguageNumericExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) %
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    PlusOperatorScriptLanguageNumericExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) +
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    MinusOperatorScriptLanguageNumericExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) -
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    _ => throw Exception("Int operation not recognized: $expression"),
  };
}

bool evaluateBoolExpression(
  ScriptLanguageBooleanExpr expression,
  Map<String, int> intVariablesValues,
  Map<String, bool> boolVariablesValues,
) {
  return switch (expression) {
    ParenthesisScriptLanguageBooleanExpr(expression: var expression) =>
      evaluateBoolExpression(
        expression,
        intVariablesValues,
        boolVariablesValues,
      ),
    ConditionalScriptLanguageBooleanExpr(
      condition: var condition,
      successExpression: var successExpression,
      failureExpression: var failureExpression,
    ) =>
      evaluateBoolExpression(
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
            ),
    VariableScriptLanguageBooleanExpr(name: var name) =>
      boolVariablesValues.containsKey(name)
          ? boolVariablesValues[name]!
          : throw VariableIsNotAffectedException(name),
    LowerThanScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) <
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    GreaterThanScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) >
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    LowerOrEqualToScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) <=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    GreaterOrEqualToScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) >=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    EqualToScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) ==
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    NotEqualToScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateIntExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) !=
          evaluateIntExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    AndComparisonScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateBoolExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) &&
          evaluateBoolExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    OrComparisonScriptLanguageBooleanExpr(
      expressionLeft: var left,
      expressionRight: var right
    ) =>
      evaluateBoolExpression(
            left,
            intVariablesValues,
            boolVariablesValues,
          ) &&
          evaluateBoolExpression(
            right,
            intVariablesValues,
            boolVariablesValues,
          ),
    LiteralScriptLanguageBooleanExpr(value: var value) => value,
    _ => throw Exception("Bool operation not recognized: $expression"),
  };
}
