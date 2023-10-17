import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';

class PositionConstraintBailErrorStrategy extends DefaultErrorStrategy {
  final TranslationsWrapper translations;

  PositionConstraintBailErrorStrategy(this.translations) : super();

  @override
  void recover(Parser recognizer, RecognitionException<IntStream> e) {
    throw ParseCancellationException(e.message);
  }

  @override
  Token recoverInline(Parser recognizer) {
    final exception = InputMismatchException(recognizer);
    reportError(recognizer, exception);
    throw exception;
  }

  @override
  void reportError(Parser recognizer, RecognitionException<IntStream> e) {
    switch (e) {
      case InputMismatchException():
        throw ParseCancellationException(
            _buildInputMismatchExceptionMessage(recognizer, e));
      // This one should not happen
      case FailedPredicateException():
        throw ParseCancellationException("Unexpected semantic predicate error");
      case NoViableAltException():
        throw ParseCancellationException(_buildRecognitionExceptionMessage(e));
      default:
        throw ParseCancellationException(translations.miscParseError);
    }
  }

  @override
  String getTokenErrorDisplay(Token? t) {
    return t == null
        ? translations.noAntlr4Token
        : escapeWSAndQuote("<${_getErrorSymbol(t)}>");
  }

  String _getErrorSymbol(Token t) {
    var symbol = getSymbolText(t);
    symbol ??= _tokenIsEOF(t) ? translations.eof : getSymbolType(t).toString();
    return symbol;
  }

  String _buildRecognitionExceptionMessage(NoViableAltException? error) {
    final inputToken = escapeWSAndQuote(error!.offendingToken.text!);
    final lineNumber = error.offendingToken.line!;
    final positionInLine = error.offendingToken.charPositionInLine;

    return translations.noViableAltException(
      PositionInLine: positionInLine,
      Token: inputToken,
      LineNumber: lineNumber,
    );
  }

  String _buildInputMismatchExceptionMessage(
      Parser? recognizer, RecognitionException? error) {
    final line = error!.offendingToken.line!;
    final positionInLine = error.offendingToken.charPositionInLine;
    final tokenErrorDisplay = getTokenErrorDisplay(error.offendingToken);
    final expectedToken =
        error.expectedTokens!.toString(vocabulary: recognizer?.vocabulary);

    return translations.inputMismatch(
      Expected: expectedToken,
      Index: positionInLine,
      Line: line,
      Received: tokenErrorDisplay,
    );
  }

  bool _tokenIsEOF(Token t) {
    return getSymbolType(t) == Token.EOF;
  }
}
