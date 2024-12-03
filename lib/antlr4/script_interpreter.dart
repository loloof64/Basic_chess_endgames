// ignore_for_file: unused_element

import 'dart:collection';

import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaBaseVisitor.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaLexer.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/LuaParser.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_antlr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';

enum SyntaxTypes {
  int,
  bool;

  String translate(TranslationsWrapper translations) {
    return switch (this) {
      int => translations.scriptTypeInt,
      bool => translations.scriptTypeBool,
    };
  }
}

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

class MissingReturnStatementException implements Exception {}

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

class UnaryExpressionWithoutValueException extends ParserError {
  UnaryExpressionWithoutValueException({required super.context});
}

class InvalidExpressionTypeException extends ParserError {
  final SyntaxTypes expected;
  final SyntaxTypes got;
  final String operator;

  InvalidExpressionTypeException({
    required super.context,
    required this.expected,
    required this.got,
    required this.operator,
  });
}

class MissingValueInExponentExpressionException extends ParserError {
  MissingValueInExponentExpressionException({required super.context});
}

class MissingValueInBinaryExpressionException extends ParserError {
  final String operator;

  MissingValueInBinaryExpressionException(
      {required super.context, required this.operator});
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

class InterpretationError implements Exception {
  final String message;
  final String position;
  final String scriptType;

  InterpretationError({
    required this.message,
    this.position = "",
    this.scriptType = "",
  });

  InterpretationError withScriptType(String newScriptType) {
    return InterpretationError(
      message: message,
      position: position,
      scriptType: newScriptType,
    );
  }

  InterpretationError withComplexScriptType({
    required String typeLabel,
    required PieceKind pieceKind,
    required TranslationsWrapper translations,
  }) {
    return InterpretationError(
      message: message,
      position: position,
      scriptType: "$typeLabel [${pieceKind.toLocalizedEasyString(
        translations: translations,
      )}]",
    );
  }
}

class ScriptInterpreter extends LuaBaseVisitor<dynamic> {
  final TranslationsWrapper translations;
  final BuiltVariablesHolder _builtVariables;
  final List<InterpretationError> _errors = [];

  ScriptInterpreter({
    required this.translations,
  }) : _builtVariables = BuiltVariablesHolder(translations);

  List<InterpretationError> getErrors() => [..._errors];

  LinkedHashMap<String, dynamic>? interpretScript(
    String scriptString,
    Map<String, dynamic> predefinedValues,
  ) {
    _errors.clear();
    try {
      final inputStream = InputStream.fromString(scriptString);
      final lexer = LuaLexer(inputStream);
      lexer.removeErrorListeners();
      lexer.addErrorListener(
        CustomErrorListener(onError: _handleSyntaxtError),
      );
      final tokens = CommonTokenStream(lexer);
      final parser = LuaParser(tokens);
      parser.removeErrorListeners();
      parser.addErrorListener(
        CustomErrorListener(onError: _handleSyntaxtError),
      );
      final tree = parser.start_();
      _builtVariables.clearVariables();
      _builtVariables.addPredefinedValues(predefinedValues);
      visit(tree);
      return _builtVariables.getVariables();
    } on ParserError catch (e) {
      _handleParserError(e);
      return null;
    } on Exception catch (e) {
      _handleMiscError(e);
      return null;
    }
  }

  void _handleParserError(ParserError error) {
    String description = switch (error) {
      UndefinedVariableException() =>
        translations.variableNotAffected(Name: error.getFaultySource()!),
      MissingSomeStatementBlocksInIfExpressionException() =>
        translations.errorIfStatementMissingBlock,
      InvalidAssignementStatementException() => translations.invalidAssignment,
      ParenthesisWithoutExpressionException() =>
        translations.parenthesisWithoutExpression,
      UnaryExpressionWithoutValueException() =>
        translations.unaryExpressionWithoutValue,
      InvalidExpressionTypeException(
        expected: final expected,
        got: final got,
        operator: final operator,
      ) =>
        translations.invalidExpressionType(
          Expected: expected.translate(translations),
          Got: got.translate(translations),
          Operator: operator,
        ),
      MissingValueInExponentExpressionException() =>
        translations.missingValueInExponentExpression,
      MissingValueInBinaryExpressionException(
        operator: final String operator
      ) =>
        translations.missingValueInBinaryExpression(Operator: operator),
      _ => throw Exception("Not a known Parser Error $error"),
    };

    description =
        description.replaceAll("<EOF>", translations.errorSubstitutionEOF);
    description = description.replaceAll(
        "NAME", translations.errorSubstitutionVariableName);
    description =
        description.replaceAll("INT", translations.errorSubstitutionInteger);

    final position = "${error.getStartLine()!}:${error.getStartColumn()! + 1}";

    _errors.add(InterpretationError(
        message: description, position: position, scriptType: ""));
  }

  void _handleMiscError(Exception error) {
    const position = "";
    final description = translations.miscSyntaxErrorUnknownToken;
    _errors.add(InterpretationError(
        message: description, position: position, scriptType: ""));
  }

  void _handleSyntaxtError({
    required int column,
    required int line,
    required String message,
    required String token,
  }) {
    String description = "";
    if (message.contains("mismatched input")) {
      final messageParts = message.split("expecting ");
      final expectedToken = messageParts[1];
      description = translations.wrongTokenAlternatives(
        Symbol: token,
        ExpectedSymbols: expectedToken,
      );
    } else if (message.contains("extraneous input")) {
      final messagePartsV1 = message.split("expecting '"); // for misc tokens
      final messagePartsV2 = message.split("expecting "); // for <EOF>
      String expectedToken = "";
      if (messagePartsV1.length > 1) {
        final word = messagePartsV1.sublist(1).first;
        expectedToken = word.split("").sublist(0, word.length - 1).join("");
      } else {
        expectedToken = messagePartsV2.sublist(1).first;
      }
      description = translations.wrongTokenAlternatives(
        Symbol: token,
        ExpectedSymbols: expectedToken,
      );
    } else if (message.contains("missing NAME at ")) {
      description = translations.invalidAssignment;
    } else if (message.contains("missing '")) {
      final messageParts = message.split("missing '");
      final expectedToken = messageParts.sublist(1).first.split("'").first;
      description = translations.wrongTokenAlternatives(
        Symbol: token,
        ExpectedSymbols: expectedToken,
      );
    } else if (message.contains("token recognition error at")) {
      description = translations.unrecognizedSymbol(Symbol: token);
    } else {
      description = translations.miscSyntaxError(Symbol: token);
    }
    description =
        description.replaceAll("<EOF>", translations.errorSubstitutionEOF);
    description = description.replaceAll(
        "NAME", translations.errorSubstitutionVariableName);
    description =
        description.replaceAll("INT", translations.errorSubstitutionInteger);

    final position = "$line:$column";
    _errors.add(InterpretationError(
        message: description, position: position, scriptType: ""));
  }

  @override
  visitReturnStat(ReturnStatContext ctx) {
    final rawValue = ctx.exp();
    if (rawValue == null) {
      throw ReturnedValueNotABooleanException();
    }
    final value = visit(rawValue);
    if (value == null) {
      throw ReturnedValueNotABooleanException();
    }
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
    final namesIndexes = Iterable<int>.generate(names.length).toList();
    for (final variableIndex in namesIndexes) {
      final variableName = names[variableIndex];
      try {
        _builtVariables[variableName] =
            (values.length >= variableIndex + 1) ? values[variableIndex] : null;
      } on ParseCancellationException {
        throw UndefinedVariableException(context: ctx);
      }
    }

    return null;
  }

  @override
  visitNamelist(NamelistContext ctx) {
    return ctx.NAMEs().map((currentName) => currentName.text).toList();
  }

  @override
  visitExplist(ExplistContext ctx) {
    return ctx.exps().map((currentExpr) => visit(currentExpr)).toList();
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
      throw MissingValueInExponentExpressionException(context: ctx);
    }

    final left = visit(rawLeft);
    final right = visit(rawRight);

    if (left == null || right == null) {
      throw MissingValueInExponentExpressionException(context: ctx);
    }

    if (left is! int || right is! int) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.int,
        got: SyntaxTypes.bool,
        operator: '^',
      );
    }

    return left ^ right;
  }

  @override
  visitUnaryExpr(UnaryExprContext ctx) {
    final rawValue = ctx.exp();
    if (rawValue == null) {
      throw UnaryExpressionWithoutValueException(context: ctx);
    }

    final value = visit(rawValue);
    if (value == null) throw UnaryExpressionWithoutValueException(context: ctx);
    final operator = ctx.op?.type;

    return switch (operator) {
      LuaParser.TOKEN_NOT => {
          if (value is! bool)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.bool,
                got: SyntaxTypes.int,
                operator: ctx.op!.text!,
              )
            }
          else
            {!value}
        },
      LuaParser.TOKEN_MINUS => {
          if (value is! int)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.int,
                got: SyntaxTypes.bool,
                operator: ctx.op!.text!,
              )
            }
          else
            {-value}
        },
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
    final operator = ctx.op!.type;

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: ctx.op!.text!,
      );
    }

    if (left is! int || right is! int) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.int,
        got: SyntaxTypes.bool,
        operator: ctx.op!.text!,
      );
    }

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
    final operator = ctx.op!.type;

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: ctx.op!.text!,
      );
    }

    if (left is! int || right is! int) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.int,
        got: SyntaxTypes.bool,
        operator: ctx.op!.text!,
      );
    }

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
    final operator = ctx.op!.type;

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: ctx.op!.text!,
      );
    }

    if (left is! int || right is! int) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.int,
        got: SyntaxTypes.bool,
        operator: ctx.op!.text!,
      );
    }

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

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: "and",
      );
    }

    if (left is! bool || right is! bool) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.bool,
        got: SyntaxTypes.int,
        operator: "and",
      );
    }

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

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: "or",
      );
    }

    if (left is! bool || right is! bool) {
      throw InvalidExpressionTypeException(
        context: ctx,
        expected: SyntaxTypes.bool,
        got: SyntaxTypes.int,
        operator: "or",
      );
    }

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
    final operator = ctx.op!.type;

    if (left == null || right == null) {
      throw MissingValueInBinaryExpressionException(
        context: ctx,
        operator: ctx.op!.text!,
      );
    }

    return switch (operator) {
      LuaParser.TOKEN_AMP => {
          if (left is! bool || right is! bool)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.bool,
                got: SyntaxTypes.int,
                operator: ctx.op!.text!,
              )
            }
          else
            {
              left & right,
            }
        },
      LuaParser.TOKEN_PIPE => {
          if (left is! bool || right is! bool)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.bool,
                got: SyntaxTypes.int,
                operator: ctx.op!.text!,
              )
            }
          else
            {left | right},
        },
      LuaParser.TOKEN_SQUIG => {
          if (left is! bool || right is! bool)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.bool,
                got: SyntaxTypes.int,
                operator: ctx.op!.text!,
              )
            }
          else
            {left ^ right},
        },
      LuaParser.TOKEN_LL => {
          if (left is! int || right is! int)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.int,
                got: SyntaxTypes.bool,
                operator: ctx.op!.text!,
              )
            }
          else
            {left << right},
        },
      LuaParser.TOKEN_GG => {
          if (left is! int || right is! int)
            {
              throw InvalidExpressionTypeException(
                context: ctx,
                expected: SyntaxTypes.int,
                got: SyntaxTypes.bool,
                operator: ctx.op!.text!,
              )
            }
          else
            {left >> right},
        },
      _ => throw Exception("Unrecognized integer binary operator '$operator'"),
    };
  }

  @override
  visitVariablePrefix(VariablePrefixContext ctx) {
    try {
      return _builtVariables[ctx.text];
    } on ParseCancellationException {
      throw UndefinedVariableException(context: ctx);
    }
  }

  @override
  visitParenthesisPrefix(ParenthesisPrefixContext ctx) {
    final rawExp = ctx.exp(0);

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
