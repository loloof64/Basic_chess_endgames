// Generated from Lua.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, file_names, constant_identifier_names, prefer_function_declarations_over_variables, non_constant_identifier_names, use_super_parameters, no_leading_underscores_for_local_identifiers, avoid_renaming_method_parameters, camel_case_types
import 'package:antlr4/antlr4.dart';

import 'LuaVisitor.dart';
import 'LuaBaseVisitor.dart';

const int RULE_start_ = 0,
    RULE_chunk = 1,
    RULE_block = 2,
    RULE_returnStat = 3,
    RULE_stat = 4,
    RULE_assign = 5,
    RULE_ifstat = 6,
    RULE_namelist = 7,
    RULE_explist = 8,
    RULE_exp = 9,
    RULE_prefix = 10,
    RULE_number = 11;

class LuaParser extends Parser {
  static final checkVersion =
      () => RuntimeMetaData.checkVersion('4.13.2', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache =
      PredictionContextCache();
  static const int TOKEN_SEMI = 1,
      TOKEN_EQ = 2,
      TOKEN_END = 3,
      TOKEN_IF = 4,
      TOKEN_THEN = 5,
      TOKEN_ELSEIF = 6,
      TOKEN_ELSE = 7,
      TOKEN_COMMA = 8,
      TOKEN_LT = 9,
      TOKEN_GT = 10,
      TOKEN_RETURN = 11,
      TOKEN_FALSE = 12,
      TOKEN_TRUE = 13,
      TOKEN_DOT = 14,
      TOKEN_SQUIG = 15,
      TOKEN_MINUS = 16,
      TOKEN_OP = 17,
      TOKEN_CP = 18,
      TOKEN_NOT = 19,
      TOKEN_LL = 20,
      TOKEN_GG = 21,
      TOKEN_AMP = 22,
      TOKEN_SS = 23,
      TOKEN_PER = 24,
      TOKEN_LE = 25,
      TOKEN_GE = 26,
      TOKEN_AND = 27,
      TOKEN_OR = 28,
      TOKEN_PLUS = 29,
      TOKEN_STAR = 30,
      TOKEN_EE = 31,
      TOKEN_PIPE = 32,
      TOKEN_CARET = 33,
      TOKEN_SLASH = 34,
      TOKEN_SQEQ = 35,
      TOKEN_NAME = 36,
      TOKEN_INT = 37,
      TOKEN_COMMENT = 38,
      TOKEN_WS = 39,
      TOKEN_NL = 40;

  @override
  final List<String> ruleNames = [
    'start_',
    'chunk',
    'block',
    'returnStat',
    'stat',
    'assign',
    'ifstat',
    'namelist',
    'explist',
    'exp',
    'prefix',
    'number'
  ];

  static final List<String?> _LITERAL_NAMES = [
    null,
    "';'",
    "'='",
    "'end'",
    "'if'",
    "'then'",
    "'elseif'",
    "'else'",
    "','",
    "'<'",
    "'>'",
    "'return'",
    "'false'",
    "'true'",
    "'.'",
    "'~'",
    "'-'",
    "'('",
    "')'",
    "'not'",
    "'<<'",
    "'>>'",
    "'&'",
    "'//'",
    "'%'",
    "'<='",
    "'>='",
    "'and'",
    "'or'",
    "'+'",
    "'*'",
    "'=='",
    "'|'",
    "'^'",
    "'/'",
    "'~='"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
    null,
    "SEMI",
    "EQ",
    "END",
    "IF",
    "THEN",
    "ELSEIF",
    "ELSE",
    "COMMA",
    "LT",
    "GT",
    "RETURN",
    "FALSE",
    "TRUE",
    "DOT",
    "SQUIG",
    "MINUS",
    "OP",
    "CP",
    "NOT",
    "LL",
    "GG",
    "AMP",
    "SS",
    "PER",
    "LE",
    "GE",
    "AND",
    "OR",
    "PLUS",
    "STAR",
    "EE",
    "PIPE",
    "CARET",
    "SLASH",
    "SQEQ",
    "NAME",
    "INT",
    "COMMENT",
    "WS",
    "NL"
  ];
  static final Vocabulary VOCABULARY =
      VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'Lua.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
    return _ATN;
  }

  LuaParser(TokenStream input) : super(input) {
    interpreter =
        ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  Start_Context start_() {
    dynamic _localctx = Start_Context(context, state);
    enterRule(_localctx, 0, RULE_start_);
    try {
      enterOuterAlt(_localctx, 1);
      state = 24;
      chunk();
      state = 25;
      returnStat();
      state = 26;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ChunkContext chunk() {
    dynamic _localctx = ChunkContext(context, state);
    enterRule(_localctx, 2, RULE_chunk);
    try {
      enterOuterAlt(_localctx, 1);
      state = 28;
      block();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  BlockContext block() {
    dynamic _localctx = BlockContext(context, state);
    enterRule(_localctx, 4, RULE_block);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 33;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while ((((_la) & ~0x3f) == 0 && ((1 << _la) & 68719476754) != 0)) {
        state = 30;
        stat();
        state = 35;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
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

  ReturnStatContext returnStat() {
    dynamic _localctx = ReturnStatContext(context, state);
    enterRule(_localctx, 6, RULE_returnStat);
    try {
      enterOuterAlt(_localctx, 1);
      state = 36;
      match(TOKEN_RETURN);
      state = 37;
      exp(0);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  StatContext stat() {
    dynamic _localctx = StatContext(context, state);
    enterRule(_localctx, 8, RULE_stat);
    try {
      state = 42;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_SEMI:
          _localctx = SemiColumnExecContext(_localctx);
          enterOuterAlt(_localctx, 1);
          state = 39;
          match(TOKEN_SEMI);
          break;
        case TOKEN_NAME:
          _localctx = AssignExecContext(_localctx);
          enterOuterAlt(_localctx, 2);
          state = 40;
          assign();
          break;
        case TOKEN_IF:
          _localctx = IfExecContext(_localctx);
          enterOuterAlt(_localctx, 3);
          state = 41;
          ifstat();
          break;
        default:
          throw NoViableAltException(this);
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

  AssignContext assign() {
    dynamic _localctx = AssignContext(context, state);
    enterRule(_localctx, 10, RULE_assign);
    try {
      enterOuterAlt(_localctx, 1);
      state = 44;
      namelist();
      state = 45;
      match(TOKEN_EQ);
      state = 46;
      explist();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  IfstatContext ifstat() {
    dynamic _localctx = IfstatContext(context, state);
    enterRule(_localctx, 12, RULE_ifstat);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 48;
      match(TOKEN_IF);
      state = 49;
      exp(0);
      state = 50;
      match(TOKEN_THEN);
      state = 51;
      block();
      state = 59;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_ELSEIF) {
        state = 52;
        match(TOKEN_ELSEIF);
        state = 53;
        exp(0);
        state = 54;
        match(TOKEN_THEN);
        state = 55;
        block();
        state = 61;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 64;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_ELSE) {
        state = 62;
        match(TOKEN_ELSE);
        state = 63;
        _localctx.endExec = block();
      }

      state = 66;
      match(TOKEN_END);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  NamelistContext namelist() {
    dynamic _localctx = NamelistContext(context, state);
    enterRule(_localctx, 14, RULE_namelist);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 68;
      match(TOKEN_NAME);
      state = 73;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_COMMA) {
        state = 69;
        match(TOKEN_COMMA);
        state = 70;
        match(TOKEN_NAME);
        state = 75;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
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

  ExplistContext explist() {
    dynamic _localctx = ExplistContext(context, state);
    enterRule(_localctx, 16, RULE_explist);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 76;
      exp(0);
      state = 81;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_COMMA) {
        state = 77;
        match(TOKEN_COMMA);
        state = 78;
        exp(0);
        state = 83;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
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

  ExpContext exp([int _p = 0]) {
    final _parentctx = context;
    final _parentState = state;
    dynamic _localctx = ExpContext(context, _parentState);
    var _prevctx = _localctx;
    var _startState = 18;
    enterRecursionRule(_localctx, 18, RULE_exp, _p);
    int _la;
    try {
      int _alt;
      enterOuterAlt(_localctx, 1);
      state = 91;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_FALSE:
          _localctx = FalseExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;

          state = 85;
          match(TOKEN_FALSE);
          break;
        case TOKEN_TRUE:
          _localctx = TrueExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 86;
          match(TOKEN_TRUE);
          break;
        case TOKEN_INT:
          _localctx = NumberExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 87;
          number();
          break;
        case TOKEN_OP:
        case TOKEN_NAME:
          _localctx = PrefixExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 88;
          prefix();
          break;
        case TOKEN_MINUS:
        case TOKEN_NOT:
          _localctx = UnaryExprContext(_localctx);
          context = _localctx;
          _prevctx = _localctx;
          state = 89;
          _localctx.op = tokenStream.LT(1);
          _la = tokenStream.LA(1)!;
          if (!(_la == TOKEN_MINUS || _la == TOKEN_NOT)) {
            _localctx.op = errorHandler.recoverInline(this);
          } else {
            if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
            errorHandler.reportMatch(this);
            consume();
          }
          state = 90;
          exp(7);
          break;
        default:
          throw NoViableAltException(this);
      }
      context!.stop = tokenStream.LT(-1);
      state = 116;
      errorHandler.sync(this);
      _alt = interpreter!.adaptivePredict(tokenStream, 8, context);
      while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
        if (_alt == 1) {
          if (parseListeners != null) triggerExitRuleEvent();
          _prevctx = _localctx;
          state = 114;
          errorHandler.sync(this);
          switch (interpreter!.adaptivePredict(tokenStream, 7, context)) {
            case 1:
              _localctx =
                  ExponentExprContext(ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 93;
              if (!(precpred(context, 8))) {
                throw FailedPredicateException(this, "precpred(context, 8)");
              }

              state = 94;
              match(TOKEN_CARET);
              state = 95;
              exp(8);
              break;
            case 2:
              _localctx =
                  MulDivModuloExprContext(ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 96;
              if (!(precpred(context, 6))) {
                throw FailedPredicateException(this, "precpred(context, 6)");
              }
              state = 97;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!((((_la) & ~0x3f) == 0 &&
                  ((1 << _la) & 18278776832) != 0))) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 98;
              exp(7);
              break;
            case 3:
              _localctx =
                  PlusMinusExprContext(ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 99;
              if (!(precpred(context, 5))) {
                throw FailedPredicateException(this, "precpred(context, 5)");
              }
              state = 100;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!(_la == TOKEN_MINUS || _la == TOKEN_PLUS)) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 101;
              exp(6);
              break;
            case 4:
              _localctx = BooleanBinaryLogicalExprContext(
                  ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 102;
              if (!(precpred(context, 4))) {
                throw FailedPredicateException(this, "precpred(context, 4)");
              }
              state = 103;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!((((_la) & ~0x3f) == 0 &&
                  ((1 << _la) & 36607886848) != 0))) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 104;
              exp(5);
              break;
            case 5:
              _localctx =
                  BooleanAndExprContext(ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 105;
              if (!(precpred(context, 3))) {
                throw FailedPredicateException(this, "precpred(context, 3)");
              }

              state = 106;
              match(TOKEN_AND);
              state = 107;
              exp(4);
              break;
            case 6:
              _localctx =
                  BooleanOrExprContext(ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 108;
              if (!(precpred(context, 2))) {
                throw FailedPredicateException(this, "precpred(context, 2)");
              }

              state = 109;
              match(TOKEN_OR);
              state = 110;
              exp(3);
              break;
            case 7:
              _localctx = IntBinaryLogicalExprContext(
                  ExpContext(_parentctx, _parentState));
              pushNewRecursionContext(_localctx, _startState, RULE_exp);
              state = 111;
              if (!(precpred(context, 1))) {
                throw FailedPredicateException(this, "precpred(context, 1)");
              }
              state = 112;
              _localctx.op = tokenStream.LT(1);
              _la = tokenStream.LA(1)!;
              if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 4302340096) != 0))) {
                _localctx.op = errorHandler.recoverInline(this);
              } else {
                if (tokenStream.LA(1)! == IntStream.EOF) matchedEOF = true;
                errorHandler.reportMatch(this);
                consume();
              }
              state = 113;
              exp(2);
              break;
          }
        }
        state = 118;
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

  PrefixContext prefix() {
    dynamic _localctx = PrefixContext(context, state);
    enterRule(_localctx, 20, RULE_prefix);
    int _la;
    try {
      state = 128;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
        case TOKEN_NAME:
          _localctx = VariablePrefixContext(_localctx);
          enterOuterAlt(_localctx, 1);
          state = 119;
          match(TOKEN_NAME);
          break;
        case TOKEN_OP:
          _localctx = ParenthesisPrefixContext(_localctx);
          enterOuterAlt(_localctx, 2);
          state = 120;
          match(TOKEN_OP);
          state = 124;
          errorHandler.sync(this);
          _la = tokenStream.LA(1)!;
          while ((((_la) & ~0x3f) == 0 && ((1 << _la) & 206159163392) != 0)) {
            state = 121;
            exp(0);
            state = 126;
            errorHandler.sync(this);
            _la = tokenStream.LA(1)!;
          }
          state = 127;
          match(TOKEN_CP);
          break;
        default:
          throw NoViableAltException(this);
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

  NumberContext number() {
    dynamic _localctx = NumberContext(context, state);
    enterRule(_localctx, 22, RULE_number);
    try {
      _localctx = IntegerValueContext(_localctx);
      enterOuterAlt(_localctx, 1);
      state = 130;
      match(TOKEN_INT);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  @override
  bool sempred(RuleContext? _localctx, int ruleIndex, int predIndex) {
    switch (ruleIndex) {
      case 9:
        return _exp_sempred(_localctx as ExpContext?, predIndex);
    }
    return true;
  }

  bool _exp_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0:
        return precpred(context, 8);
      case 1:
        return precpred(context, 6);
      case 2:
        return precpred(context, 5);
      case 3:
        return precpred(context, 4);
      case 4:
        return precpred(context, 3);
      case 5:
        return precpred(context, 2);
      case 6:
        return precpred(context, 1);
    }
    return true;
  }

  static const List<int> _serializedATN = [
    4,
    1,
    40,
    133,
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
    2,
    8,
    7,
    8,
    2,
    9,
    7,
    9,
    2,
    10,
    7,
    10,
    2,
    11,
    7,
    11,
    1,
    0,
    1,
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
    2,
    5,
    2,
    32,
    8,
    2,
    10,
    2,
    12,
    2,
    35,
    9,
    2,
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
    3,
    4,
    43,
    8,
    4,
    1,
    5,
    1,
    5,
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
    5,
    6,
    58,
    8,
    6,
    10,
    6,
    12,
    6,
    61,
    9,
    6,
    1,
    6,
    1,
    6,
    3,
    6,
    65,
    8,
    6,
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
    5,
    7,
    72,
    8,
    7,
    10,
    7,
    12,
    7,
    75,
    9,
    7,
    1,
    8,
    1,
    8,
    1,
    8,
    5,
    8,
    80,
    8,
    8,
    10,
    8,
    12,
    8,
    83,
    9,
    8,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    3,
    9,
    92,
    8,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    1,
    9,
    5,
    9,
    115,
    8,
    9,
    10,
    9,
    12,
    9,
    118,
    9,
    9,
    1,
    10,
    1,
    10,
    1,
    10,
    5,
    10,
    123,
    8,
    10,
    10,
    10,
    12,
    10,
    126,
    9,
    10,
    1,
    10,
    3,
    10,
    129,
    8,
    10,
    1,
    11,
    1,
    11,
    1,
    11,
    0,
    1,
    18,
    12,
    0,
    2,
    4,
    6,
    8,
    10,
    12,
    14,
    16,
    18,
    20,
    22,
    0,
    5,
    2,
    0,
    16,
    16,
    19,
    19,
    3,
    0,
    23,
    24,
    30,
    30,
    34,
    34,
    2,
    0,
    16,
    16,
    29,
    29,
    4,
    0,
    9,
    10,
    25,
    26,
    31,
    31,
    35,
    35,
    3,
    0,
    15,
    15,
    20,
    22,
    32,
    32,
    140,
    0,
    24,
    1,
    0,
    0,
    0,
    2,
    28,
    1,
    0,
    0,
    0,
    4,
    33,
    1,
    0,
    0,
    0,
    6,
    36,
    1,
    0,
    0,
    0,
    8,
    42,
    1,
    0,
    0,
    0,
    10,
    44,
    1,
    0,
    0,
    0,
    12,
    48,
    1,
    0,
    0,
    0,
    14,
    68,
    1,
    0,
    0,
    0,
    16,
    76,
    1,
    0,
    0,
    0,
    18,
    91,
    1,
    0,
    0,
    0,
    20,
    128,
    1,
    0,
    0,
    0,
    22,
    130,
    1,
    0,
    0,
    0,
    24,
    25,
    3,
    2,
    1,
    0,
    25,
    26,
    3,
    6,
    3,
    0,
    26,
    27,
    5,
    0,
    0,
    1,
    27,
    1,
    1,
    0,
    0,
    0,
    28,
    29,
    3,
    4,
    2,
    0,
    29,
    3,
    1,
    0,
    0,
    0,
    30,
    32,
    3,
    8,
    4,
    0,
    31,
    30,
    1,
    0,
    0,
    0,
    32,
    35,
    1,
    0,
    0,
    0,
    33,
    31,
    1,
    0,
    0,
    0,
    33,
    34,
    1,
    0,
    0,
    0,
    34,
    5,
    1,
    0,
    0,
    0,
    35,
    33,
    1,
    0,
    0,
    0,
    36,
    37,
    5,
    11,
    0,
    0,
    37,
    38,
    3,
    18,
    9,
    0,
    38,
    7,
    1,
    0,
    0,
    0,
    39,
    43,
    5,
    1,
    0,
    0,
    40,
    43,
    3,
    10,
    5,
    0,
    41,
    43,
    3,
    12,
    6,
    0,
    42,
    39,
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
    42,
    41,
    1,
    0,
    0,
    0,
    43,
    9,
    1,
    0,
    0,
    0,
    44,
    45,
    3,
    14,
    7,
    0,
    45,
    46,
    5,
    2,
    0,
    0,
    46,
    47,
    3,
    16,
    8,
    0,
    47,
    11,
    1,
    0,
    0,
    0,
    48,
    49,
    5,
    4,
    0,
    0,
    49,
    50,
    3,
    18,
    9,
    0,
    50,
    51,
    5,
    5,
    0,
    0,
    51,
    59,
    3,
    4,
    2,
    0,
    52,
    53,
    5,
    6,
    0,
    0,
    53,
    54,
    3,
    18,
    9,
    0,
    54,
    55,
    5,
    5,
    0,
    0,
    55,
    56,
    3,
    4,
    2,
    0,
    56,
    58,
    1,
    0,
    0,
    0,
    57,
    52,
    1,
    0,
    0,
    0,
    58,
    61,
    1,
    0,
    0,
    0,
    59,
    57,
    1,
    0,
    0,
    0,
    59,
    60,
    1,
    0,
    0,
    0,
    60,
    64,
    1,
    0,
    0,
    0,
    61,
    59,
    1,
    0,
    0,
    0,
    62,
    63,
    5,
    7,
    0,
    0,
    63,
    65,
    3,
    4,
    2,
    0,
    64,
    62,
    1,
    0,
    0,
    0,
    64,
    65,
    1,
    0,
    0,
    0,
    65,
    66,
    1,
    0,
    0,
    0,
    66,
    67,
    5,
    3,
    0,
    0,
    67,
    13,
    1,
    0,
    0,
    0,
    68,
    73,
    5,
    36,
    0,
    0,
    69,
    70,
    5,
    8,
    0,
    0,
    70,
    72,
    5,
    36,
    0,
    0,
    71,
    69,
    1,
    0,
    0,
    0,
    72,
    75,
    1,
    0,
    0,
    0,
    73,
    71,
    1,
    0,
    0,
    0,
    73,
    74,
    1,
    0,
    0,
    0,
    74,
    15,
    1,
    0,
    0,
    0,
    75,
    73,
    1,
    0,
    0,
    0,
    76,
    81,
    3,
    18,
    9,
    0,
    77,
    78,
    5,
    8,
    0,
    0,
    78,
    80,
    3,
    18,
    9,
    0,
    79,
    77,
    1,
    0,
    0,
    0,
    80,
    83,
    1,
    0,
    0,
    0,
    81,
    79,
    1,
    0,
    0,
    0,
    81,
    82,
    1,
    0,
    0,
    0,
    82,
    17,
    1,
    0,
    0,
    0,
    83,
    81,
    1,
    0,
    0,
    0,
    84,
    85,
    6,
    9,
    -1,
    0,
    85,
    92,
    5,
    12,
    0,
    0,
    86,
    92,
    5,
    13,
    0,
    0,
    87,
    92,
    3,
    22,
    11,
    0,
    88,
    92,
    3,
    20,
    10,
    0,
    89,
    90,
    7,
    0,
    0,
    0,
    90,
    92,
    3,
    18,
    9,
    7,
    91,
    84,
    1,
    0,
    0,
    0,
    91,
    86,
    1,
    0,
    0,
    0,
    91,
    87,
    1,
    0,
    0,
    0,
    91,
    88,
    1,
    0,
    0,
    0,
    91,
    89,
    1,
    0,
    0,
    0,
    92,
    116,
    1,
    0,
    0,
    0,
    93,
    94,
    10,
    8,
    0,
    0,
    94,
    95,
    5,
    33,
    0,
    0,
    95,
    115,
    3,
    18,
    9,
    8,
    96,
    97,
    10,
    6,
    0,
    0,
    97,
    98,
    7,
    1,
    0,
    0,
    98,
    115,
    3,
    18,
    9,
    7,
    99,
    100,
    10,
    5,
    0,
    0,
    100,
    101,
    7,
    2,
    0,
    0,
    101,
    115,
    3,
    18,
    9,
    6,
    102,
    103,
    10,
    4,
    0,
    0,
    103,
    104,
    7,
    3,
    0,
    0,
    104,
    115,
    3,
    18,
    9,
    5,
    105,
    106,
    10,
    3,
    0,
    0,
    106,
    107,
    5,
    27,
    0,
    0,
    107,
    115,
    3,
    18,
    9,
    4,
    108,
    109,
    10,
    2,
    0,
    0,
    109,
    110,
    5,
    28,
    0,
    0,
    110,
    115,
    3,
    18,
    9,
    3,
    111,
    112,
    10,
    1,
    0,
    0,
    112,
    113,
    7,
    4,
    0,
    0,
    113,
    115,
    3,
    18,
    9,
    2,
    114,
    93,
    1,
    0,
    0,
    0,
    114,
    96,
    1,
    0,
    0,
    0,
    114,
    99,
    1,
    0,
    0,
    0,
    114,
    102,
    1,
    0,
    0,
    0,
    114,
    105,
    1,
    0,
    0,
    0,
    114,
    108,
    1,
    0,
    0,
    0,
    114,
    111,
    1,
    0,
    0,
    0,
    115,
    118,
    1,
    0,
    0,
    0,
    116,
    114,
    1,
    0,
    0,
    0,
    116,
    117,
    1,
    0,
    0,
    0,
    117,
    19,
    1,
    0,
    0,
    0,
    118,
    116,
    1,
    0,
    0,
    0,
    119,
    129,
    5,
    36,
    0,
    0,
    120,
    124,
    5,
    17,
    0,
    0,
    121,
    123,
    3,
    18,
    9,
    0,
    122,
    121,
    1,
    0,
    0,
    0,
    123,
    126,
    1,
    0,
    0,
    0,
    124,
    122,
    1,
    0,
    0,
    0,
    124,
    125,
    1,
    0,
    0,
    0,
    125,
    127,
    1,
    0,
    0,
    0,
    126,
    124,
    1,
    0,
    0,
    0,
    127,
    129,
    5,
    18,
    0,
    0,
    128,
    119,
    1,
    0,
    0,
    0,
    128,
    120,
    1,
    0,
    0,
    0,
    129,
    21,
    1,
    0,
    0,
    0,
    130,
    131,
    5,
    37,
    0,
    0,
    131,
    23,
    1,
    0,
    0,
    0,
    11,
    33,
    42,
    59,
    64,
    73,
    81,
    91,
    114,
    116,
    124,
    128
  ];

  static final ATN _ATN = ATNDeserializer().deserialize(_serializedATN);
}

class Start_Context extends ParserRuleContext {
  ChunkContext? chunk() => getRuleContext<ChunkContext>(0);
  ReturnStatContext? returnStat() => getRuleContext<ReturnStatContext>(0);
  TerminalNode? EOF() => getToken(LuaParser.TOKEN_EOF, 0);
  Start_Context([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_start_;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitStart_(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ChunkContext extends ParserRuleContext {
  BlockContext? block() => getRuleContext<BlockContext>(0);
  ChunkContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_chunk;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitChunk(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BlockContext extends ParserRuleContext {
  List<StatContext> stats() => getRuleContexts<StatContext>();
  StatContext? stat(int i) => getRuleContext<StatContext>(i);
  BlockContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_block;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitBlock(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ReturnStatContext extends ParserRuleContext {
  TerminalNode? RETURN() => getToken(LuaParser.TOKEN_RETURN, 0);
  ExpContext? exp() => getRuleContext<ExpContext>(0);
  ReturnStatContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_returnStat;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitReturnStat(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class StatContext extends ParserRuleContext {
  StatContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_stat;
}

class AssignContext extends ParserRuleContext {
  NamelistContext? namelist() => getRuleContext<NamelistContext>(0);
  TerminalNode? EQ() => getToken(LuaParser.TOKEN_EQ, 0);
  ExplistContext? explist() => getRuleContext<ExplistContext>(0);
  AssignContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_assign;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitAssign(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class IfstatContext extends ParserRuleContext {
  BlockContext? endExec;
  TerminalNode? IF() => getToken(LuaParser.TOKEN_IF, 0);
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  List<TerminalNode> THENs() => getTokens(LuaParser.TOKEN_THEN);
  TerminalNode? THEN(int i) => getToken(LuaParser.TOKEN_THEN, i);
  List<BlockContext> blocks() => getRuleContexts<BlockContext>();
  BlockContext? block(int i) => getRuleContext<BlockContext>(i);
  TerminalNode? END() => getToken(LuaParser.TOKEN_END, 0);
  List<TerminalNode> ELSEIFs() => getTokens(LuaParser.TOKEN_ELSEIF);
  TerminalNode? ELSEIF(int i) => getToken(LuaParser.TOKEN_ELSEIF, i);
  TerminalNode? ELSE() => getToken(LuaParser.TOKEN_ELSE, 0);
  IfstatContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ifstat;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitIfstat(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NamelistContext extends ParserRuleContext {
  List<TerminalNode> NAMEs() => getTokens(LuaParser.TOKEN_NAME);
  TerminalNode? NAME(int i) => getToken(LuaParser.TOKEN_NAME, i);
  List<TerminalNode> COMMAs() => getTokens(LuaParser.TOKEN_COMMA);
  TerminalNode? COMMA(int i) => getToken(LuaParser.TOKEN_COMMA, i);
  NamelistContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_namelist;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitNamelist(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ExplistContext extends ParserRuleContext {
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  List<TerminalNode> COMMAs() => getTokens(LuaParser.TOKEN_COMMA);
  TerminalNode? COMMA(int i) => getToken(LuaParser.TOKEN_COMMA, i);
  ExplistContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_explist;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitExplist(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ExpContext extends ParserRuleContext {
  ExpContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_exp;
}

class PrefixContext extends ParserRuleContext {
  PrefixContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_prefix;
}

class NumberContext extends ParserRuleContext {
  NumberContext([ParserRuleContext? parent, int? invokingState])
      : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_number;
}

class SemiColumnExecContext extends StatContext {
  TerminalNode? SEMI() => getToken(LuaParser.TOKEN_SEMI, 0);
  SemiColumnExecContext(StatContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitSemiColumnExec(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class IfExecContext extends StatContext {
  IfstatContext? ifstat() => getRuleContext<IfstatContext>(0);
  IfExecContext(StatContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitIfExec(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class AssignExecContext extends StatContext {
  AssignContext? assign() => getRuleContext<AssignContext>(0);
  AssignExecContext(StatContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitAssignExec(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class PrefixExprContext extends ExpContext {
  PrefixContext? prefix() => getRuleContext<PrefixContext>(0);
  PrefixExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitPrefixExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class UnaryExprContext extends ExpContext {
  Token? op;
  ExpContext? exp() => getRuleContext<ExpContext>(0);
  TerminalNode? NOT() => getToken(LuaParser.TOKEN_NOT, 0);
  TerminalNode? MINUS() => getToken(LuaParser.TOKEN_MINUS, 0);
  UnaryExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitUnaryExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ExponentExprContext extends ExpContext {
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? CARET() => getToken(LuaParser.TOKEN_CARET, 0);
  ExponentExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitExponentExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class TrueExprContext extends ExpContext {
  TerminalNode? TRUE() => getToken(LuaParser.TOKEN_TRUE, 0);
  TrueExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitTrueExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class NumberExprContext extends ExpContext {
  NumberContext? number() => getRuleContext<NumberContext>(0);
  NumberExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitNumberExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class PlusMinusExprContext extends ExpContext {
  Token? op;
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? PLUS() => getToken(LuaParser.TOKEN_PLUS, 0);
  TerminalNode? MINUS() => getToken(LuaParser.TOKEN_MINUS, 0);
  PlusMinusExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitPlusMinusExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanAndExprContext extends ExpContext {
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? AND() => getToken(LuaParser.TOKEN_AND, 0);
  BooleanAndExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitBooleanAndExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanOrExprContext extends ExpContext {
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? OR() => getToken(LuaParser.TOKEN_OR, 0);
  BooleanOrExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitBooleanOrExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class MulDivModuloExprContext extends ExpContext {
  Token? op;
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? STAR() => getToken(LuaParser.TOKEN_STAR, 0);
  TerminalNode? SLASH() => getToken(LuaParser.TOKEN_SLASH, 0);
  TerminalNode? PER() => getToken(LuaParser.TOKEN_PER, 0);
  TerminalNode? SS() => getToken(LuaParser.TOKEN_SS, 0);
  MulDivModuloExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitMulDivModuloExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class IntBinaryLogicalExprContext extends ExpContext {
  Token? op;
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? AMP() => getToken(LuaParser.TOKEN_AMP, 0);
  TerminalNode? PIPE() => getToken(LuaParser.TOKEN_PIPE, 0);
  TerminalNode? SQUIG() => getToken(LuaParser.TOKEN_SQUIG, 0);
  TerminalNode? LL() => getToken(LuaParser.TOKEN_LL, 0);
  TerminalNode? GG() => getToken(LuaParser.TOKEN_GG, 0);
  IntBinaryLogicalExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitIntBinaryLogicalExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class FalseExprContext extends ExpContext {
  TerminalNode? FALSE() => getToken(LuaParser.TOKEN_FALSE, 0);
  FalseExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitFalseExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class BooleanBinaryLogicalExprContext extends ExpContext {
  Token? op;
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  TerminalNode? LT() => getToken(LuaParser.TOKEN_LT, 0);
  TerminalNode? GT() => getToken(LuaParser.TOKEN_GT, 0);
  TerminalNode? LE() => getToken(LuaParser.TOKEN_LE, 0);
  TerminalNode? GE() => getToken(LuaParser.TOKEN_GE, 0);
  TerminalNode? SQEQ() => getToken(LuaParser.TOKEN_SQEQ, 0);
  TerminalNode? EE() => getToken(LuaParser.TOKEN_EE, 0);
  BooleanBinaryLogicalExprContext(ExpContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitBooleanBinaryLogicalExpr(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class ParenthesisPrefixContext extends PrefixContext {
  TerminalNode? OP() => getToken(LuaParser.TOKEN_OP, 0);
  TerminalNode? CP() => getToken(LuaParser.TOKEN_CP, 0);
  List<ExpContext> exps() => getRuleContexts<ExpContext>();
  ExpContext? exp(int i) => getRuleContext<ExpContext>(i);
  ParenthesisPrefixContext(PrefixContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitParenthesisPrefix(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class VariablePrefixContext extends PrefixContext {
  TerminalNode? NAME() => getToken(LuaParser.TOKEN_NAME, 0);
  VariablePrefixContext(PrefixContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitVariablePrefix(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}

class IntegerValueContext extends NumberContext {
  TerminalNode? INT() => getToken(LuaParser.TOKEN_INT, 0);
  IntegerValueContext(NumberContext ctx) {
    copyFrom(ctx);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is LuaVisitor<T>) {
      return visitor.visitIntegerValue(this);
    } else {
      return visitor.visitChildren(this);
    }
  }
}
