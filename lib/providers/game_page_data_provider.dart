import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';

@immutable
class GamePageData {
  final bool blackSideAtBottom;
  final bool gameStart;
  final bool gameInProgress;
  final List<HistoryNode> historyNodesDescriptions;
  final bool engineThinking;
  final bool stockfishReady;
  final Option<BoardArrow> lastMoveToHighlight;
  final Option<int> historySelectedNodeIndex;
  final Option<PlayerType> whitePlayerType;
  final Option<PlayerType> blackPlayerType;

  const GamePageData({
    this.blackSideAtBottom = false,
    this.whitePlayerType = const None(),
    this.blackPlayerType = const None(),
    this.gameStart = true,
    this.gameInProgress = true,
    this.lastMoveToHighlight = const None(),
    this.historyNodesDescriptions = const <HistoryNode>[],
    this.historySelectedNodeIndex = const None(),
    this.engineThinking = false,
    this.stockfishReady = false,
  });

  GamePageData copyWith({
    bool? blackSideAtBottom,
    bool? gameStart,
    bool? gameInProgress,
    List<HistoryNode>? historyNodesDescriptions,
    bool? engineThinking,
    bool? stockfishReady,
    Option<BoardArrow>? lastMoveToHighlight,
    Option<int>? historySelectedNodeIndex,
    Option<PlayerType>? whitePlayerType,
    Option<PlayerType>? blackPlayerType,
  }) {
    return GamePageData(
      blackSideAtBottom: blackSideAtBottom ?? this.blackSideAtBottom,
      whitePlayerType: whitePlayerType ?? this.whitePlayerType,
      blackPlayerType: blackPlayerType ?? this.blackPlayerType,
      gameStart: gameStart ?? this.gameStart,
      gameInProgress: gameInProgress ?? this.gameInProgress,
      lastMoveToHighlight: lastMoveToHighlight ?? this.lastMoveToHighlight,
      historyNodesDescriptions:
          historyNodesDescriptions ?? this.historyNodesDescriptions,
      historySelectedNodeIndex:
          historySelectedNodeIndex ?? this.historySelectedNodeIndex,
      engineThinking: engineThinking ?? this.engineThinking,
      stockfishReady: stockfishReady ?? this.stockfishReady,
    );
  }
}

class GamePageDataNotifier extends StateNotifier<GamePageData> {
  GamePageDataNotifier() : super(const GamePageData());

  void clearLastMoveToHighlight() {
    state = state.copyWith(lastMoveToHighlight: None());
  }

  void clearSelectedHistoryIndex() {
    state = state.copyWith(historySelectedNodeIndex: None());
  }

  void clearHistory() {
    state = state.copyWith(historyNodesDescriptions: <HistoryNode>[]);
  }

  void setBlackSideAtBottom(bool newValue) {
    state = state.copyWith(blackSideAtBottom: newValue);
  }

  void setWhitePlayerType(Option<PlayerType> newValue) {
    state = state.copyWith(whitePlayerType: newValue);
  }

  void setBlackPlayerType(Option<PlayerType> newValue) {
    state = state.copyWith(blackPlayerType: newValue);
  }

  void setGameStart(bool newValue) {
    state = state.copyWith(gameStart: newValue);
  }

  void setGameInProgress(bool newValue) {
    state = state.copyWith(gameInProgress: newValue);
  }

  void setLastMoveToHighlight(Option<BoardArrow> newValue) {
    state = state.copyWith(lastMoveToHighlight: newValue);
  }

  void setHistorySelectedNodeIndex(Option<int> newValue) {
    state = state.copyWith(historySelectedNodeIndex: newValue);
  }

  void setEngineThinking(bool newValue) {
    state = state.copyWith(engineThinking: newValue);
  }

  void setStockfishReady(bool newValue) {
    state = state.copyWith(stockfishReady: newValue);
  }

  void addNodeToHistory(HistoryNode newNode) {
    final newHistory = state.historyNodesDescriptions;
    newHistory.add(newNode);
    state = state.copyWith(historyNodesDescriptions: newHistory);
  }

  bool get blackSideAtBottom => state.blackSideAtBottom;
  Option<PlayerType> get whitePlayerType => state.whitePlayerType;
  Option<PlayerType> get blackPlayerType => state.blackPlayerType;
  bool get gameStart => state.gameStart;
  bool get gameInProgress => state.gameInProgress;
  Option<BoardArrow> get lastMoveToHighlight => state.lastMoveToHighlight;
  List<HistoryNode> get historyNodesDescriptions =>
      state.historyNodesDescriptions;
  Option<int> get historySelectedNodeIndex => state.historySelectedNodeIndex;
  bool get engineThinking => state.engineThinking;
  bool get stockfishReady => state.stockfishReady;
}

final gamePageDataProvider =
    StateNotifierProvider<GamePageDataNotifier, GamePageData>(
  (ref) => GamePageDataNotifier(),
);
