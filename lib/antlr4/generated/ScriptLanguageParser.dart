// Generated from ScriptLanguage.g4 by ANTLR 4.13.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, file_names, constant_identifier_names, prefer_function_declarations_over_variables, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_renaming_method_parameters
import 'package:antlr4/antlr4.dart';

import 'ScriptLanguageVisitor.dart';
import 'ScriptLanguageBaseVisitor.dart';

const int RULE_scriptLanguage = 0,
    RULE_variableAssign = 1,
    RULE_comment = 2,
    RULE_terminalExpr = 3,
    RULE_booleanExpr = 4,
    RULE_fileConstant = 5,
    RULE_rankConstant = 6,
    RULE_numericExpr = 7;

class ScriptLanguageParser extends Parser {
  static final checkVersion =
      () => RuntimeMetaData.checkVersion('4.13.0', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache =
      PredictionContextCache();
  static const int TOKEN_T__0 = 1,
      TOKEN_T__1 = 2,
      TOKEN_T__2 = 3,
      TOKEN_T__3 = 4,
      TOKEN_T__4 = 5,
      TOKEN_T__5 = 6,
      TOKEN_T__6 = 7,
      TOKEN_T__7 = 8,
      TOKEN_T__8 = 9,
      TOKEN_T__9 = 10,
      TOKEN_T__10 = 11,
      TOKEN_T__11 = 12,
      TOKEN_T__12 = 13,
      TOKEN_T__13 = 14,
      TOKEN_T__14 = 15,
      TOKEN_T__15 = 16,
      TOKEN_T__16 = 17,
      TOKEN_T__17 = 18,
      TOKEN_T__18 = 19,
      TOKEN_T__19 = 20,
      TOKEN_T__20 = 21,
      TOKEN_T__21 = 22,
      TOKEN_T__22 = 23,
      TOKEN_T__23 = 24,
      TOKEN_T__24 = 25,
      TOKEN_T__25 = 26,
      TOKEN_T__26 = 27,
      TOKEN_T__27 = 28,
      TOKEN_T__28 = 29,
      TOKEN_T__29 = 30,
      TOKEN_T__30 = 31,
      TOKEN_T__31 = 32,
      TOKEN_T__32 = 33,
      TOKEN_T__33 = 34,
      TOKEN_T__34 = 35,
      TOKEN_T__35 = 36,
      TOKEN_T__36 = 37,
      TOKEN_T__37 = 38,
      TOKEN_NumericLitteral = 39,
      TOKEN_ID = 40,
      TOKEN_COMMENT_TOKEN = 41,
      TOKEN_WS = 42;

  @override
  final List<String> ruleNames = [
    'scriptLanguage',
    'variableAssign',
    'comment',
    'terminalExpr',
    'booleanExpr',
    'fileConstant',
    'rankConstant',
    'numericExpr'
  ];

  static final List<String?> _LITERAL_NAMES = [
    null,
    "':='",
    "';'",
    "'/*'",
    "'*/'",
    "'return'",
    "'('",
    "')'",
    "'if'",
    "'then'",
    "'else'",
    "'<'",
    "'>'",
    "'<='",
    "'>='",
    "'='",
    "'<>'",
    "'and'",
    "'or'",
    "'FileA'",
    "'FileB'",
    "'FileC'",
    "'FileD'",
    "'FileE'",
    "'FileF'",
    "'FileG'",
    "'FileH'",
    "'Rank1'",
    "'Rank2'",
    "'Rank3'",
    "'Rank4'",
    "'Rank5'",
    "'Rank6'",
    "'Rank7'",
    "'Rank8'",
    "'abs('",
    "'%'",
    "'+'",
    "'-'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    "NumericLitteral",
    "ID",
    "COMMENT_TOKEN",
    "WS"
  ];
  static final Vocabulary VOCABULARY =
      VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'ScriptLanguage.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
    return _ATN;
  }

  ScriptLanguageParser(TokenStream input) : super(input) {
    interpreter =
        ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  ScriptLanguageContext scriptLanguage() {
    dynamic _localctx = ScriptLanguageContext(context, state);
    enterRule(_localctx, 0, RULE_scriptLanguage);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 19;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_ID) {
        state = 16;
        variableAssign();
        state = 21;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 22;
      terminalExpr();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  VariableAssignContext variableAssign() {
    dynamic _localctx = VariableAssignContext(context, state);
    enterRule(_localctx, 2, RULE_variableAssign);
    try {
      state = 34;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 1, context)) {
        case 1:
          _localctx = NumericAssignContext(_localctx);
          enterOuterAlt(_localctx, 1);
          state = 24;
          match(TOKEN_ID);
          state = 25;
          match(TOKEN_T__0);
          state = 26;
          numericExpr(0);
          state = 27;
          match(TOKEN_T__1);
          break;
        case 2:
          _localctx = BooleanAssignContext(_localctx);
          enterOuterAlt(_localctx, 2);
          state = 29;
          match(TOKEN_ID);
          state = 30;
          match(TOKEN_T__0);
          state = 31;
          booleanExpr(0);
          state = 32;
          match(TOKEN_T__1);
          break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  CommentContext comment() {
    dynamic _localctx = CommentContext(context, state);
    enterRule(_localctx, 4, RULE_comment);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 36;
      match(TOKEN_T__2);
      state = 40;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_COMMENT_TOKEN) {
        state = 37;
        match(TOKEN_COMMENT_TOKEN);
        state = 42;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 43;
      match(TOKEN_T__3);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  TerminalExprContext terminalExpr() {
    dynamic _localctx = TerminalExprContext(context, state);
    enterRule(_localctx, 6, RULE_terminalExpr);
    try {
      enterOuterAlt(_localctx, 1);
      state = 45;
      match(TOKEN_T__4);
      state = 46;
      booleanExpr(0);
      state = 47;
      match(TOKEN_T__1);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  BooleanExprContext booleanExpr([int _p = 0]) {
    final _parentctx = context;
    final _parentState = state;
    dynamic _localctx = BooleanExprContext(context, _parentState);
    var _prevctx = _localctx;
    var _startState = 8;
    enterRecursionRule(_localctx, 8, RULE_booleanExpr, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 70;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 3, context)) {
        case 1:
          _localctx = ParenthesisBooleanExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 50;
          match(TOKEN_T__5);
          state = 51;
          booleanExpr(0);
          state = 52;
          match(TOKEN_T__6);
          break;
        case 2:
          _localctx = ConditionalBooleanExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 54;
          match(TOKEN_T__7);
          state = 55;
          booleanExpr(0);
          state = 56;
          match(TOKEN_T__8);
          state = 57;
          booleanExpr(0);
          state = 58;
          match(TOKEN_T__9);
          state = 59;
          booleanExpr(6);
          break;
        case 3:
          _localctx = BooleanVariableContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 61;
          match(TOKEN_ID);
          break;
        case 4:
          _localctx = NumericRelationalContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 62;
          numericExpr(0);
          state = 63;
          _localctx.op = tokenStream.LT(1);
          _la = tokenStream.LA(1)!;
          if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 30720) != 0))) {
            _localctx.op = errorHandler.recoverInline(this);
          } else {
            if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
            errorHandler.reportMatch(this);
            consume();
          }
          state = 64;
          numericExpr(0);
          break;
        case 5:
          _localctx = NumericEqualityContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 66;
          numericExpr(0);
          state = 67;
          _localctx.op = tokenStream.LT(1);
          _la = tokenStream.LA(1)!;
          if (!(_la == TOKEN_T__14 || _la == TOKEN_T__15)) {
            _localctx.op = errorHandler.recoverInline(this);
          } else {
            if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
            errorHandler.reportMatch(this);
            consume();
          }
          state = 68;
          numericExpr(0);
          break;
      }
      context!.stop = tokenStream.LT(-1);
      state = 80;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 5, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 78;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 4, context)) {
            case 1:
              _localctx = AndComparisonContext(
                  BooleanExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_booleanExpr);
              state = 72;
              if (!(precpred(context, 2))) {
                throw FailedPredicateException(this, "precpred(context, 2)");
              }
              state = 73;
              match(TOKEN_T__16);
              state = 74;
              booleanExpr(3);
              break;
            case 2:
              _localctx = OrComparisonContext(
                  BooleanExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_booleanExpr);
              state = 75;
              if (!(precpred(context, 1))) {
                throw FailedPredicateException(this, "precpred(context, 1)");
              }
              state = 76;
              match(TOKEN_T__17);
              state = 77;
              booleanExpr(2);
              break;
          }
        }
        state = 82;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 5, context);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      unrollRecursionContexts(_parentctx);
    }
    return _localctx;
  }

  FileConstantContext fileConstant() {
    dynamic _localctx = FileConstantContext(context, state);
    enterRule(_localctx, 10, RULE_fileConstant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 83;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 133693440) != 0))) {
        errorHandler.recoverInline(this);
      } else {
        if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RankConstantContext rankConstant() {
    dynamic _localctx = RankConstantContext(context, state);
    enterRule(_localctx, 12, RULE_rankConstant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 85;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 34225520640) != 0))) {
        errorHandler.recoverInline(this);
      } else {
        if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  NumericExprContext numericExpr([int _p = 0]) {
    final _parentctx = context;
    final _parentState = state;
    dynamic _localctx = NumericExprContext(context, _parentState);
    var _prevctx = _localctx;
    var _startState = 14;
    enterRecursionRule(_localctx, 14, RULE_numericExpr, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 107;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_T__5:
          _localctx = ParenthesisNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 88;
          match(TOKEN_T__5);
          state = 89;
          numericExpr(0);
          state = 90;
          match(TOKEN_T__6);
          break;
        case TOKEN_T__7:
          _localctx = ConditionalNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 92;
          match(TOKEN_T__7);
          state = 93;
          booleanExpr(0);
          state = 94;
          match(TOKEN_T__8);
          state = 95;
          numericExpr(0);
          state = 96;
          match(TOKEN_T__9);
          state = 97;
          numericExpr(8);
          break;
        case TOKEN_T__34:
          _localctx = AbsoluteNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 99;
          match(TOKEN_T__34);
          state = 100;
          numericExpr(0);
          state = 101;
          match(TOKEN_T__6);
          break;
        case TOKEN_NumericLitteral:
          _localctx = LitteralNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 103;
          match(TOKEN_NumericLitteral);
          break;
        case TOKEN_ID:
          _localctx = NumericVariableContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 104;
          match(TOKEN_ID);
          break;
        case TOKEN_T__18:
        case TOKEN_T__19:
        case TOKEN_T__20:
        case TOKEN_T__21:
        case TOKEN_T__22:
        case TOKEN_T__23:
        case TOKEN_T__24:
        case TOKEN_T__25:
          _localctx = FileConstantNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 105;
          fileConstant();
          break;
        case TOKEN_T__26:
        case TOKEN_T__27:
        case TOKEN_T__28:
        case TOKEN_T__29:
        case TOKEN_T__30:
        case TOKEN_T__31:
        case TOKEN_T__32:
        case TOKEN_T__33:
          _localctx = RankConstantNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 106;
          rankConstant();
          break;
        default:
          throw NoViableAltException(this);
      }
      context!.stop = tokenStream.LT(-1);
      state = 117;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 8, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 115;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 7, context)) {
            case 1:
              _localctx = ModuloNumericExprContext(
                  NumericExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_numericExpr);
              state = 109;
              if (!(precpred(context, 6))) {
                throw FailedPredicateException(this, "precpred(context, 6)");
              }
              state = 110;
              match(TOKEN_T__35);
              state = 111;
              numericExpr(7);
              break;
            case 2:
              _localctx = PlusMinusNumericExprContext(
                  NumericExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_numericExpr);
              state = 112;
              if (!(precpred(context, 5))) {
                throw FailedPredicateException(this, "precpred(context, 5)");
              }
              state = 113;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_T__36 || _la == TOKEN_T__37)) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 114;
              numericExpr(6);
              break;
          }
        }
        state = 119;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 8, context);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      unrollRecursionContexts(_parentctx);
    }
    return _localctx;
  }

  @override
  bool sempred(RuleContext? _localctx, int ruleIndex, int predIndex) {
    switch (ruleIndex) {
      case 4:
        return _booleanExpr_sempred(
            _localctx as BooleanExprContext?, predIndex);
      case 7:
        return _numericExpr_sempred(
            _localctx as NumericExprContext?, predIndex);
    }
    return true;
  }

  bool _booleanExpr_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0:
        return precpred(context, 2);
      case 1:
        return precpred(context, 1);
    }
    return true;
  }

  bool _numericExpr_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 2:
        return precpred(context, 6);
      case 3:
        return precpred(context, 5);
    }
    return true;
  }

  static const List<int> _serializedATN = [
    4,
    1,
    42,
    121,
    2,
    0,
    7,
    0,
    2,
    1,
    7,
    1,
    2,
    2,
    7,
    2,
    2,
    3,
    7,
    3,
    2,
    4,
    7,
    4,
    2,
    5,
    7,
    5,
    2,
    6,
    7,
    6,
    2,
    7,
    7,
    7,
    1,
    0,
    5,
    0,
    18,
    8,
    0,
    10,
    0,
    12,
    0,
    21,
    9,
    0,
    1,
    0,
    1,
    0,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    3,
    1,
    35,
    8,
    1,
    1,
    2,
    1,
    2,
    5,
    2,
    39,
    8,
    2,
    10,
    2,
    12,
    2,
    42,
    9,
    2,
    1,
    2,
    1,
    2,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    3,
    4,
    71,
    8,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    1,
    4,
    5,
    4,
    79,
    8,
    4,
    10,
    4,
    12,
    4,
    82,
    9,
    4,
    1,
    5,
    1,
    5,
    1,
    6,
    1,
    6,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    3,
    7,
    108,
    8,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    1,
    7,
    5,
    7,
    116,
    8,
    7,
    10,
    7,
    12,
    7,
    119,
    9,
    7,
    1,
    7,
    0,
    2,
    8,
    14,
    8,
    0,
    2,
    4,
    6,
    8,
    10,
    12,
    14,
    0,
    5,
    1,
    0,
    11,
    14,
    1,
    0,
    15,
    16,
    1,
    0,
    19,
    26,
    1,
    0,
    27,
    34,
    1,
    0,
    37,
    38,
    129,
    0,
    19,
    1,
    0,
    0,
    0,
    2,
    34,
    1,
    0,
    0,
    0,
    4,
    36,
    1,
    0,
    0,
    0,
    6,
    45,
    1,
    0,
    0,
    0,
    8,
    70,
    1,
    0,
    0,
    0,
    10,
    83,
    1,
    0,
    0,
    0,
    12,
    85,
    1,
    0,
    0,
    0,
    14,
    107,
    1,
    0,
    0,
    0,
    16,
    18,
    3,
    2,
    1,
    0,
    17,
    16,
    1,
    0,
    0,
    0,
    18,
    21,
    1,
    0,
    0,
    0,
    19,
    17,
    1,
    0,
    0,
    0,
    19,
    20,
    1,
    0,
    0,
    0,
    20,
    22,
    1,
    0,
    0,
    0,
    21,
    19,
    1,
    0,
    0,
    0,
    22,
    23,
    3,
    6,
    3,
    0,
    23,
    1,
    1,
    0,
    0,
    0,
    24,
    25,
    5,
    40,
    0,
    0,
    25,
    26,
    5,
    1,
    0,
    0,
    26,
    27,
    3,
    14,
    7,
    0,
    27,
    28,
    5,
    2,
    0,
    0,
    28,
    35,
    1,
    0,
    0,
    0,
    29,
    30,
    5,
    40,
    0,
    0,
    30,
    31,
    5,
    1,
    0,
    0,
    31,
    32,
    3,
    8,
    4,
    0,
    32,
    33,
    5,
    2,
    0,
    0,
    33,
    35,
    1,
    0,
    0,
    0,
    34,
    24,
    1,
    0,
    0,
    0,
    34,
    29,
    1,
    0,
    0,
    0,
    35,
    3,
    1,
    0,
    0,
    0,
    36,
    40,
    5,
    3,
    0,
    0,
    37,
    39,
    5,
    41,
    0,
    0,
    38,
    37,
    1,
    0,
    0,
    0,
    39,
    42,
    1,
    0,
    0,
    0,
    40,
    38,
    1,
    0,
    0,
    0,
    40,
    41,
    1,
    0,
    0,
    0,
    41,
    43,
    1,
    0,
    0,
    0,
    42,
    40,
    1,
    0,
    0,
    0,
    43,
    44,
    5,
    4,
    0,
    0,
    44,
    5,
    1,
    0,
    0,
    0,
    45,
    46,
    5,
    5,
    0,
    0,
    46,
    47,
    3,
    8,
    4,
    0,
    47,
    48,
    5,
    2,
    0,
    0,
    48,
    7,
    1,
    0,
    0,
    0,
    49,
    50,
    6,
    4,
    -1,
    0,
    50,
    51,
    5,
    6,
    0,
    0,
    51,
    52,
    3,
    8,
    4,
    0,
    52,
    53,
    5,
    7,
    0,
    0,
    53,
    71,
    1,
    0,
    0,
    0,
    54,
    55,
    5,
    8,
    0,
    0,
    55,
    56,
    3,
    8,
    4,
    0,
    56,
    57,
    5,
    9,
    0,
    0,
    57,
    58,
    3,
    8,
    4,
    0,
    58,
    59,
    5,
    10,
    0,
    0,
    59,
    60,
    3,
    8,
    4,
    6,
    60,
    71,
    1,
    0,
    0,
    0,
    61,
    71,
    5,
    40,
    0,
    0,
    62,
    63,
    3,
    14,
    7,
    0,
    63,
    64,
    7,
    0,
    0,
    0,
    64,
    65,
    3,
    14,
    7,
    0,
    65,
    71,
    1,
    0,
    0,
    0,
    66,
    67,
    3,
    14,
    7,
    0,
    67,
    68,
    7,
    1,
    0,
    0,
    68,
    69,
    3,
    14,
    7,
    0,
    69,
    71,
    1,
    0,
    0,
    0,
    70,
    49,
    1,
    0,
    0,
    0,
    70,
    54,
    1,
    0,
    0,
    0,
    70,
    61,
    1,
    0,
    0,
    0,
    70,
    62,
    1,
    0,
    0,
    0,
    70,
    66,
    1,
    0,
    0,
    0,
    71,
    80,
    1,
    0,
    0,
    0,
    72,
    73,
    10,
    2,
    0,
    0,
    73,
    74,
    5,
    17,
    0,
    0,
    74,
    79,
    3,
    8,
    4,
    3,
    75,
    76,
    10,
    1,
    0,
    0,
    76,
    77,
    5,
    18,
    0,
    0,
    77,
    79,
    3,
    8,
    4,
    2,
    78,
    72,
    1,
    0,
    0,
    0,
    78,
    75,
    1,
    0,
    0,
    0,
    79,
    82,
    1,
    0,
    0,
    0,
    80,
    78,
    1,
    0,
    0,
    0,
    80,
    81,
    1,
    0,
    0,
    0,
    81,
    9,
    1,
    0,
    0,
    0,
    82,
    80,
    1,
    0,
    0,
    0,
    83,
    84,
    7,
    2,
    0,
    0,
    84,
    11,
    1,
    0,
    0,
    0,
    85,
    86,
    7,
    3,
    0,
    0,
    86,
    13,
    1,
    0,
    0,
    0,
    87,
    88,
    6,
    7,
    -1,
    0,
    88,
    89,
    5,
    6,
    0,
    0,
    89,
    90,
    3,
    14,
    7,
    0,
    90,
    91,
    5,
    7,
    0,
    0,
    91,
    108,
    1,
    0,
    0,
    0,
    92,
    93,
    5,
    8,
    0,
    0,
    93,
    94,
    3,
    8,
    4,
    0,
    94,
    95,
    5,
    9,
    0,
    0,
    95,
    96,
    3,
    14,
    7,
    0,
    96,
    97,
    5,
    10,
    0,
    0,
    97,
    98,
    3,
    14,
    7,
    8,
    98,
    108,
    1,
    0,
    0,
    0,
    99,
    100,
    5,
    35,
    0,
    0,
    100,
    101,
    3,
    14,
    7,
    0,
    101,
    102,
    5,
    7,
    0,
    0,
    102,
    108,
    1,
    0,
    0,
    0,
    103,
    108,
    5,
    39,
    0,
    0,
    104,
    108,
    5,
    40,
    0,
    0,
    105,
    108,
    3,
    10,
    5,
    0,
    106,
    108,
    3,
    12,
    6,
    0,
    107,
    87,
    1,
    0,
    0,
    0,
    107,
    92,
    1,
    0,
    0,
    0,
    107,
    99,
    1,
    0,
    0,
    0,
    107,
    103,
    1,
    0,
    0,
    0,
    107,
    104,
    1,
    0,
    0,
    0,
    107,
    105,
    1,
    0,
    0,
    0,
    107,
    106,
    1,
    0,
    0,
    0,
    108,
    117,
    1,
    0,
    0,
    0,
    109,
    110,
    10,
    6,
    0,
    0,
    110,
    111,
    5,
    36,
    0,
    0,
    111,
    116,
    3,
    14,
    7,
    7,
    112,
    113,
    10,
    5,
    0,
    0,
    113,
    114,
    7,
    4,
    0,
    0,
    114,
    116,
    3,
    14,
    7,
    6,
    115,
    109,
    1,
    0,
    0,
    0,
    115,
    112,
    1,
    0,
    0,
    0,
    116,
    119,
    1,
    0,
    0,
    0,
    117,
    115,
    1,
    0,
    0,
    0,
    117,
    118,
    1,
    0,
    0,
    0,
    118,
    15,
    1,
    0,
    0,
    0,
    119,
    117,
    1,
    0,
    0,
    0,
    9,
    19,
    34,
    40,
    70,
    78,
    80,
    107,
    115,
    117
  ];

  static final ATN _ATN = ATNDeserializer().deserialize(_serializedATN);
}

class ScriptLanguageContext extends ParserRuleContext {
  TerminalExprContext? terminalExpr() => getRuleContext<TerminalExprContext>(0);
  List<VariableAssignContext> variableAssigns() =>
      getRuleContexts<VariableAssignContext>();
  VariableAssignContext? variableAssign(int i) =>
      getRuleContext<VariableAssignContext>(i);
  ScriptLanguageContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_scriptLanguage;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitScriptLanguage(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class VariableAssignContext extends ParserRuleContext {
  VariableAssignContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_variableAssign;
}

class CommentContext extends ParserRuleContext {
  List<TerminalNode> COMMENT_TOKENs() =>
      getTokens(ScriptLanguageParser.TOKEN_COMMENT_TOKEN);
  TerminalNode? COMMENT_TOKEN(int i) =>
      getToken(ScriptLanguageParser.TOKEN_COMMENT_TOKEN, i);
  CommentContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_comment;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitComment(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class TerminalExprContext extends ParserRuleContext {
  BooleanExprContext? booleanExpr() => getRuleContext<BooleanExprContext>(0);
  TerminalExprContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_terminalExpr;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitTerminalExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanExprContext extends ParserRuleContext {
  BooleanExprContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_booleanExpr;
}

class FileConstantContext extends ParserRuleContext {
  FileConstantContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_fileConstant;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitFileConstant(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class RankConstantContext extends ParserRuleContext {
  RankConstantContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_rankConstant;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitRankConstant(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumericExprContext extends ParserRuleContext {
  NumericExprContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_numericExpr;
}

class NumericAssignContext extends VariableAssignContext {
  TerminalNode? ID() => getToken(ScriptLanguageParser.TOKEN_ID, 0);
  NumericExprContext? numericExpr() => getRuleContext<NumericExprContext>(0);
  NumericAssignContext(VariableAssignContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitNumericAssign(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanAssignContext extends VariableAssignContext {
  TerminalNode? ID() => getToken(ScriptLanguageParser.TOKEN_ID, 0);
  BooleanExprContext? booleanExpr() => getRuleContext<BooleanExprContext>(0);
  BooleanAssignContext(VariableAssignContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitBooleanAssign(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumericEqualityContext extends BooleanExprContext {
  Token? op;
  List<NumericExprContext> numericExprs() =>
      getRuleContexts<NumericExprContext>();
  NumericExprContext? numericExpr(int i) =>
      getRuleContext<NumericExprContext>(i);
  NumericEqualityContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitNumericEquality(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class OrComparisonContext extends BooleanExprContext {
  List<BooleanExprContext> booleanExprs() =>
      getRuleContexts<BooleanExprContext>();
  BooleanExprContext? booleanExpr(int i) =>
      getRuleContext<BooleanExprContext>(i);
  OrComparisonContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitOrComparison(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ConditionalBooleanExprContext extends BooleanExprContext {
  List<BooleanExprContext> booleanExprs() =>
      getRuleContexts<BooleanExprContext>();
  BooleanExprContext? booleanExpr(int i) =>
      getRuleContext<BooleanExprContext>(i);
  ConditionalBooleanExprContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitConditionalBooleanExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanVariableContext extends BooleanExprContext {
  TerminalNode? ID() => getToken(ScriptLanguageParser.TOKEN_ID, 0);
  BooleanVariableContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitBooleanVariable(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ParenthesisBooleanExprContext extends BooleanExprContext {
  BooleanExprContext? booleanExpr() => getRuleContext<BooleanExprContext>(0);
  ParenthesisBooleanExprContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitParenthesisBooleanExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class AndComparisonContext extends BooleanExprContext {
  List<BooleanExprContext> booleanExprs() =>
      getRuleContexts<BooleanExprContext>();
  BooleanExprContext? booleanExpr(int i) =>
      getRuleContext<BooleanExprContext>(i);
  AndComparisonContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitAndComparison(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumericRelationalContext extends BooleanExprContext {
  Token? op;
  List<NumericExprContext> numericExprs() =>
      getRuleContexts<NumericExprContext>();
  NumericExprContext? numericExpr(int i) =>
      getRuleContext<NumericExprContext>(i);
  NumericRelationalContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitNumericRelational(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class AbsoluteNumericExprContext extends NumericExprContext {
  NumericExprContext? numericExpr() => getRuleContext<NumericExprContext>(0);
  AbsoluteNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitAbsoluteNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ParenthesisNumericExprContext extends NumericExprContext {
  NumericExprContext? numericExpr() => getRuleContext<NumericExprContext>(0);
  ParenthesisNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitParenthesisNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ConditionalNumericExprContext extends NumericExprContext {
  BooleanExprContext? booleanExpr() => getRuleContext<BooleanExprContext>(0);
  List<NumericExprContext> numericExprs() =>
      getRuleContexts<NumericExprContext>();
  NumericExprContext? numericExpr(int i) =>
      getRuleContext<NumericExprContext>(i);
  ConditionalNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitConditionalNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumericVariableContext extends NumericExprContext {
  TerminalNode? ID() => getToken(ScriptLanguageParser.TOKEN_ID, 0);
  NumericVariableContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitNumericVariable(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class PlusMinusNumericExprContext extends NumericExprContext {
  Token? op;
  List<NumericExprContext> numericExprs() =>
      getRuleContexts<NumericExprContext>();
  NumericExprContext? numericExpr(int i) =>
      getRuleContext<NumericExprContext>(i);
  PlusMinusNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitPlusMinusNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class LitteralNumericExprContext extends NumericExprContext {
  TerminalNode? NumericLitteral() =>
      getToken(ScriptLanguageParser.TOKEN_NumericLitteral, 0);
  LitteralNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitLitteralNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class RankConstantNumericExprContext extends NumericExprContext {
  RankConstantContext? rankConstant() => getRuleContext<RankConstantContext>(0);
  RankConstantNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitRankConstantNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class FileConstantNumericExprContext extends NumericExprContext {
  FileConstantContext? fileConstant() => getRuleContext<FileConstantContext>(0);
  FileConstantNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitFileConstantNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ModuloNumericExprContext extends NumericExprContext {
  List<NumericExprContext> numericExprs() =>
      getRuleContexts<NumericExprContext>();
  NumericExprContext? numericExpr(int i) =>
      getRuleContext<NumericExprContext>(i);
  ModuloNumericExprContext(NumericExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitModuloNumericExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
