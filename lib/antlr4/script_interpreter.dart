// ignore_for_file: unused_element

import 'dart:collection';

import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaBaseVisitor.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaLexer.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaParser.dart';
import 'package:basicchessendgamestrainer/antlr4/position_constraint_bail_error_strategy.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';

class CustomErrorListener extends BaseErrorListener {
  final void Function(
      {required String message,
      required String token,
      required int line,
      required int column}) onError;

  CustomErrorListener({required this.onError});

  @override
  void syntaxError(
      Recognizer<ATNSimulator> recognizer,
      Object? offendingSymbol,
      int? line,
      int charPositionInLine,
      String msg,
      RecognitionException<IntStream>? e) {
    if (recognizer is Parser) {
      onError(
        message: msg,
        token: (offendingSymbol == null || offendingSymbol is! Token)
            ? "#Unknown token#"
            : offendingSymbol.text!,
        line: line ?? -1,
        column: charPositionInLine + 1,
      );
    }
  }
}

class VariableIsNotAffectedException implements Exception {
  String varName;

  VariableIsNotAffectedException(this.varName);

  @override
  String toString() {
    return "VariableIsNotAffectedException($varName)";
  }
}

class MissingReturnStatementException implements Exception {}

class BailScriptLanguageLexer extends LuaLexer {
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
    final message = translations.unrecognizedSymbol(Symbol: offendingText);
    throw ParseCancellationException(message);
  }
}

class ParserError implements Exception {
  final ParserRuleContext context;

  ParserError({required this.context});

  int? getStartLine() => context.start?.line;
  int? getStartColumn() => context.start?.charPositionInLine;

  String? getFaultySource() => context.text;
}

class InvalidAssignementStatementException extends ParserError {
  InvalidAssignementStatementException({required super.context});
}

class MissingSomeStatementBlocksInIfExpressionException extends ParserError {
  MissingSomeStatementBlocksInIfExpressionException({required super.context});
}

class UndefinedVariableException extends ParserError {
  UndefinedVariableException({required super.context});
}

class ParenthesisWithoutExpressionException extends ParserError {
  ParenthesisWithoutExpressionException({required super.context});
}

class BuiltVariablesHolder {
  final TranslationsWrapper translations;
  final LinkedHashMap<String, dynamic> _builtVariables =
      LinkedHashMap<String, dynamic>();

  BuiltVariablesHolder(this.translations);

  bool contains(String name) => _builtVariables.containsKey(name);

  dynamic operator [](String name) {
    final expression = _builtVariables[name];
    if (expression == null) {
      throw ParseCancellationException(
          translations.variableNotAffected(Name: name));
    }
    return expression;
  }

  void operator []=(String key, dynamic value) {
    _builtVariables[key] = value;
  }

  void clearVariables() {
    _builtVariables.clear();
  }

  void addPredefinedValues(Map<String, dynamic> predefinedValues) {
    for (final currentName in predefinedValues.keys) {
      _builtVariables[currentName] = predefinedValues[currentName];
    }
  }

  LinkedHashMap<String, dynamic> getVariables() => _builtVariables;
}

class ScriptInterpreter extends LuaBaseVisitor<dynamic> {
  final TranslationsWrapper translations;
  final BuiltVariablesHolder _builtVariables;

  ScriptInterpreter({
    required this.translations,
  }) : _builtVariables = BuiltVariablesHolder(translations);

  LinkedHashMap<String, dynamic> interpretScript(
    String scriptString,
    Map<String, dynamic> predefinedValues,
  ) {
    final inputStream = InputStream.fromString(scriptString);
    final lexer =
        BailScriptLanguageLexer(translations: translations, input: inputStream);
    final tokens = CommonTokenStream(lexer);
    final parser = LuaParser(tokens);
    parser.errorHandler = PositionConstraintBailErrorStrategy(translations);
    final tree = parser.start_();
    _builtVariables.clearVariables();
    _builtVariables.addPredefinedValues(predefinedValues);
    visit(tree);
    return _builtVariables.getVariables();
  }

  @override
  visitReturnStat(ReturnStatContext ctx) {
    final value = ctx.exp();
    _builtVariables['return'] = value;
  }

  @override
  visitAssign(AssignContext ctx) {
    final hasNoAffectation = ctx.getToken(LuaParser.TOKEN_EQ, 0) == null;
    if (hasNoAffectation) {
      throw InvalidAssignementStatementException(context: ctx);
    }

    // we must first evaluate all values from expressions list
    final expListValue = ctx.explist();
    if (expListValue == null) {
      throw InvalidAssignementStatementException(context: ctx);
    }
    final values = visitExplist(expListValue);

    // then we can attribute values to variables
    final rawNamesList = ctx.namelist();
    if (rawNamesList == null) {
      throw InvalidAssignementStatementException(context: ctx);
    }
    final names = visitNamelist(rawNamesList);
    for (final (variableIndex, variableName) in names.indexed) {
      _builtVariables[variableName] =
          variableIndex(values.size >= variableIndex + 1)
              ? values[variableIndex]
              : null;
    }

    return null;
  }

  @override
  visitNamelist(NamelistContext ctx) {
    return ctx.NAMEs().map((currentName) => currentName.text);
  }

  @override
  visitExplist(ExplistContext ctx) {
    return ctx.exps().map((currentExpr) => visit(currentExpr));
  }

  @override
  visitIfstat(IfstatContext ctx) {
    final conditions = ctx.exps();
    final blocks = ctx.blocks();

    final hasElseBlock = ctx.getToken(LuaParser.TOKEN_ELSE, 0) != null;
    final expectedBlocksCount = conditions.length + (hasElseBlock ? 1 : 0);
    final hasEnoughConditionsAndBlocks = conditions.isNotEmpty &&
        blocks.isNotEmpty &&
        blocks.length == expectedBlocksCount;

    if (!hasEnoughConditionsAndBlocks) {
      throw MissingSomeStatementBlocksInIfExpressionException(context: ctx);
    }

    for (final (conditionIndex, conditionValue) in conditions.indexed) {
      if (evaluateCondition(conditionValue)) {
        return visit(blocks[conditionIndex]);
      }
    }

    if (blocks.length > conditions.length) {
      final lastBlockIndex = blocks.length - 1;
      return visit(blocks[lastBlockIndex]);
    }

    return null;
  }

  @override
  visitTrueExpr(TrueExprContext ctx) {
    return true;
  }

  @override
  visitFalseExpr(FalseExprContext ctx) {
    return false;
  }

  @override
  visitExponentExpr(ExponentExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);

    return left ^ right;
  }

  @override
  visitUnaryExpr(UnaryExprContext ctx) {
    final rawValue = ctx.exp();
    if (rawValue == null) throw UndefinedVariableException(context: ctx);

    final value = visit(rawValue);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_NOT => !value,
      LuaParser.TOKEN_MINUS => -value,
      _ => throw Exception("Unrecognized unary operator '$operator'")
    };
  }

  @override
  visitMulDivModuloExpr(MulDivModuloExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_STAR => left * right,
      LuaParser.TOKEN_SLASH => left / right,
      LuaParser.TOKEN_PER => left % right,
      LuaParser.TOKEN_SS => left / right,
      _ => throw Exception("Unrecognized mulDivModulo operator '$operator'"),
    };
  }

  @override
  visitPlusMinusExpr(PlusMinusExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_PLUS => left + right,
      LuaParser.TOKEN_MINUS => left - right,
      _ => throw Exception("Unrecognized plusMinus operator '$operator'"),
    };
  }

  @override
  visitBooleanBinaryLogicalExpr(BooleanBinaryLogicalExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_LT => left < right,
      LuaParser.TOKEN_GT => left > right,
      LuaParser.TOKEN_LE => left <= right,
      LuaParser.TOKEN_GE => left >= right,
      LuaParser.TOKEN_EE => left == right,
      LuaParser.TOKEN_SQEQ => left != right,
      _ => throw Exception("Unrecognized boolean binary operator '$operator'"),
    };
  }

  @override
  visitBooleanAndExpr(BooleanAndExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);

    return left && right;
  }

  @override
  visitBooleanOrExpr(BooleanOrExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);

    return left || right;
  }

  @override
  visitIntBinaryLogicalExpr(IntBinaryLogicalExprContext ctx) {
    final rawLeft = ctx.exp(0);
    final rawRight = ctx.exp(1);

    if (rawLeft == null || rawRight == null) {
      throw UndefinedVariableException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_AMP => left & right,
      LuaParser.TOKEN_PIPE => left | right,
      LuaParser.TOKEN_SQUIG => left ^ right,
      LuaParser.TOKEN_LL => left << right,
      LuaParser.TOKEN_GG => left >> right,
      _ => throw Exception("Unrecognized integer binary operator '$operator'"),
    };
  }

  @override
  visitVariablePrefix(VariablePrefixContext ctx) {
    return _builtVariables[ctx.text];
  }

  @override
  visitParenthesisPrefix(ParenthesisPrefixContext ctx) {
    final rawExp = ctx.exp();

    if (rawExp == null) {
      throw ParenthesisWithoutExpressionException(context: ctx);
    }

    return visit(rawExp);
  }

  @override
  visitIntegerValue(IntegerValueContext ctx) {
    return int.parse(ctx.text);
  }

  bool evaluateCondition(ExpContext ctx) {
    return visit(ctx) ?? false;
  }
}
