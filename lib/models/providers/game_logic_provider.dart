import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chess/chess.dart' as chess;

const emptyPosition = '8/8/8/8/8/8/8/8 w - - 0 1';

class GameLogicNotifier extends StateNotifier<chess.Chess> {
  GameLogicNotifier() : super(chess.Chess.fromFEN(emptyPosition));

  void changeWith(chess.Chess newLogic) {
    state = newLogic;
  }

  void makeMove(chess.Move move) {
    final clone = chess.Chess.fromFEN(state.fen);
    clone.make_move(move);
    state = clone;
  }

  bool move(move) {
    final clone = chess.Chess.fromFEN(state.fen);
    final result = clone.move(move);
    state = clone;
    return result;
  }

  chess.Move? undoMove() {
    final clone = chess.Chess.fromFEN(state.fen);
    final move = clone.undo_move();
    state = clone;
    return move;
  }

  String moveToSan(chess.Move move) {
    final result = state.move_to_san(move);
    return result;
  }


  chess.Color get turn => state.turn;
  List<chess.State> get history => state.history;
  String get fen => state.fen;

  bool get inCheckmate => state.in_checkmate;
  bool get inStalemate => state.in_stalemate;
  bool get insufficientMaterial => state.insufficient_material;
  bool get inDraw => state.in_draw;
  bool get inThreeFoldRepetition => state.in_threefold_repetition;
}

final gameLogicProvider = StateNotifierProvider<GameLogicNotifier, chess.Chess>((ref) {
  return GameLogicNotifier();
});