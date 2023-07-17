import 'package:antlr4/antlr4.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PositionConstraintBailErrorStrategy extends DefaultErrorStrategy {
  final AppLocalizations localizations;

  PositionConstraintBailErrorStrategy(this.localizations) : super();

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
        throw ParseCancellationException(
            localizations.scriptParser_miscParseError);
    }
  }

  @override
  String getTokenErrorDisplay(Token? t) {
    return t == null
        ? localizations.scriptParser_noAntlr4Token
        : escapeWSAndQuote("<${_getErrorSymbol(t)}>");
  }

  String _getErrorSymbol(Token t) {
    var symbol = getSymbolText(t);
    symbol ??= _tokenIsEOF(t)
        ? localizations.scriptParser_eof
        : getSymbolType(t).toString();
    return symbol;
  }

  String _buildRecognitionExceptionMessage(NoViableAltException? error) {
    final inputToken = escapeWSAndQuote(error!.offendingToken.text!);
    final line = error.offendingToken.line!;
    final positionInLine = error.offendingToken.charPositionInLine;

    return localizations.scriptParser_noViableAltException(
        inputToken, line, positionInLine);
  }

  String _buildInputMismatchExceptionMessage(
      Parser? recognizer, RecognitionException? error) {
    final line = error!.offendingToken.line!;
    final positionInLine = error.offendingToken.charPositionInLine;
    final tokenErrorDisplay = getTokenErrorDisplay(error.offendingToken);
    final expectedToken =
        error.expectedTokens!.toString(vocabulary: recognizer?.vocabulary);

    return localizations.scriptParser_inputMismatch(
      line,
      positionInLine,
      expectedToken,
      tokenErrorDisplay,
    );
  }

  bool _tokenIsEOF(Token t) {
    return getSymbolType(t) == Token.EOF;
  }
}
