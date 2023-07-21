// ignore_for_file: unused_element

import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/ScriptLanguageBaseVisitor.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/ScriptLanguageLexer.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/ScriptLanguageParser.dart';
import 'package:basicchessendgamestrainer/antlr4/position_constraint_bail_error_strategy.dart';
import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';

class BailScriptLanguageLexer extends ScriptLanguageLexer {
  final CharStream input;
  final TranslationsWrapper translations;

  BailScriptLanguageLexer({
    required this.translations,
    required this.input,
  }) : super(input);

  @override
  void recover(RecognitionException<IntStream> re) {
    final inputStream = re.inputStream as CharStream;
    final offendingText = inputStream
        .getText(Interval.of(tokenStartCharIndex, inputStream.index));
    final message = translations.unrecognizedSymbol(offendingText);
    throw ParseCancellationException(message);
  }
}

class BuiltVariablesHolder {
  final TranslationsWrapper translations;
  final _builtVariables = <String, ScriptLanguageGenericExpr>{};

  BuiltVariablesHolder(this.translations);

  void set(String name, ScriptLanguageGenericExpr value) =>
      _builtVariables[name] = value;

  bool contains(String name) => _builtVariables.containsKey(name);

  ScriptLanguageGenericExpr operator [](String name) {
    final expression = _builtVariables[name];
    if (expression == null) {
      throw ParseCancellationException(translations.variableNotAffected(name));
    }
    return expression;
  }

  void clearVariables() {
    _builtVariables.clear();
  }

  Map<String, ScriptLanguageGenericExpr> getVariables() => _builtVariables;
}

class ScriptLanguageBuilder
    extends ScriptLanguageBaseVisitor<ScriptLanguageGenericExpr> {
  final TranslationsWrapper translations;
  final BuiltVariablesHolder _builtVariables;

  ScriptLanguageBuilder({
    required this.translations,
  }) : _builtVariables = BuiltVariablesHolder(translations);

  void _checkIfScriptStringIsValid(
    String scriptString,
    Map<String, int> sampleIntValues,
    Map<String, bool> sampleBooleanValues,
  ) {
    final resultExpression = buildExpressionObjectFromScript(scriptString);
    if (resultExpression == null) {
      throw ParseCancellationException(translations.miscParseError);
    }
    _testCanEvaluateExpressionWithDefaultVariablesSetAndThrowEventualError(
      resultExpression,
      sampleIntValues,
      sampleBooleanValues,
    );
  }

  ScriptLanguageBooleanExpr? buildExpressionObjectFromScript(
      String scriptString) {
    final inputStream = InputStream.fromString(scriptString);
    final lexer =
        BailScriptLanguageLexer(translations: translations, input: inputStream);
    final tokens = CommonTokenStream(lexer);
    final parser = ScriptLanguageParser(tokens);
    parser.errorHandler = PositionConstraintBailErrorStrategy(translations);
    final tree = parser.scriptLanguage();
    _builtVariables.clearVariables();
    final result = visit(tree);
    return result as ScriptLanguageBooleanExpr?;
  }

  _testCanEvaluateExpressionWithDefaultVariablesSetAndThrowEventualError(
    ScriptLanguageBooleanExpr expr,
    Map<String, int> sampleIntValues,
    Map<String, bool> sampleBooleanValues,
  ) {
    final intValues = sampleIntValues;
    final boolValues = sampleBooleanValues;

    final variables = _builtVariables.getVariables();
    // We must evaluate all variables before evaluating the final script expression
    for (var currentVariable in variables.entries) {
      switch (currentVariable.value) {
        case ScriptLanguageNumericExpr():
          {
            if (sampleIntValues.containsKey(currentVariable.key)) {
              throw ParseCancellationException(translations
                  .overridingPredefinedVariable(currentVariable.key));
            } else {
              intValues[currentVariable.key] = evaluateIntExpression(
                currentVariable.value as ScriptLanguageNumericExpr,
                intValues,
                boolValues,
              );
            }
          }
        case ScriptLanguageBooleanExpr():
          {
            if (sampleBooleanValues.containsKey(currentVariable.key)) {
              throw ParseCancellationException(translations
                  .overridingPredefinedVariable(currentVariable.key));
            } else {
              boolValues[currentVariable.key] = evaluateBoolExpression(
                currentVariable.value as ScriptLanguageBooleanExpr,
                intValues,
                boolValues,
              );
            }
          }
      }
    }

    evaluateBoolExpression(
      expr,
      intValues,
      boolValues,
    );
  }

  @override
  ScriptLanguageGenericExpr? visitScriptLanguage(ScriptLanguageContext ctx) {
    final result = visit(ctx.terminalExpr()!)!;
    return result;
  }

  @override
  ScriptLanguageGenericExpr? visitTerminalExpr(TerminalExprContext ctx) {
    final result = visit(ctx.booleanExpr()!)!;
    return result;
  }

  @override
  ScriptLanguageGenericExpr? visitNumericAssign(NumericAssignContext ctx) {
    final variableName = ctx.ID()!.text.toString();
    final variableValue =
        visit(ctx.numericExpr()!)! as ScriptLanguageNumericExpr;

    _builtVariables.set(variableName, variableValue);
    return UnitScriptLanguageGenericExpr();
  }

  @override
  ScriptLanguageGenericExpr? visitBooleanAssign(BooleanAssignContext ctx) {
    final variableName = ctx.ID()!.text.toString();
    final variableValue =
        visit(ctx.booleanExpr()!)! as ScriptLanguageBooleanExpr;

    _builtVariables.set(variableName, variableValue);
    return UnitScriptLanguageGenericExpr();
  }

  @override
  ScriptLanguageGenericExpr? visitParenthesisBooleanExpr(
      ParenthesisBooleanExprContext ctx) {
    final internalExpr =
        visit(ctx.booleanExpr()!)! as ScriptLanguageBooleanExpr;
    return ParenthesisScriptLanguageBooleanExpr(internalExpr);
  }

  @override
  ScriptLanguageGenericExpr? visitConditionalBooleanExpr(
      ConditionalBooleanExprContext ctx) {
    final conditionalExpr =
        visit(ctx.booleanExpr(0)!) as ScriptLanguageBooleanExpr;
    final successExpr = visit(ctx.booleanExpr(1)!) as ScriptLanguageBooleanExpr;
    final failureExpr = visit(ctx.booleanExpr(2)!) as ScriptLanguageBooleanExpr;

    return ConditionalScriptLanguageBooleanExpr(
      condition: conditionalExpr,
      successExpression: successExpr,
      failureExpression: failureExpr,
    );
  }

  @override
  ScriptLanguageGenericExpr? visitBooleanVariable(BooleanVariableContext ctx) {
    final variableName = ctx.ID()!.text.toString();
    return _builtVariables.contains(variableName)
        ? _builtVariables[variableName]
        : VariableScriptLanguageBooleanExpr(variableName);
  }

  @override
  ScriptLanguageGenericExpr? visitNumericRelational(
      NumericRelationalContext ctx) {
    final left = visit(ctx.numericExpr(0)!) as ScriptLanguageNumericExpr;
    final right = visit(ctx.numericExpr(1)!) as ScriptLanguageNumericExpr;
    final op = ctx.op!.text!.toString();

    return switch (op) {
      "<" => LowerThanScriptLanguageBooleanExpr(left, right),
      ">" => GreaterThanScriptLanguageBooleanExpr(left, right),
      "<=" => LowerOrEqualToScriptLanguageBooleanExpr(left, right),
      ">=" => GreaterOrEqualToScriptLanguageBooleanExpr(left, right),
      _ => throw Exception("Unknown operator $op"),
    };
  }

  @override
  ScriptLanguageGenericExpr? visitNumericEquality(NumericEqualityContext ctx) {
    final left = visit(ctx.numericExpr(0)!) as ScriptLanguageNumericExpr;
    final right = visit(ctx.numericExpr(1)!) as ScriptLanguageNumericExpr;
    final op = ctx.op!.text!.toString();

    return switch (op) {
      "=" => EqualToScriptLanguageBooleanExpr(left, right),
      "<>" => NotEqualToScriptLanguageBooleanExpr(left, right),
      _ => throw Exception("Unknown operator $op"),
    };
  }

  @override
  ScriptLanguageGenericExpr? visitAndComparison(AndComparisonContext ctx) {
    final left = visit(ctx.booleanExpr(0)!) as ScriptLanguageBooleanExpr;
    final right = visit(ctx.booleanExpr(1)!) as ScriptLanguageBooleanExpr;

    return AndComparisonScriptLanguageBooleanExpr(left, right);
  }

  @override
  ScriptLanguageGenericExpr? visitOrComparison(OrComparisonContext ctx) {
    final left = visit(ctx.booleanExpr(0)!) as ScriptLanguageBooleanExpr;
    final right = visit(ctx.booleanExpr(1)!) as ScriptLanguageBooleanExpr;

    return OrComparisonScriptLanguageBooleanExpr(left, right);
  }

  @override
  ScriptLanguageGenericExpr? visitParenthesisNumericExpr(
      ParenthesisNumericExprContext ctx) {
    final internalExpr = visit(ctx.numericExpr()!) as ScriptLanguageNumericExpr;
    return ParenthesisScriptLanguageNumericExpr(internalExpr);
  }

  @override
  ScriptLanguageGenericExpr? visitConditionalNumericExpr(
      ConditionalNumericExprContext ctx) {
    final conditionalExpr =
        visit(ctx.booleanExpr()!) as ScriptLanguageBooleanExpr;
    final successExpr = visit(ctx.numericExpr(0)!) as ScriptLanguageNumericExpr;
    final failureExpr = visit(ctx.numericExpr(1)!) as ScriptLanguageNumericExpr;

    return ConditionalScriptLanguageNumericExpr(
      condition: conditionalExpr,
      successExpression: successExpr,
      failureExpression: failureExpr,
    );
  }

  @override
  ScriptLanguageGenericExpr? visitAbsoluteNumericExpr(
      AbsoluteNumericExprContext ctx) {
    final internalExpr = visit(ctx.numericExpr()!) as ScriptLanguageNumericExpr;
    return AbsoluteScriptLanguageNumericExpr(internalExpr);
  }

  @override
  ScriptLanguageGenericExpr? visitLitteralNumericExpr(
      LitteralNumericExprContext ctx) {
    final internalExpr = int.parse(ctx.NumericLitteral()!.text.toString());
    return LiteralScriptLanguageNumericExpr(internalExpr);
  }

  @override
  ScriptLanguageGenericExpr? visitNumericVariable(NumericVariableContext ctx) {
    final variableName = ctx.ID()!.text.toString();
    return _builtVariables.contains(variableName)
        ? _builtVariables[variableName]
        : VariableScriptLanguageNumericExpr(variableName);
  }

  @override
  ScriptLanguageGenericExpr? visitFileConstantNumericExpr(
      FileConstantNumericExprContext ctx) {
    final constantText = ctx.fileConstant()!.text.toString();
    final literalValue = switch (constantText) {
      "FileA" => PositionConstraints.fileA,
      "FileB" => PositionConstraints.fileB,
      "FileC" => PositionConstraints.fileC,
      "FileD" => PositionConstraints.fileD,
      "FileE" => PositionConstraints.fileE,
      "FileF" => PositionConstraints.fileF,
      "FileG" => PositionConstraints.fileG,
      "FileH" => PositionConstraints.fileH,
      _ => throw Exception("Constant $constantText is not a file constant.")
    };
    return LiteralScriptLanguageNumericExpr(literalValue);
  }

  @override
  ScriptLanguageGenericExpr? visitRankConstantNumericExpr(
      RankConstantNumericExprContext ctx) {
    final constantText = ctx.rankConstant()!.text.toString();
    final literalValue = switch (constantText) {
      "Rank1" => PositionConstraints.rank1,
      "Rank2" => PositionConstraints.rank2,
      "Rank3" => PositionConstraints.rank3,
      "Rank4" => PositionConstraints.rank4,
      "Rank5" => PositionConstraints.rank5,
      "Rank6" => PositionConstraints.rank6,
      "Rank7" => PositionConstraints.rank7,
      "Rank8" => PositionConstraints.rank8,
      _ => throw Exception("Constant $constantText is not a rank constant.")
    };
    return LiteralScriptLanguageNumericExpr(literalValue);
  }

  @override
  ScriptLanguageGenericExpr? visitModuloNumericExpr(
      ModuloNumericExprContext ctx) {
    final left = visit(ctx.numericExpr(0)!) as ScriptLanguageNumericExpr;
    final right = visit(ctx.numericExpr(1)!) as ScriptLanguageNumericExpr;

    return ModuloScriptLanguageNumericExpr(left, right);
  }

  @override
  ScriptLanguageGenericExpr? visitPlusMinusNumericExpr(
      PlusMinusNumericExprContext ctx) {
    final left = visit(ctx.numericExpr(0)!) as ScriptLanguageNumericExpr;
    final right = visit(ctx.numericExpr(1)!) as ScriptLanguageNumericExpr;
    final op = ctx.op!.text.toString();

    return switch (op) {
      "+" => PlusOperatorScriptLanguageNumericExpr(left, right),
      "-" => MinusOperatorScriptLanguageNumericExpr(left, right),
      _ => throw Exception("Unknown operator $op"),
    };
  }

  PositionGenerationError? checkIfScriptIsValid({
    required String scriptString,
    required String scriptSectionTitle,
    required Map<String, int> sampleIntValues,
    required Map<String, bool> sampleBooleanValues,
  }) {
    if (scriptString.isEmpty) {
      return null;
    }

    try {
      _checkIfScriptStringIsValid(
        scriptString,
        sampleIntValues,
        sampleBooleanValues,
      );
      return null;
    } on VariableIsNotAffectedException catch (ex) {
      final message = translations.variableNotAffected(ex.varName);
      final title = translations.parseErrorDialogTitle(scriptSectionTitle);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return PositionGenerationError(title, message);
    } on ParseCancellationException catch (ex) {
      final message = ex.message;
      final title = translations.parseErrorDialogTitle(scriptSectionTitle);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return PositionGenerationError(title, message);
    } on TypeError {
      final message = translations.typeError;
      final title = translations.parseErrorDialogTitle(scriptSectionTitle);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return PositionGenerationError(title, message);
    }
  }
}
