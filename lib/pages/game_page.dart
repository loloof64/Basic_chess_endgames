import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/data/stockfish_manager.dart';
import 'package:basicchessendgamestrainer/logic/utils.dart';
import 'package:basicchessendgamestrainer/models/providers/game_logic_provider.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_landscape.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_portrait.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';
import 'package:basicchessendgamestrainer/models/providers/game_session_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const piecesSize = 60.0;

class GamePage extends HookConsumerWidget {
  const GamePage({super.key});

  void initState({
    required BuildContext context,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> stockfishReady,
    required WidgetRef ref,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
    required ValueNotifier<bool> blackSideAtBottom,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
  }) async {
    stockfishManager.geOutputStream().listen((line) {
      if (!context.mounted) return;
      _processStockfishLine(
        line: line,
        ref: ref,
        context: context,
        stockfishReady: stockfishReady,
        engineThinking: engineThinking,
        gameInProgress: gameInProgress,
        gameStart: gameStart,
        historyNodesDescriptions: historyNodesDescriptions,
        lastMoveToHighlight: lastMoveToHighlight,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        whitePlayerType: whitePlayerType,
        blackPlayerType: blackPlayerType,
      );
    });
    stockfishManager.sendCommand('isready');
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final gameStartAsWhite = startPosition.split(" ")[1] == "w";
    if (gameStartAsWhite) {
      whitePlayerType.value = PlayerType.human;
      blackPlayerType.value = PlayerType.computer;
      blackSideAtBottom.value = false;
    } else {
      whitePlayerType.value = PlayerType.computer;
      blackPlayerType.value = PlayerType.human;
      blackSideAtBottom.value = true;
    }
    await Future.delayed(const Duration(milliseconds: 50));
    _doStartNewGame(
      engineThinking: engineThinking,
      gameInProgress: gameInProgress,
      gameStart: gameStart,
      historyNodesDescriptions: historyNodesDescriptions,
      historySelectedNodeIndex: historySelectedNodeIndex,
      lastMoveToHighlight: lastMoveToHighlight,
      ref: ref,
    );
  }

  void _updateHistoryScrollPosition({
    required BuildContext context,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ScrollController historyScrollController,
  }) {
    if (gameInProgress.value) {
      historyScrollController.animateTo(
        historyScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    } else {
      if (historySelectedNodeIndex.value != null) {
        final availableScrollExtent =
            historyScrollController.position.maxScrollExtent;
        final windowWidth = MediaQuery.of(context).size.width;
        final elementsCount = historyNodesDescriptions.value.length;
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final averageNodeSize = isPortrait
            ? MediaQuery.of(context).size.width * 0.11
            : MediaQuery.of(context).size.height * 0.20;
        final averageItemsPerScreen = windowWidth / averageNodeSize * 0.625;
        var realIndex =
            (historySelectedNodeIndex.value! - averageItemsPerScreen)
                .ceil()
                .toInt();
        realIndex = realIndex > 0 ? realIndex : 0;
        final realElementsCount =
            (elementsCount - averageItemsPerScreen).toInt();
        final double averageScroll = realElementsCount > 0
            ? 1.05 * availableScrollExtent / realElementsCount
            : 0;
        final scrollPosition = realIndex * averageScroll;

        historyScrollController.jumpTo(
          scrollPosition,
        );
      } else {
        historyScrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 50), curve: Curves.linear);
      }
    }
  }

  void _doStartNewGame({
    required WidgetRef ref,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
  }) {
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final newGameLogic = chess.Chess.fromFEN(startPosition);
    final isWhiteTurn = ref.read(gameSessionProvider).playerHasWhite;
    final moveNumberCaption =
        "${newGameLogic.fen.split(' ')[5]}.${isWhiteTurn ? '' : '..'}";
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier.changeWith(newGameLogic);
    gameStart.value = true;
    lastMoveToHighlight.value = null;
    historyNodesDescriptions.value = [];
    historyNodesDescriptions.value.add(HistoryNode(caption: moveNumberCaption));
    historySelectedNodeIndex.value = null;
    gameInProgress.value = true;
    engineThinking.value = false;
  }

  void _processStockfishLine({
    required String line,
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> stockfishReady,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
  }) {
    if (!context.mounted) return;
    final trimedLine = line.trim().toLowerCase();
    if (trimedLine == 'readyok') {
      stockfishReady.value = true;
    } else if (trimedLine.startsWith("bestmove")) {
      _processBestMove(
        moveUci: trimedLine.split(" ")[1],
        ref: ref,
        context: context,
        engineThinking: engineThinking,
        gameInProgress: gameInProgress,
        gameStart: gameStart,
        stockfishReady: stockfishReady,
        historyNodesDescriptions: historyNodesDescriptions,
        lastMoveToHighlight: lastMoveToHighlight,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        whitePlayerType: whitePlayerType,
        blackPlayerType: blackPlayerType,
      );
    }
  }

  void _processBestMove({
    required String moveUci,
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> stockfishReady,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
  }) {
    if (!context.mounted) return;
    final startSquareStr = moveUci.substring(0, 2);
    final endSquareStr = moveUci.substring(2, 4);
    final promotionStr = moveUci.length >= 5 ? moveUci.substring(5, 6) : null;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    final gameLogicClone = chess.Chess.fromFEN(gameLogicNotifier.fen);
    final moveHasBeenMade = gameLogicClone.move({
      'from': startSquareStr,
      'to': endSquareStr,
      'promotion': promotionStr,
    });
    engineThinking.value = false;
    if (moveHasBeenMade) {
      final whiteMove = gameLogicClone.turn == chess.Color.WHITE;
      final lastPlayedMove = gameLogicClone.history.last.move;

      /*
      We need to know if it was white move before the move which
      we want to add history node(s).
      */
      if (!whiteMove && !gameStart.value) {
        final moveNumberCaption = "${gameLogicClone.fen.split(' ')[5]}.";
        historyNodesDescriptions.value
            .add(HistoryNode(caption: moveNumberCaption));
        _updateHistoryScrollPosition(
          context: context,
          gameInProgress: gameInProgress,
          historyNodesDescriptions: historyNodesDescriptions,
          historyScrollController: historyScrollController,
          historySelectedNodeIndex: historySelectedNodeIndex,
        );
      }

      // In order to get move SAN, it must not be done on board yet !
      final san = gameLogicNotifier.moveToSan(lastPlayedMove);
      gameLogicNotifier.changeWith(gameLogicClone);

      final fan = san.toFan(whiteMove: !whiteMove);

      historyNodesDescriptions.value.add(
        HistoryNode(
          caption: fan,
          fen: gameLogicNotifier.fen,
          move: Move(
            from: Cell.fromString(startSquareStr),
            to: Cell.fromString(endSquareStr),
          ),
        ),
      );
      lastMoveToHighlight.value = BoardArrow(
        from: startSquareStr,
        to: endSquareStr,
      );
      gameStart.value = false;

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!context.mounted) return;
        _updateHistoryScrollPosition(
          context: context,
          gameInProgress: gameInProgress,
          historyNodesDescriptions: historyNodesDescriptions,
          historyScrollController: historyScrollController,
          historySelectedNodeIndex: historySelectedNodeIndex,
        );
      });

      _handleGameEndedIfNeeded(
        context: context,
        ref: ref,
        gameInProgress: gameInProgress,
        historyNodesDescriptions: historyNodesDescriptions,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        lastMoveToHighlight: lastMoveToHighlight,
      );
      if (gameInProgress.value) {
        _makeComputerPlay(
          ref: ref,
          whitePlayerType: whitePlayerType,
          blackPlayerType: blackPlayerType,
          engineThinking: engineThinking,
          stockfishReady: stockfishReady,
        );
      }
    }
  }

  void _purposeStartNewGame({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
  }) {
    final confirmationDialog = AlertDialog(
      title: Text(
        t.game_page.new_game_title,
      ),
      content: Text(
        t.game_page.new_game_message,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            t.misc.button_cancel,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _doStartNewGame(
              ref: ref,
              gameStart: gameStart,
              engineThinking: engineThinking,
              gameInProgress: gameInProgress,
              historyNodesDescriptions: historyNodesDescriptions,
              historySelectedNodeIndex: historySelectedNodeIndex,
              lastMoveToHighlight: lastMoveToHighlight,
            );
          },
          child: Text(
            t.misc.button_ok,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (ctx) {
          return confirmationDialog;
        });
  }

  void _toggleBoardOrientation({
    required ValueNotifier<bool> blackSideAtBottom,
  }) {
    blackSideAtBottom.value = !blackSideAtBottom.value;
  }

  void _onStopRequested({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ScrollController historyScrollController,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    final noGameRunning = gameInProgress.value == false;
    if (noGameRunning) return;

    final confirmDialog = AlertDialog(
      title: Text(t.game_page.stop_game_title),
      content: Text(t.game_page.stop_game_message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            t.misc.button_cancel,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _doStopGame(
              context: context,
              ref: ref,
              gameInProgress: gameInProgress,
              historyNodesDescriptions: historyNodesDescriptions,
              historyScrollController: historyScrollController,
              historySelectedNodeIndex: historySelectedNodeIndex,
              lastMoveToHighlight: lastMoveToHighlight,
            );
          },
          child: Text(
            t.misc.button_ok,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (ctx) {
          return confirmDialog;
        });
  }

  void _doStopGame({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ScrollController historyScrollController,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    final snackBar = SnackBar(
      content: Text(t.game_page.game_stopped),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    gameInProgress.value = false;
    _selectLastHistoryNode(
      context: context,
      ref: ref,
      gameInProgress: gameInProgress,
      historyNodesDescriptions: historyNodesDescriptions,
      historyScrollController: historyScrollController,
      historySelectedNodeIndex: historySelectedNodeIndex,
      lastMoveToHighlight: lastMoveToHighlight,
    );
  }

  Future<PieceType?> _onPromote({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final gameLogic = ref.read(gameLogicProvider);
    final whiteTurn = gameLogic.fen.split(' ')[1] == 'w';

    return showDialog<PieceType>(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            alignment: Alignment.center,
            content: FittedBox(
                child: Row(
              children: [
                InkWell(
                  child: whiteTurn
                      ? WhiteQueen(
                          size: piecesSize,
                        )
                      : BlackQueen(
                          size: piecesSize,
                        ),
                  onTap: () {
                    Navigator.of(context).pop(PieceType.queen);
                  },
                ),
                InkWell(
                  child: whiteTurn
                      ? WhiteRook(
                          size: piecesSize,
                        )
                      : BlackRook(
                          size: piecesSize,
                        ),
                  onTap: () {
                    Navigator.of(context).pop(PieceType.rook);
                  },
                ),
                InkWell(
                  child: whiteTurn
                      ? WhiteBishop(
                          size: piecesSize,
                        )
                      : BlackBishop(
                          size: piecesSize,
                        ),
                  onTap: () {
                    Navigator.of(context).pop(PieceType.bishop);
                  },
                ),
                InkWell(
                  child: whiteTurn
                      ? WhiteKnight(
                          size: piecesSize,
                        )
                      : BlackKnight(
                          size: piecesSize,
                        ),
                  onTap: () {
                    Navigator.of(context).pop(PieceType.knight);
                  },
                ),
              ],
            )),
          );
        });
  }

  void _onMove({
    required ShortMove move,
    required WidgetRef ref,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
    required BuildContext context,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> stockfishReady,
    required ValueNotifier<bool> engineThinking,
  }) {
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    final iswhiteTurn = gameLogicNotifier.turn == chess.Color.WHITE;
    final isPlayerTurn =
        (iswhiteTurn && whitePlayerType.value == PlayerType.human) ||
            (!iswhiteTurn && blackPlayerType.value == PlayerType.human);
    if (!isPlayerTurn) return;
    final gameLogicClone = chess.Chess.fromFEN(gameLogicNotifier.fen);
    final moveHasBeenMade = gameLogicClone.move({
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion?.name,
    });
    if (moveHasBeenMade) {
      final whiteMove = gameLogicClone.turn == chess.Color.WHITE;
      final lastPlayedMove = gameLogicClone.history.last.move;

      /*
      We need to know if it was white move before the move which
      we want to add history node(s).
      */
      if (!whiteMove && !gameStart.value) {
        final moveNumberCaption = "${gameLogicClone.fen.split(' ')[5]}.";
        historyNodesDescriptions.value
            .add(HistoryNode(caption: moveNumberCaption));
        _updateHistoryScrollPosition(
          context: context,
          gameInProgress: gameInProgress,
          historyNodesDescriptions: historyNodesDescriptions,
          historyScrollController: historyScrollController,
          historySelectedNodeIndex: historySelectedNodeIndex,
        );
      }

      // In order to get move SAN, it must not be done on board yet !
      final san = gameLogicNotifier.moveToSan(lastPlayedMove);
      gameLogicNotifier.changeWith(gameLogicClone);

      final fan = san.toFan(whiteMove: !whiteMove);

      historyNodesDescriptions.value.add(
        HistoryNode(
          caption: fan,
          fen: gameLogicNotifier.fen,
          move: Move(
            from: Cell.fromString(move.from),
            to: Cell.fromString(move.to),
          ),
        ),
      );
      lastMoveToHighlight.value = BoardArrow(
        from: move.from,
        to: move.to,
      );
      gameStart.value = false;

      _updateHistoryScrollPosition(
        context: context,
        gameInProgress: gameInProgress,
        historyNodesDescriptions: historyNodesDescriptions,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
      );

      _handleGameEndedIfNeeded(
        context: context,
        ref: ref,
        gameInProgress: gameInProgress,
        historyNodesDescriptions: historyNodesDescriptions,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        lastMoveToHighlight: lastMoveToHighlight,
      );
      if (gameInProgress.value) {
        _makeComputerPlay(
          ref: ref,
          stockfishReady: stockfishReady,
          whitePlayerType: whitePlayerType,
          blackPlayerType: blackPlayerType,
          engineThinking: engineThinking,
        );
      }
    }
  }

  void _handleGameEndedIfNeeded({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ScrollController historyScrollController,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    String? snackMessage;
    if (gameLogicNotifier.inCheckmate) {
      final whiteTurnBeforeMove = gameLogicNotifier.turn == chess.Color.BLACK;
      snackMessage = whiteTurnBeforeMove
          ? t.game_page.checkmate_white
          : t.game_page.checkmate_black;
    } else if (gameLogicNotifier.inStalemate) {
      snackMessage = t.game_page.stalemate;
    } else if (gameLogicNotifier.inThreeFoldRepetition) {
      snackMessage = t.game_page.three_fold_repetition;
    } else if (gameLogicNotifier.insufficientMaterial) {
      snackMessage = t.game_page.missing_material;
    } else if (gameLogicNotifier.inDraw) {
      snackMessage = t.game_page.fifty_moves_rule;
    }

    if (snackMessage != null) {
      gameInProgress.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackMessage),
        ),
      );
      _selectLastHistoryNode(
        context: context,
        ref: ref,
        gameInProgress: gameInProgress,
        historyNodesDescriptions: historyNodesDescriptions,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        lastMoveToHighlight: lastMoveToHighlight,
      );
    }
  }

  void _selectFirstGamePosition({
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ScrollController historyScrollController,
  }) {
    if (gameInProgress.value) return;
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    historySelectedNodeIndex.value = null;
    lastMoveToHighlight.value = null;
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(startPosition));
    historyScrollController.animateTo(
      0,
      duration: const Duration(
        milliseconds: 50,
      ),
      curve: Curves.linear,
    );
  }

  void _selectPreviousHistoryNode({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ScrollController historyScrollController,
  }) {
    if (gameInProgress.value) return;
    if (historySelectedNodeIndex.value == null) return;
    /*
    We test against value 2 because
    value 0 is for the first move number
    and value 1 is for the first move san
    */
    if (historySelectedNodeIndex.value! < 2) {
      // selecting first game position
      final startPosition = ref.read(gameSessionProvider).startPosition;
      historySelectedNodeIndex.value = null;
      lastMoveToHighlight.value = null;
      final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
      gameLogicNotifier.changeWith(chess.Chess.fromFEN(startPosition));
      historyScrollController.animateTo(
        0,
        duration: const Duration(
          milliseconds: 50,
        ),
        curve: Curves.linear,
      );
      return;
    }
    final previousNodeData = historyNodesDescriptions.value
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .takeWhile((element) => element.$1 != historySelectedNodeIndex.value)
        .lastOrNull;
    if (previousNodeData == null) return;

    final moveData = previousNodeData.$2.move!;

    historySelectedNodeIndex.value = previousNodeData.$1;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(previousNodeData.$2.fen!));
    lastMoveToHighlight.value = BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    );
    _updateHistoryScrollPosition(
      context: context,
      gameInProgress: gameInProgress,
      historyNodesDescriptions: historyNodesDescriptions,
      historyScrollController: historyScrollController,
      historySelectedNodeIndex: historySelectedNodeIndex,
    );
  }

  void _selectNextHistoryNode({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    if (gameInProgress.value) return;
    if (historySelectedNodeIndex.value == null) {
      // Move number and first move san, at least
      if (historyNodesDescriptions.value.length >= 2) {
        // First move san
        historySelectedNodeIndex.value = 1;
      }
      return;
    }
    final nextNodeData = historyNodesDescriptions.value
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .skipWhile((element) => element.$1 != historySelectedNodeIndex.value)
        .skip(1)
        .firstOrNull;
    if (nextNodeData == null) return;

    final moveData = nextNodeData.$2.move!;
    historySelectedNodeIndex.value = nextNodeData.$1;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(nextNodeData.$2.fen!));
    lastMoveToHighlight.value = BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    );
    _updateHistoryScrollPosition(
      context: context,
      gameInProgress: gameInProgress,
      historyNodesDescriptions: historyNodesDescriptions,
      historyScrollController: historyScrollController,
      historySelectedNodeIndex: historySelectedNodeIndex,
    );
  }

  void _selectLastHistoryNode({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    if (gameInProgress.value) return;
    final lastNodeData = historyNodesDescriptions.value
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .lastOrNull;
    if (lastNodeData == null) return;

    final moveData = lastNodeData.$2.move!;
    historySelectedNodeIndex.value = lastNodeData.$1;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(lastNodeData.$2.fen!));
    lastMoveToHighlight.value = BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    );
    _updateHistoryScrollPosition(
      context: context,
      gameInProgress: gameInProgress,
      historyNodesDescriptions: historyNodesDescriptions,
      historyScrollController: historyScrollController,
      historySelectedNodeIndex: historySelectedNodeIndex,
    );
  }

  void _onHistoryMoveRequest({
    required Move historyMove,
    required int? selectedHistoryNodeIndex,
    required WidgetRef ref,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<int?> historySelectedNodeIndexVariable,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
  }) {
    if (gameInProgress.value || selectedHistoryNodeIndex == null) return;
    final historyNode =
        historyNodesDescriptions.value[selectedHistoryNodeIndex];
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    historySelectedNodeIndexVariable.value = selectedHistoryNodeIndex;
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(historyNode.fen!));
    lastMoveToHighlight.value = BoardArrow(
      from: historyNode.move!.from.getUciString(),
      to: historyNode.move!.to.getUciString(),
    );
  }

  void _makeComputerPlay({
    required WidgetRef ref,
    required ValueNotifier<bool> stockfishReady,
    required ValueNotifier<bool> engineThinking,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
  }) {
    if (!stockfishReady.value) return;

    final gameLogic = ref.read(gameLogicProvider);
    final iswhiteTurn = gameLogic.turn == chess.Color.WHITE;
    final isComputerTurn =
        (iswhiteTurn && whitePlayerType.value == PlayerType.computer) ||
            (!iswhiteTurn && blackPlayerType.value == PlayerType.computer);
    if (!isComputerTurn) return;

    engineThinking.value = true;

    stockfishManager.sendCommand("position fen ${gameLogic.fen}");
    stockfishManager.sendCommand("go movetime 1200");
  }

  void _handleExitPage({
    required bool didPop,
    Object? result,
    required BuildContext context,
  }) async {
    if (didPop) return;
    return await showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            title: Text(
              t.game_page.before_exit_title,
            ),
            content: Text(
              t.game_page.before_exit_message,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                child: Text(
                  t.misc.button_ok,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _onPromotionCommited({
    required PieceType pieceType,
    required ShortMove move,
    required ValueNotifier<bool> gameStart,
    required ValueNotifier<bool> gameInProgress,
    required ValueNotifier<BoardArrow?> lastMoveToHighlight,
    required ValueNotifier<List<HistoryNode>> historyNodesDescriptions,
    required ValueNotifier<PlayerType?> whitePlayerType,
    required ValueNotifier<PlayerType?> blackPlayerType,
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<int?> historySelectedNodeIndex,
    required ScrollController historyScrollController,
    required ValueNotifier<bool> stockfishReady,
    required ValueNotifier<bool> engineThinking,
  }) {
    move.promotion = pieceType;
    _onMove(
      move: move,
      ref: ref,
      context: context,
      whitePlayerType: whitePlayerType,
      blackPlayerType: blackPlayerType,
      engineThinking: engineThinking,
      gameInProgress: gameInProgress,
      gameStart: gameStart,
      historyNodesDescriptions: historyNodesDescriptions,
      historyScrollController: historyScrollController,
      historySelectedNodeIndex: historySelectedNodeIndex,
      lastMoveToHighlight: lastMoveToHighlight,
      stockfishReady: stockfishReady,
    );
  }

  void _showGamePageHelpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            content: Text(t.game_page.help_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx2).pop(),
                child: Text(t.misc.button_ok),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blackSideAtBottom = useState(false);
    final whitePlayerType = useState<PlayerType?>(null);
    final blackPlayerType = useState<PlayerType?>(null);
    final gameStart = useState(true);
    final gameInProgress = useState(true);
    final lastMoveToHighlight = useState<BoardArrow?>(null);
    final historyNodesDescriptions = useState(<HistoryNode>[]);
    final historySelectedNodeIndex = useState<int?>(null);
    final engineThinking = useState(false);
    final stockfishReady = useState(false);

    final historyScrollController =
        useScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

    useEffect(() {
      initState(
        context: context,
        ref: ref,
        whitePlayerType: whitePlayerType,
        blackPlayerType: blackPlayerType,
        blackSideAtBottom: blackSideAtBottom,
        engineThinking: engineThinking,
        gameInProgress: gameInProgress,
        gameStart: gameStart,
        historyNodesDescriptions: historyNodesDescriptions,
        historyScrollController: historyScrollController,
        historySelectedNodeIndex: historySelectedNodeIndex,
        lastMoveToHighlight: lastMoveToHighlight,
        stockfishReady: stockfishReady,
      );
      return null;
    }, []);

    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);

    final isPortrait =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
    final gameGoal = ref.read(gameSessionProvider).goal;
    final loadingSpinnerSize = MediaQuery.of(context).size.shortestSide * 0.80;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleExitPage(
        context: context,
        didPop: didPop,
        result: result,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            t.game_page.title,
          ),
          actions: [
            IconButton(
              onPressed: () => _purposeStartNewGame(
                context: context,
                engineThinking: engineThinking,
                gameInProgress: gameInProgress,
                gameStart: gameStart,
                historyNodesDescriptions: historyNodesDescriptions,
                historySelectedNodeIndex: historySelectedNodeIndex,
                lastMoveToHighlight: lastMoveToHighlight,
                ref: ref,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
            IconButton(
              onPressed: () => _toggleBoardOrientation(
                blackSideAtBottom: blackSideAtBottom,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.arrowsUpDown,
              ),
            ),
            IconButton(
              onPressed: () => _onStopRequested(
                context: context,
                ref: ref,
                gameInProgress: gameInProgress,
                historyNodesDescriptions: historyNodesDescriptions,
                historyScrollController: historyScrollController,
                historySelectedNodeIndex: historySelectedNodeIndex,
                lastMoveToHighlight: lastMoveToHighlight,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.hand,
              ),
            ),
            IconButton(
              onPressed: () => _showGamePageHelpDialog(context),
              icon: const Icon(
                Icons.question_mark_rounded,
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: isPortrait
                  ? PortraitWidget(
                      gameInProgress: gameInProgress.value,
                      positionFen: gameLogicNotifier.fen,
                      isWhiteTurn: gameLogicNotifier.turn == chess.Color.WHITE,
                      blackSideAtBottom: blackSideAtBottom.value,
                      whitePlayerType:
                          whitePlayerType.value ?? PlayerType.computer,
                      blackPlayerType:
                          blackPlayerType.value ?? PlayerType.computer,
                      lastMoveToHighlight: lastMoveToHighlight.value,
                      onPromote: () => _onPromote(
                        context: context,
                        ref: ref,
                      ),
                      onMove: ({required ShortMove move}) => _onMove(
                        gameStart: gameStart,
                        gameInProgress: gameInProgress,
                        ref: ref,
                        move: move,
                        whitePlayerType: whitePlayerType,
                        blackPlayerType: blackPlayerType,
                        historyNodesDescriptions: historyNodesDescriptions,
                        lastMoveToHighlight: lastMoveToHighlight,
                        context: context,
                        engineThinking: engineThinking,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        stockfishReady: stockfishReady,
                      ),
                      onPromotionCommited: ({
                        required ShortMove moveDone,
                        required PieceType pieceType,
                      }) =>
                          _onPromotionCommited(
                        ref: ref,
                        whitePlayerType: whitePlayerType,
                        blackPlayerType: blackPlayerType,
                        context: context,
                        engineThinking: engineThinking,
                        gameInProgress: gameInProgress,
                        gameStart: gameStart,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                        move: moveDone,
                        pieceType: pieceType,
                        stockfishReady: stockfishReady,
                      ),
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: historySelectedNodeIndex.value,
                      historyNodesDescriptions: historyNodesDescriptions.value,
                      historyScrollController: historyScrollController,
                      requestGotoFirst: () => _selectFirstGamePosition(
                        ref: ref,
                        gameInProgress: gameInProgress,
                        lastMoveToHighlight: lastMoveToHighlight,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                      ),
                      requestGotoPrevious: () => _selectPreviousHistoryNode(
                        context: context,
                        gameInProgress: gameInProgress,
                        ref: ref,
                        lastMoveToHighlight: lastMoveToHighlight,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                      ),
                      requestGotoNext: () => _selectNextHistoryNode(
                        ref: ref,
                        context: context,
                        gameInProgress: gameInProgress,
                        lastMoveToHighlight: lastMoveToHighlight,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                      ),
                      requestGotoLast: () => _selectLastHistoryNode(
                        ref: ref,
                        context: context,
                        historyScrollController: historyScrollController,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        gameInProgress: gameInProgress,
                        lastMoveToHighlight: lastMoveToHighlight,
                      ),
                      requestHistoryMove: (
                              {required Move historyMove,
                              required int? selectedHistoryNodeIndex}) =>
                          _onHistoryMoveRequest(
                              ref: ref,
                              gameInProgress: gameInProgress,
                              historyMove: historyMove,
                              historyNodesDescriptions:
                                  historyNodesDescriptions,
                              historySelectedNodeIndexVariable:
                                  historySelectedNodeIndex,
                              lastMoveToHighlight: lastMoveToHighlight,
                              selectedHistoryNodeIndex:
                                  selectedHistoryNodeIndex),
                      engineThinking: engineThinking.value,
                    )
                  : LandscapeWidget(
                      gameInProgress: gameInProgress.value,
                      positionFen: gameLogicNotifier.fen,
                      isWhiteTurn: gameLogicNotifier.turn == chess.Color.WHITE,
                      blackSideAtBottom: blackSideAtBottom.value,
                      whitePlayerType:
                          whitePlayerType.value ?? PlayerType.computer,
                      blackPlayerType:
                          blackPlayerType.value ?? PlayerType.computer,
                      lastMoveToHighlight: lastMoveToHighlight.value,
                      onPromote: () => _onPromote(
                        ref: ref,
                        context: context,
                      ),
                      onMove: ({required ShortMove move}) => _onMove(
                        ref: ref,
                        move: move,
                        whitePlayerType: whitePlayerType,
                        blackPlayerType: blackPlayerType,
                        gameInProgress: gameInProgress,
                        gameStart: gameStart,
                        historyNodesDescriptions: historyNodesDescriptions,
                        lastMoveToHighlight: lastMoveToHighlight,
                        context: context,
                        engineThinking: engineThinking,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        stockfishReady: stockfishReady,
                      ),
                      onPromotionCommited: (
                              {required ShortMove moveDone,
                              required PieceType pieceType}) =>
                          _onPromotionCommited(
                        ref: ref,
                        move: moveDone,
                        pieceType: pieceType,
                        whitePlayerType: whitePlayerType,
                        blackPlayerType: blackPlayerType,
                        context: context,
                        engineThinking: engineThinking,
                        gameInProgress: gameInProgress,
                        gameStart: gameStart,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                        stockfishReady: stockfishReady,
                      ),
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: historySelectedNodeIndex.value,
                      historyNodesDescriptions: historyNodesDescriptions.value,
                      historyScrollController: historyScrollController,
                      requestGotoFirst: () => _selectFirstGamePosition(
                        gameInProgress: gameInProgress,
                        ref: ref,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                      ),
                      requestGotoPrevious: () => _selectPreviousHistoryNode(
                        context: context,
                        gameInProgress: gameInProgress,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                        ref: ref,
                      ),
                      requestGotoNext: () => _selectNextHistoryNode(
                        context: context,
                        ref: ref,
                        gameInProgress: gameInProgress,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                      ),
                      requestGotoLast: () => _selectLastHistoryNode(
                        context: context,
                        ref: ref,
                        gameInProgress: gameInProgress,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historyScrollController: historyScrollController,
                        historySelectedNodeIndex: historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                      ),
                      requestHistoryMove: (
                              {required Move historyMove,
                              required int? selectedHistoryNodeIndex}) =>
                          _onHistoryMoveRequest(
                        ref: ref,
                        gameInProgress: gameInProgress,
                        historyMove: historyMove,
                        historyNodesDescriptions: historyNodesDescriptions,
                        historySelectedNodeIndexVariable:
                            historySelectedNodeIndex,
                        lastMoveToHighlight: lastMoveToHighlight,
                        selectedHistoryNodeIndex: selectedHistoryNodeIndex,
                      ),
                      engineThinking: engineThinking.value,
                    ),
            ),
            if (!stockfishReady.value)
              Center(
                child: SizedBox(
                  width: loadingSpinnerSize,
                  height: loadingSpinnerSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
