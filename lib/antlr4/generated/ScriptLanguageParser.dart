// Generated from ScriptLanguage.g4 by ANTLR 4.13.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, constant_identifier_names, prefer_function_declarations_over_variables, file_names, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, avoid_renaming_method_parameters
import 'package:antlr4/antlr4.dart';

import 'ScriptLanguageVisitor.dart';
import 'ScriptLanguageBaseVisitor.dart';

const int RULE_scriptLanguage = 0,
    RULE_variableAssign = 1,
    RULE_terminalExpr = 2,
    RULE_booleanExpr = 3,
    RULE_fileConstant = 4,
    RULE_rankConstant = 5,
    RULE_numericExpr = 6;

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
      TOKEN_T__38 = 39,
      TOKEN_NumericLitteral = 40,
      TOKEN_ID = 41,
      TOKEN_COMMENT = 42,
      TOKEN_LINE_COMMENT = 43,
      TOKEN_WS = 44;

  @override
  final List<String> ruleNames = [
    'scriptLanguage',
    'variableAssign',
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
    "'return'",
    "'('",
    "')'",
    "'boolIf'",
    "'then'",
    "'else'",
    "'<'",
    "'>'",
    "'<='",
    "'>='",
    "'=='",
    "'!='",
    "'<==>'",
    "'<!=>'",
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
    "'numIf'",
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
    null,
    "NumericLitteral",
    "ID",
    "COMMENT",
    "LINE_COMMENT",
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

  ScriptLanguageParser(super.input) {
    interpreter =
        ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  ScriptLanguageContext scriptLanguage() {
    dynamic _localctx = ScriptLanguageContext(context, state);
    enterRule(_localctx, 0, RULE_scriptLanguage);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 17;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_ID) {
        state = 14;
        variableAssign();
        state = 19;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 20;
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
      state = 32;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 1, context)) {
        case 1:
          _localctx = NumericAssignContext(_localctx);
          enterOuterAlt(_localctx, 1);
          state = 22;
          match(TOKEN_ID);
          state = 23;
          match(TOKEN_T__0);
          state = 24;
          numericExpr(0);
          state = 25;
          match(TOKEN_T__1);
          break;
        case 2:
          _localctx = BooleanAssignContext(_localctx);
          enterOuterAlt(_localctx, 2);
          state = 27;
          match(TOKEN_ID);
          state = 28;
          match(TOKEN_T__0);
          state = 29;
          booleanExpr(0);
          state = 30;
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

  TerminalExprContext terminalExpr() {
    dynamic _localctx = TerminalExprContext(context, state);
    enterRule(_localctx, 4, RULE_terminalExpr);
    try {
      enterOuterAlt(_localctx, 1);
      state = 34;
      match(TOKEN_T__2);
      state = 35;
      booleanExpr(0);
      state = 36;
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
    var _startState = 6;
    enterRecursionRule(_localctx, 6, RULE_booleanExpr, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 59;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 2, context)) {
        case 1:
          _localctx = ParenthesisBooleanExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 39;
          match(TOKEN_T__3);
          state = 40;
          booleanExpr(0);
          state = 41;
          match(TOKEN_T__4);
          break;
        case 2:
          _localctx = ConditionalBooleanExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 43;
          match(TOKEN_T__5);
          state = 44;
          booleanExpr(0);
          state = 45;
          match(TOKEN_T__6);
          state = 46;
          booleanExpr(0);
          state = 47;
          match(TOKEN_T__7);
          state = 48;
          booleanExpr(7);
          break;
        case 3:
          _localctx = BooleanVariableContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 50;
          match(TOKEN_ID);
          break;
        case 4:
          _localctx = NumericRelationalContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 51;
          numericExpr(0);
          state = 52;
          _localctx.op = tokenStream.LT(1);
          _la = tokenStream.LA(1)!;
          if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 7680) != 0))) {
            _localctx.op = errorHandler.recoverInline(this);
          } else {
            if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
            errorHandler.reportMatch(this);
            consume();
          }
          state = 53;
          numericExpr(0);
          break;
        case 5:
          _localctx = NumericEqualityContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 55;
          numericExpr(0);
          state = 56;
          _localctx.op = tokenStream.LT(1);
          _la = tokenStream.LA(1)!;
          if (!(_la == TOKEN_T__12 || _la == TOKEN_T__13)) {
            _localctx.op = errorHandler.recoverInline(this);
          } else {
            if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
            errorHandler.reportMatch(this);
            consume();
          }
          state = 57;
          numericExpr(0);
          break;
      }
      context!.stop = tokenStream.LT(-1);
      state = 72;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 4, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 70;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 3, context)) {
            case 1:
              _localctx = BooleanEqualityContext(
                  BooleanExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_booleanExpr);
              state = 61;
              if (!(precpred(context, 3))) {
                throw FailedPredicateException(this, "precpred(context, 3)");
              }
              state = 62;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_T__14 || _la == TOKEN_T__15)) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 63;
              booleanExpr(4);
              break;
            case 2:
              _localctx = AndComparisonContext(
                  BooleanExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_booleanExpr);
              state = 64;
              if (!(precpred(context, 2))) {
                throw FailedPredicateException(this, "precpred(context, 2)");
              }
              state = 65;
              match(TOKEN_T__16);
              state = 66;
              booleanExpr(3);
              break;
            case 3:
              _localctx = OrComparisonContext(
                  BooleanExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_booleanExpr);
              state = 67;
              if (!(precpred(context, 1))) {
                throw FailedPredicateException(this, "precpred(context, 1)");
              }
              state = 68;
              match(TOKEN_T__17);
              state = 69;
              booleanExpr(2);
              break;
          }
        }
        state = 74;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 4, context);
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
    enterRule(_localctx, 8, RULE_fileConstant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 75;
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
    enterRule(_localctx, 10, RULE_rankConstant);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 77;
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
    var _startState = 12;
    enterRecursionRule(_localctx, 12, RULE_numericExpr, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 99;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_T__3:
          _localctx = ParenthesisNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 80;
          match(TOKEN_T__3);
          state = 81;
          numericExpr(0);
          state = 82;
          match(TOKEN_T__4);
          break;
        case TOKEN_T__34:
          _localctx = ConditionalNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 84;
          match(TOKEN_T__34);
          state = 85;
          booleanExpr(0);
          state = 86;
          match(TOKEN_T__6);
          state = 87;
          numericExpr(0);
          state = 88;
          match(TOKEN_T__7);
          state = 89;
          numericExpr(8);
          break;
        case TOKEN_T__35:
          _localctx = AbsoluteNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 91;
          match(TOKEN_T__35);
          state = 92;
          numericExpr(0);
          state = 93;
          match(TOKEN_T__4);
          break;
        case TOKEN_NumericLitteral:
          _localctx = LitteralNumericExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 95;
          match(TOKEN_NumericLitteral);
          break;
        case TOKEN_ID:
          _localctx = NumericVariableContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 96;
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
          state = 97;
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
          state = 98;
          rankConstant();
          break;
        default:
          throw NoViableAltException(this);
      }
      context!.stop = tokenStream.LT(-1);
      state = 109;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 7, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 107;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 6, context)) {
            case 1:
              _localctx = ModuloNumericExprContext(
                  NumericExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_numericExpr);
              state = 101;
              if (!(precpred(context, 6))) {
                throw FailedPredicateException(this, "precpred(context, 6)");
              }
              state = 102;
              match(TOKEN_T__36);
              state = 103;
              numericExpr(7);
              break;
            case 2:
              _localctx = PlusMinusNumericExprContext(
                  NumericExprContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_numericExpr);
              state = 104;
              if (!(precpred(context, 5))) {
                throw FailedPredicateException(this, "precpred(context, 5)");
              }
              state = 105;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_T__37 || _la == TOKEN_T__38)) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 106;
              numericExpr(6);
              break;
          }
        }
        state = 111;
        errorHandler.sync(this);
        _alt = interpreter!.adaptivePredict(tokenStream, 7, context);
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
      case 3:
        return _booleanExpr_sempred(
            _localctx as BooleanExprContext?, predIndex);
      case 6:
        return _numericExpr_sempred(
            _localctx as NumericExprContext?, predIndex);
    }
    return true;
  }

  bool _booleanExpr_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0:
        return precpred(context, 3);
      case 1:
        return precpred(context, 2);
      case 2:
        return precpred(context, 1);
    }
    return true;
  }

  bool _numericExpr_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 3:
        return precpred(context, 6);
      case 4:
        return precpred(context, 5);
    }
    return true;
  }

  static const List<int> _serializedATN = [
    4,
    1,
    44,
    113,
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
    1,
    0,
    5,
    0,
    16,
    8,
    0,
    10,
    0,
    12,
    0,
    19,
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
    33,
    8,
    1,
    1,
    2,
    1,
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
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    3,
    3,
    60,
    8,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    1,
    3,
    5,
    3,
    71,
    8,
    3,
    10,
    3,
    12,
    3,
    74,
    9,
    3,
    1,
    4,
    1,
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
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    3,
    6,
    100,
    8,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    1,
    6,
    5,
    6,
    108,
    8,
    6,
    10,
    6,
    12,
    6,
    111,
    9,
    6,
    1,
    6,
    0,
    2,
    6,
    12,
    7,
    0,
    2,
    4,
    6,
    8,
    10,
    12,
    0,
    6,
    1,
    0,
    9,
    12,
    1,
    0,
    13,
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
    38,
    39,
    122,
    0,
    17,
    1,
    0,
    0,
    0,
    2,
    32,
    1,
    0,
    0,
    0,
    4,
    34,
    1,
    0,
    0,
    0,
    6,
    59,
    1,
    0,
    0,
    0,
    8,
    75,
    1,
    0,
    0,
    0,
    10,
    77,
    1,
    0,
    0,
    0,
    12,
    99,
    1,
    0,
    0,
    0,
    14,
    16,
    3,
    2,
    1,
    0,
    15,
    14,
    1,
    0,
    0,
    0,
    16,
    19,
    1,
    0,
    0,
    0,
    17,
    15,
    1,
    0,
    0,
    0,
    17,
    18,
    1,
    0,
    0,
    0,
    18,
    20,
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
    20,
    21,
    3,
    4,
    2,
    0,
    21,
    1,
    1,
    0,
    0,
    0,
    22,
    23,
    5,
    41,
    0,
    0,
    23,
    24,
    5,
    1,
    0,
    0,
    24,
    25,
    3,
    12,
    6,
    0,
    25,
    26,
    5,
    2,
    0,
    0,
    26,
    33,
    1,
    0,
    0,
    0,
    27,
    28,
    5,
    41,
    0,
    0,
    28,
    29,
    5,
    1,
    0,
    0,
    29,
    30,
    3,
    6,
    3,
    0,
    30,
    31,
    5,
    2,
    0,
    0,
    31,
    33,
    1,
    0,
    0,
    0,
    32,
    22,
    1,
    0,
    0,
    0,
    32,
    27,
    1,
    0,
    0,
    0,
    33,
    3,
    1,
    0,
    0,
    0,
    34,
    35,
    5,
    3,
    0,
    0,
    35,
    36,
    3,
    6,
    3,
    0,
    36,
    37,
    5,
    2,
    0,
    0,
    37,
    5,
    1,
    0,
    0,
    0,
    38,
    39,
    6,
    3,
    -1,
    0,
    39,
    40,
    5,
    4,
    0,
    0,
    40,
    41,
    3,
    6,
    3,
    0,
    41,
    42,
    5,
    5,
    0,
    0,
    42,
    60,
    1,
    0,
    0,
    0,
    43,
    44,
    5,
    6,
    0,
    0,
    44,
    45,
    3,
    6,
    3,
    0,
    45,
    46,
    5,
    7,
    0,
    0,
    46,
    47,
    3,
    6,
    3,
    0,
    47,
    48,
    5,
    8,
    0,
    0,
    48,
    49,
    3,
    6,
    3,
    7,
    49,
    60,
    1,
    0,
    0,
    0,
    50,
    60,
    5,
    41,
    0,
    0,
    51,
    52,
    3,
    12,
    6,
    0,
    52,
    53,
    7,
    0,
    0,
    0,
    53,
    54,
    3,
    12,
    6,
    0,
    54,
    60,
    1,
    0,
    0,
    0,
    55,
    56,
    3,
    12,
    6,
    0,
    56,
    57,
    7,
    1,
    0,
    0,
    57,
    58,
    3,
    12,
    6,
    0,
    58,
    60,
    1,
    0,
    0,
    0,
    59,
    38,
    1,
    0,
    0,
    0,
    59,
    43,
    1,
    0,
    0,
    0,
    59,
    50,
    1,
    0,
    0,
    0,
    59,
    51,
    1,
    0,
    0,
    0,
    59,
    55,
    1,
    0,
    0,
    0,
    60,
    72,
    1,
    0,
    0,
    0,
    61,
    62,
    10,
    3,
    0,
    0,
    62,
    63,
    7,
    2,
    0,
    0,
    63,
    71,
    3,
    6,
    3,
    4,
    64,
    65,
    10,
    2,
    0,
    0,
    65,
    66,
    5,
    17,
    0,
    0,
    66,
    71,
    3,
    6,
    3,
    3,
    67,
    68,
    10,
    1,
    0,
    0,
    68,
    69,
    5,
    18,
    0,
    0,
    69,
    71,
    3,
    6,
    3,
    2,
    70,
    61,
    1,
    0,
    0,
    0,
    70,
    64,
    1,
    0,
    0,
    0,
    70,
    67,
    1,
    0,
    0,
    0,
    71,
    74,
    1,
    0,
    0,
    0,
    72,
    70,
    1,
    0,
    0,
    0,
    72,
    73,
    1,
    0,
    0,
    0,
    73,
    7,
    1,
    0,
    0,
    0,
    74,
    72,
    1,
    0,
    0,
    0,
    75,
    76,
    7,
    3,
    0,
    0,
    76,
    9,
    1,
    0,
    0,
    0,
    77,
    78,
    7,
    4,
    0,
    0,
    78,
    11,
    1,
    0,
    0,
    0,
    79,
    80,
    6,
    6,
    -1,
    0,
    80,
    81,
    5,
    4,
    0,
    0,
    81,
    82,
    3,
    12,
    6,
    0,
    82,
    83,
    5,
    5,
    0,
    0,
    83,
    100,
    1,
    0,
    0,
    0,
    84,
    85,
    5,
    35,
    0,
    0,
    85,
    86,
    3,
    6,
    3,
    0,
    86,
    87,
    5,
    7,
    0,
    0,
    87,
    88,
    3,
    12,
    6,
    0,
    88,
    89,
    5,
    8,
    0,
    0,
    89,
    90,
    3,
    12,
    6,
    8,
    90,
    100,
    1,
    0,
    0,
    0,
    91,
    92,
    5,
    36,
    0,
    0,
    92,
    93,
    3,
    12,
    6,
    0,
    93,
    94,
    5,
    5,
    0,
    0,
    94,
    100,
    1,
    0,
    0,
    0,
    95,
    100,
    5,
    40,
    0,
    0,
    96,
    100,
    5,
    41,
    0,
    0,
    97,
    100,
    3,
    8,
    4,
    0,
    98,
    100,
    3,
    10,
    5,
    0,
    99,
    79,
    1,
    0,
    0,
    0,
    99,
    84,
    1,
    0,
    0,
    0,
    99,
    91,
    1,
    0,
    0,
    0,
    99,
    95,
    1,
    0,
    0,
    0,
    99,
    96,
    1,
    0,
    0,
    0,
    99,
    97,
    1,
    0,
    0,
    0,
    99,
    98,
    1,
    0,
    0,
    0,
    100,
    109,
    1,
    0,
    0,
    0,
    101,
    102,
    10,
    6,
    0,
    0,
    102,
    103,
    5,
    37,
    0,
    0,
    103,
    108,
    3,
    12,
    6,
    7,
    104,
    105,
    10,
    5,
    0,
    0,
    105,
    106,
    7,
    5,
    0,
    0,
    106,
    108,
    3,
    12,
    6,
    6,
    107,
    101,
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
    108,
    111,
    1,
    0,
    0,
    0,
    109,
    107,
    1,
    0,
    0,
    0,
    109,
    110,
    1,
    0,
    0,
    0,
    110,
    13,
    1,
    0,
    0,
    0,
    111,
    109,
    1,
    0,
    0,
    0,
    8,
    17,
    32,
    59,
    70,
    72,
    99,
    107,
    109
  ];

  static final ATN _ATN = ATNDeserializer().deserialize(_serializedATN);
}

class ScriptLanguageContext extends ParserRuleContext {
  TerminalExprContext? terminalExpr() => getRuleContext<TerminalExprContext>(0);
  List<VariableAssignContext> variableAssigns() =>
      getRuleContexts<VariableAssignContext>();
  VariableAssignContext? variableAssign(int i) =>
      getRuleContext<VariableAssignContext>(i);
  ScriptLanguageContext([ParserRuleContext? super.parent, super.invokingState]);
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
  VariableAssignContext([ParserRuleContext? super.parent, super.invokingState]);
  @override
  int get ruleIndex => RULE_variableAssign;
}

class TerminalExprContext extends ParserRuleContext {
  BooleanExprContext? booleanExpr() => getRuleContext<BooleanExprContext>(0);
  TerminalExprContext([ParserRuleContext? super.parent, super.invokingState]);
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
  BooleanExprContext([ParserRuleContext? super.parent, super.invokingState]);
  @override
  int get ruleIndex => RULE_booleanExpr;
}

class FileConstantContext extends ParserRuleContext {
  FileConstantContext([ParserRuleContext? super.parent, super.invokingState]);
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
  RankConstantContext([ParserRuleContext? super.parent, super.invokingState]);
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
  NumericExprContext([ParserRuleContext? super.parent, super.invokingState]);
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

class BooleanEqualityContext extends BooleanExprContext {
  Token? op;
  List<BooleanExprContext> booleanExprs() =>
      getRuleContexts<BooleanExprContext>();
  BooleanExprContext? booleanExpr(int i) =>
      getRuleContext<BooleanExprContext>(i);
  BooleanEqualityContext(BooleanExprContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ScriptLanguageVisitor<T>) {
      return visitor.visitBooleanEquality(this);
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
