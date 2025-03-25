import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/data/stockfish_manager.dart';
import 'package:basicchessendgamestrainer/logic/utils.dart';
import 'package:basicchessendgamestrainer/option.dart';
import 'package:basicchessendgamestrainer/pages/widgets/common_drawer.dart';
import 'package:basicchessendgamestrainer/providers/game_logic_provider.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_landscape.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_portrait.dart';
import 'package:basicchessendgamestrainer/providers/game_page_data_provider.dart';
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
import 'package:basicchessendgamestrainer/providers/game_session_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const piecesSize = 60.0;

class GamePage extends HookConsumerWidget {
  const GamePage({super.key});

  void initState({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) async {
    stockfishManager.geOutputStream().listen((line) {
      if (!context.mounted) return;
      _processStockfishLine(
        line: line,
        ref: ref,
        context: context,
        historyScrollController: historyScrollController,
      );
    });
    stockfishManager.sendCommand('isready');
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final gameStartAsWhite = startPosition.split(" ")[1] == "w";
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    await Future.delayed(const Duration(milliseconds: 50));
    if (gameStartAsWhite) {
      gamePageDataNotifier.setWhitePlayerType(Some(PlayerType.human));
      gamePageDataNotifier.setBlackPlayerType(Some(PlayerType.computer));
      gamePageDataNotifier.setBlackSideAtBottom(false);
    } else {
      gamePageDataNotifier.setWhitePlayerType(Some(PlayerType.computer));
      gamePageDataNotifier.setBlackPlayerType(Some(PlayerType.human));
      gamePageDataNotifier.setBlackSideAtBottom(true);
    }
    _doStartNewGame(
      ref: ref,
    );
  }

  void _updateHistoryScrollPosition({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gamePageData = ref.read(gamePageDataProvider);
    if (gamePageData.gameInProgress) {
      historyScrollController.animateTo(
        historyScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    } else {
      if (gamePageData.historySelectedNodeIndex.isSome) {
        final availableScrollExtent =
            historyScrollController.position.maxScrollExtent;
        final windowWidth = MediaQuery.of(context).size.width;
        final elementsCount = gamePageData.historyNodesDescriptions.length;
        final isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final averageNodeSize = isPortrait
            ? MediaQuery.of(context).size.width * 0.11
            : MediaQuery.of(context).size.height * 0.20;
        final averageItemsPerScreen = windowWidth / averageNodeSize * 0.625;
        var realIndex = (gamePageData.historySelectedNodeIndex.get()! -
                averageItemsPerScreen)
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
  }) {
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final newGameLogic = chess.Chess.fromFEN(startPosition);
    final isWhiteTurn = ref.read(gameSessionProvider).playerHasWhite;
    final moveNumberCaption =
        "${newGameLogic.fen.split(' ')[5]}.${isWhiteTurn ? '' : '..'}";
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier.changeWith(newGameLogic);
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    gamePageDataNotifier.setGameStart(true);
    gamePageDataNotifier.clearLastMoveToHighlight();
    gamePageDataNotifier.clearHistory();
    gamePageDataNotifier
        .addNodeToHistory(HistoryNode(caption: moveNumberCaption));
    gamePageDataNotifier.clearSelectedHistoryIndex();
    gamePageDataNotifier.setGameInProgress(true);
    gamePageDataNotifier.setEngineThinking(false);
  }

  void _processStockfishLine({
    required String line,
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    if (!context.mounted) return;
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final trimedLine = line.trim().toLowerCase();
    if (trimedLine == 'readyok') {
      gamePageDataNotifier.setStockfishReady(true);
    } else if (trimedLine.startsWith("bestmove")) {
      _processBestMove(
        moveUci: trimedLine.split(" ")[1],
        ref: ref,
        context: context,
        historyScrollController: historyScrollController,
      );
    }
  }

  void _processBestMove({
    required String moveUci,
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    if (!context.mounted) return;
    final startSquareStr = moveUci.substring(0, 2);
    final endSquareStr = moveUci.substring(2, 4);
    final promotionStr = moveUci.length >= 5 ? moveUci.substring(5, 6) : null;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final gameLogicClone = chess.Chess.fromFEN(gameLogicNotifier.fen);
    final moveHasBeenMade = gameLogicClone.move({
      'from': startSquareStr,
      'to': endSquareStr,
      'promotion': promotionStr,
    });
    gamePageDataNotifier.setEngineThinking(false);
    if (moveHasBeenMade) {
      final whiteMove = gameLogicClone.turn == chess.Color.WHITE;
      final lastPlayedMove = gameLogicClone.history.last.move;

      /*
      We need to know if it was white move before the move which
      we want to add history node(s).
      */
      if (!whiteMove && gamePageDataNotifier.gameStart != true) {
        final moveNumberCaption = "${gameLogicClone.fen.split(' ')[5]}.";
        gamePageDataNotifier
            .addNodeToHistory(HistoryNode(caption: moveNumberCaption));
        _updateHistoryScrollPosition(
          context: context,
          ref: ref,
          historyScrollController: historyScrollController,
        );
      }

      // In order to get move SAN, it must not be done on board yet !
      final san = gameLogicNotifier.moveToSan(lastPlayedMove);
      gameLogicNotifier.changeWith(gameLogicClone);

      final fan = san.toFan(whiteMove: !whiteMove);

      gamePageDataNotifier.addNodeToHistory(
        HistoryNode(
          caption: fan,
          fen: gameLogicNotifier.fen,
          move: Move(
            from: Cell.fromString(startSquareStr),
            to: Cell.fromString(endSquareStr),
          ),
        ),
      );
      gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
        from: startSquareStr,
        to: endSquareStr,
      )));
      gamePageDataNotifier.setGameStart(false);

      Future.delayed(const Duration(milliseconds: 50), () {
        if (!context.mounted) return;
        _updateHistoryScrollPosition(
          context: context,
          ref: ref,
          historyScrollController: historyScrollController,
        );
      });

      _handleGameEndedIfNeeded(
        context: context,
        ref: ref,
        historyScrollController: historyScrollController,
      );
      if (gamePageDataNotifier.gameInProgress == true) {
        _makeComputerPlay(
          ref: ref,
        );
      }
    }
  }

  void _purposeStartNewGame({
    required BuildContext context,
    required WidgetRef ref,
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
    required WidgetRef ref,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final oldOrientation = gamePageDataNotifier.blackSideAtBottom;
    gamePageDataNotifier.setBlackSideAtBottom(!oldOrientation);
  }

  void _onStopRequested({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gamePageData = ref.read(gamePageDataProvider);
    final noGameRunning = gamePageData.gameInProgress == false;
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
              historyScrollController: historyScrollController,
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
    required ScrollController historyScrollController,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final snackBar = SnackBar(
      content: Text(t.game_page.game_stopped),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    gamePageDataNotifier.setGameInProgress(false);
    _selectLastHistoryNode(
      context: context,
      ref: ref,
      historyScrollController: historyScrollController,
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
    required BuildContext context,
    required ScrollController historyScrollController,
  }) {
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final iswhiteTurn = gameLogicNotifier.turn == chess.Color.WHITE;
    final isPlayerTurn = (iswhiteTurn &&
            gamePageDataNotifier.whitePlayerType.get() == PlayerType.human) ||
        (!iswhiteTurn &&
            gamePageDataNotifier.blackPlayerType.get() == PlayerType.human);
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
      if (!whiteMove && gamePageDataNotifier.gameStart != true) {
        final moveNumberCaption = "${gameLogicClone.fen.split(' ')[5]}.";
        gamePageDataNotifier
            .addNodeToHistory(HistoryNode(caption: moveNumberCaption));
        _updateHistoryScrollPosition(
          context: context,
          ref: ref,
          historyScrollController: historyScrollController,
        );
      }

      // In order to get move SAN, it must not be done on board yet !
      final san = gameLogicNotifier.moveToSan(lastPlayedMove);
      gameLogicNotifier.changeWith(gameLogicClone);

      final fan = san.toFan(whiteMove: !whiteMove);

      gamePageDataNotifier.addNodeToHistory(
        HistoryNode(
          caption: fan,
          fen: gameLogicNotifier.fen,
          move: Move(
            from: Cell.fromString(move.from),
            to: Cell.fromString(move.to),
          ),
        ),
      );
      gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
        from: move.from,
        to: move.to,
      )));
      gamePageDataNotifier.setGameStart(false);

      _updateHistoryScrollPosition(
        context: context,
        ref: ref,
        historyScrollController: historyScrollController,
      );

      _handleGameEndedIfNeeded(
        context: context,
        ref: ref,
        historyScrollController: historyScrollController,
      );
      if (gamePageDataNotifier.gameInProgress == true) {
        _makeComputerPlay(
          ref: ref,
        );
      }
    }
  }

  void _handleGameEndedIfNeeded({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
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
      gamePageDataNotifier.setGameInProgress(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackMessage),
        ),
      );
      _selectLastHistoryNode(
        context: context,
        ref: ref,
        historyScrollController: historyScrollController,
      );
    }
  }

  void _selectFirstGamePosition({
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    if (gamePageDataNotifier.gameInProgress == true) return;
    final startPosition = ref.read(gameSessionProvider).startPosition;
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gamePageDataNotifier.clearSelectedHistoryIndex();
    gamePageDataNotifier.clearLastMoveToHighlight();
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
    required ScrollController historyScrollController,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    if (gamePageDataNotifier.gameInProgress == true) return;
    if (gamePageDataNotifier.historySelectedNodeIndex.isNone) return;
    /*
    We test against value 2 because
    value 0 is for the first move number
    and value 1 is for the first move san
    */
    if (gamePageDataNotifier.historySelectedNodeIndex.isSome &&
        gamePageDataNotifier.historySelectedNodeIndex.orElse(() => -1) < 2) {
      // selecting first game position
      final startPosition = ref.read(gameSessionProvider).startPosition;
      gamePageDataNotifier.clearSelectedHistoryIndex();
      gamePageDataNotifier.clearLastMoveToHighlight();
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
    final previousNodeData = gamePageDataNotifier.historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry))
        .where((element) => element.$2.value.fen != null)
        .takeWhile((element) =>
            element.$1 != gamePageDataNotifier.historySelectedNodeIndex.get())
        .lastOrNull;
    if (previousNodeData == null) return;

    final moveData = previousNodeData.$2.value.move!;

    gamePageDataNotifier.setHistorySelectedNodeIndex(Some(previousNodeData.$1));
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier
        .changeWith(chess.Chess.fromFEN(previousNodeData.$2.value.fen!));
    gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    )));
    _updateHistoryScrollPosition(
      context: context,
      ref: ref,
      historyScrollController: historyScrollController,
    );
  }

  void _selectNextHistoryNode({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    if (gamePageDataNotifier.gameInProgress == true) return;
    if (gamePageDataNotifier.historySelectedNodeIndex.isNone) {
      // Move number and first move san, at least
      if (gamePageDataNotifier.historyNodesDescriptions.length >= 2) {
        // First move san
        final nextNode = gamePageDataNotifier.historyNodesDescriptions[1];
        gamePageDataNotifier.setHistorySelectedNodeIndex(Some(1));
        gameLogicNotifier.changeWith(chess.Chess.fromFEN(nextNode.fen!));
        final moveData = nextNode.move!;
        gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
          from: moveData.from.getUciString(),
          to: moveData.to.getUciString(),
        )));
        _updateHistoryScrollPosition(
          context: context,
          ref: ref,
          historyScrollController: historyScrollController,
        );
      }
      return;
    }
    final nextNodeData = gamePageDataNotifier.historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry))
        .where((element) => element.$2.value.fen != null)
        .skipWhile((element) =>
            element.$1 != gamePageDataNotifier.historySelectedNodeIndex.get())
        .skip(1)
        .firstOrNull;
    if (nextNodeData == null) return;

    final moveData = nextNodeData.$2.value.move!;
    gamePageDataNotifier.setHistorySelectedNodeIndex(Some(nextNodeData.$1));
    gameLogicNotifier
        .changeWith(chess.Chess.fromFEN(nextNodeData.$2.value.fen!));
    gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    )));
    _updateHistoryScrollPosition(
      context: context,
      ref: ref,
      historyScrollController: historyScrollController,
    );
  }

  void _selectLastHistoryNode({
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    if (gamePageDataNotifier.gameInProgress == true) return;
    final lastNodeData = gamePageDataNotifier.historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry))
        .where((element) => element.$2.value.fen != null)
        .lastOrNull;
    if (lastNodeData == null) return;

    final moveData = lastNodeData.$2.value.move!;
    gamePageDataNotifier.setHistorySelectedNodeIndex(Some(lastNodeData.$1));
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gameLogicNotifier
        .changeWith(chess.Chess.fromFEN(lastNodeData.$2.value.fen!));
    gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
      from: moveData.from.getUciString(),
      to: moveData.to.getUciString(),
    )));
    _updateHistoryScrollPosition(
      context: context,
      ref: ref,
      historyScrollController: historyScrollController,
    );
  }

  void _onHistoryMoveRequest({
    required Move historyMove,
    required int? selectedHistoryNodeIndex,
    required WidgetRef ref,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    if (gamePageDataNotifier.gameInProgress == true ||
        selectedHistoryNodeIndex == null) {
      return;
    }
    final historyNode =
        gamePageDataNotifier.historyNodesDescriptions[selectedHistoryNodeIndex];
    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);
    gamePageDataNotifier
        .setHistorySelectedNodeIndex(Some(selectedHistoryNodeIndex));
    gameLogicNotifier.changeWith(chess.Chess.fromFEN(historyNode.fen!));
    gamePageDataNotifier.setLastMoveToHighlight(Some(BoardArrow(
      from: historyNode.move!.from.getUciString(),
      to: historyNode.move!.to.getUciString(),
    )));
  }

  void _makeComputerPlay({
    required WidgetRef ref,
  }) {
    final gamePageDataNotifier = ref.read(gamePageDataProvider.notifier);
    if (gamePageDataNotifier.stockfishReady != true) return;

    final gameLogic = ref.read(gameLogicProvider);
    final iswhiteTurn = gameLogic.turn == chess.Color.WHITE;
    final isComputerTurn = (iswhiteTurn &&
            gamePageDataNotifier.whitePlayerType.get() ==
                PlayerType.computer) ||
        (!iswhiteTurn &&
            gamePageDataNotifier.blackPlayerType.get() == PlayerType.computer);
    if (!isComputerTurn) return;

    gamePageDataNotifier.setEngineThinking(true);

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
    required BuildContext context,
    required WidgetRef ref,
    required ScrollController historyScrollController,
  }) {
    move.promotion = pieceType;
    _onMove(
      move: move,
      ref: ref,
      context: context,
      historyScrollController: historyScrollController,
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
    final historyScrollController =
        useScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

    useEffect(() {
      initState(
        context: context,
        ref: ref,
        historyScrollController: historyScrollController,
      );
      return null;
    }, []);

    final gameLogicNotifier = ref.read(gameLogicProvider.notifier);

    final isPortrait =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
    final gameGoal = ref.read(gameSessionProvider).goal;
    final loadingSpinnerSize = MediaQuery.of(context).size.shortestSide * 0.80;

    final gamePageDataWatcher = ref.watch(gamePageDataProvider);
    final whitePlayerType = gamePageDataWatcher.whitePlayerType;
    final blackPlayerType = gamePageDataWatcher.blackPlayerType;
    final engineThinking = gamePageDataWatcher.engineThinking;
    final gameInProgress = gamePageDataWatcher.gameInProgress;
    final historyNodesDescriptions =
        gamePageDataWatcher.historyNodesDescriptions;
    final historySelectedNodeIndex =
        gamePageDataWatcher.historySelectedNodeIndex;
    final lastMoveToHighlight = gamePageDataWatcher.lastMoveToHighlight;
    final blackSideAtBottom = gamePageDataWatcher.blackSideAtBottom;
    final stockfishReady = gamePageDataWatcher.stockfishReady;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleExitPage(
        context: context,
        didPop: didPop,
        result: result,
      ),
      child: Scaffold(
        drawer: CommonDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            t.game_page.title,
          ),
          leading: Builder(builder: (context) {
            return SizedBox(
              width: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(Icons.menu),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () =>
                          _handleExitPage(didPop: false, context: context),
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: [
            IconButton(
              onPressed: () => _purposeStartNewGame(
                context: context,
                ref: ref,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
            IconButton(
              onPressed: () => _toggleBoardOrientation(
                ref: ref,
              ),
              icon: const FaIcon(
                FontAwesomeIcons.arrowsUpDown,
              ),
            ),
            IconButton(
              onPressed: () => _onStopRequested(
                context: context,
                ref: ref,
                historyScrollController: historyScrollController,
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
                      gameInProgress: gameInProgress,
                      positionFen: gameLogicNotifier.fen,
                      isWhiteTurn: gameLogicNotifier.turn == chess.Color.WHITE,
                      blackSideAtBottom: blackSideAtBottom,
                      whitePlayerType:
                          whitePlayerType.orElse(() => PlayerType.computer),
                      blackPlayerType:
                          blackPlayerType.orElse(() => PlayerType.computer),
                      lastMoveToHighlight: lastMoveToHighlight.get(),
                      onPromote: () => _onPromote(
                        context: context,
                        ref: ref,
                      ),
                      onMove: ({required ShortMove move}) => _onMove(
                        ref: ref,
                        move: move,
                        context: context,
                        historyScrollController: historyScrollController,
                      ),
                      onPromotionCommited: ({
                        required ShortMove moveDone,
                        required PieceType pieceType,
                      }) =>
                          _onPromotionCommited(
                        ref: ref,
                        context: context,
                        historyScrollController: historyScrollController,
                        move: moveDone,
                        pieceType: pieceType,
                      ),
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: historySelectedNodeIndex.get(),
                      historyNodesDescriptions: historyNodesDescriptions,
                      historyScrollController: historyScrollController,
                      requestGotoFirst: () => _selectFirstGamePosition(
                        ref: ref,
                        historyScrollController: historyScrollController,
                      ),
                      requestGotoPrevious: () => _selectPreviousHistoryNode(
                        context: context,
                        ref: ref,
                        historyScrollController: historyScrollController,
                      ),
                      requestGotoNext: () => _selectNextHistoryNode(
                        ref: ref,
                        context: context,
                        historyScrollController: historyScrollController,
                      ),
                      requestGotoLast: () => _selectLastHistoryNode(
                        ref: ref,
                        context: context,
                        historyScrollController: historyScrollController,
                      ),
                      requestHistoryMove: (
                              {required Move historyMove,
                              required int? selectedHistoryNodeIndex}) =>
                          _onHistoryMoveRequest(
                              ref: ref,
                              historyMove: historyMove,
                              selectedHistoryNodeIndex:
                                  selectedHistoryNodeIndex),
                      engineThinking: engineThinking,
                    )
                  : LandscapeWidget(
                      gameInProgress: gameInProgress,
                      positionFen: gameLogicNotifier.fen,
                      isWhiteTurn: gameLogicNotifier.turn == chess.Color.WHITE,
                      blackSideAtBottom: blackSideAtBottom,
                      whitePlayerType:
                          whitePlayerType.orElse(() => PlayerType.computer),
                      blackPlayerType:
                          blackPlayerType.orElse(() => PlayerType.computer),
                      lastMoveToHighlight: lastMoveToHighlight.get(),
                      onPromote: () => _onPromote(
                        ref: ref,
                        context: context,
                      ),
                      onMove: ({required ShortMove move}) => _onMove(
                        ref: ref,
                        move: move,
                        context: context,
                        historyScrollController: historyScrollController,
                      ),
                      onPromotionCommited: (
                              {required ShortMove moveDone,
                              required PieceType pieceType}) =>
                          _onPromotionCommited(
                        ref: ref,
                        move: moveDone,
                        pieceType: pieceType,
                        context: context,
                        historyScrollController: historyScrollController,
                      ),
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: historySelectedNodeIndex.get(),
                      historyNodesDescriptions: historyNodesDescriptions,
                      historyScrollController: historyScrollController,
                      requestGotoFirst: () => _selectFirstGamePosition(
                        ref: ref,
                        historyScrollController: historyScrollController,
                      ),
                      requestGotoPrevious: () => _selectPreviousHistoryNode(
                        context: context,
                        historyScrollController: historyScrollController,
                        ref: ref,
                      ),
                      requestGotoNext: () => _selectNextHistoryNode(
                        context: context,
                        ref: ref,
                        historyScrollController: historyScrollController,
                      ),
                      requestGotoLast: () => _selectLastHistoryNode(
                        context: context,
                        ref: ref,
                        historyScrollController: historyScrollController,
                      ),
                      requestHistoryMove: (
                              {required Move historyMove,
                              required int? selectedHistoryNodeIndex}) =>
                          _onHistoryMoveRequest(
                        ref: ref,
                        historyMove: historyMove,
                        selectedHistoryNodeIndex: selectedHistoryNodeIndex,
                      ),
                      engineThinking: engineThinking,
                    ),
            ),
            if (!stockfishReady)
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
