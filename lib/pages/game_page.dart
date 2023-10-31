import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/logic/utils.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_landscape.dart';
import 'package:basicchessendgamestrainer/pages/widgets/game_page_portrait.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:stockfish/stockfish.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const stockfishLoadingDelayMs = 2000;
const piecesSize = 60.0;

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  chess.Chess? _gameLogic;
  bool _blackSideAtBottom = false;
  PlayerType? _whitePlayerType;
  PlayerType? _blackPlayerType;
  bool _gameStart = true;
  bool _gameInProgress = true;
  BoardArrow? _lastMoveToHighlight;
  List<HistoryNode> _historyNodesDescriptions = [];
  final ScrollController _historyScrollController =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  int? _historySelectedNodeIndex;
  bool _engineThinking = false;
  final _stockfish = Stockfish();
  bool _stockfishReady = false;

  @override
  void initState() {
    _stockfish.stdout.listen((line) {
      _processStockfishLine(line);
    });
    Future.delayed(const Duration(milliseconds: stockfishLoadingDelayMs))
        .then((value) {
      _stockfish.stdin = 'isready';
      final startPosition = ref.read(gameProvider).startPosition;
      final gameStartAsWhite = startPosition.split(" ")[1] == "w";
      if (gameStartAsWhite) {
        _whitePlayerType = PlayerType.human;
        _blackPlayerType = PlayerType.computer;
      } else {
        _whitePlayerType = PlayerType.computer;
        _blackPlayerType = PlayerType.human;
      }
      _doStartNewGame();
    });
    super.initState();
  }

  @override
  void dispose() {
    _stockfish.dispose();
    super.dispose();
  }

  void _updateHistoryScrollPosition() {
    setState(() {
      if (_gameInProgress) {
        _historyScrollController.animateTo(
          _historyScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      } else {
        if (_historySelectedNodeIndex != null) {
          final availableScrollExtent =
              _historyScrollController.position.maxScrollExtent;
          final windowWidth = MediaQuery.of(context).size.width;
          final elementsCount = _historyNodesDescriptions.length;
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          final averageNodeSize = isPortrait
              ? MediaQuery.of(context).size.width * 0.11
              : MediaQuery.of(context).size.height * 0.20;
          final averageItemsPerScreen = windowWidth / averageNodeSize * 0.625;
          var realIndex = (_historySelectedNodeIndex! - averageItemsPerScreen)
              .ceil()
              .toInt();
          realIndex = realIndex > 0 ? realIndex : 0;
          final realElementsCount =
              (elementsCount - averageItemsPerScreen).toInt();
          final double averageScroll = realElementsCount > 0
              ? 1.05 * availableScrollExtent / realElementsCount
              : 0;
          final scrollPosition = realIndex * averageScroll;

          _historyScrollController.jumpTo(
            scrollPosition,
          );
        } else {
          _historyScrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 50), curve: Curves.linear);
        }
      }
    });
  }

  void _doStartNewGame() {
    final startPosition = ref.read(gameProvider).startPosition;
    final newGameLogic = chess.Chess.fromFEN(startPosition);
    final isWhiteTurn = ref.read(gameProvider).playerHasWhite;
    final moveNumberCaption =
        "${newGameLogic.fen.split(' ')[5]}.${isWhiteTurn ? '' : '..'}";
    _gameLogic = newGameLogic;
    _gameStart = true;
    _lastMoveToHighlight = null;
    _historyNodesDescriptions = [];
    _historyNodesDescriptions.add(HistoryNode(caption: moveNumberCaption));
    _historySelectedNodeIndex = null;
    _gameInProgress = true;
    _engineThinking = false;
  }

  void _processStockfishLine(String line) {
    final trimedLine = line.trim().toLowerCase();
    if (trimedLine == 'readyok') {
      setState(() {
        _stockfishReady = true;
      });
    } else if (trimedLine.startsWith("bestmove")) {
      _processBestMove(trimedLine.split(" ")[1]);
    }
  }

  void _processBestMove(String moveUci) {
    final startSquareStr = moveUci.substring(0, 2);
    final endSquareStr = moveUci.substring(2, 4);
    final promotionStr = moveUci.length >= 5 ? moveUci.substring(5, 6) : null;
    final moveHasBeenMade = _gameLogic!.move({
      'from': startSquareStr,
      'to': endSquareStr,
      'promotion': promotionStr,
    });
    setState(() {
      _engineThinking = false;
    });
    if (moveHasBeenMade) {
      final whiteMove = _gameLogic!.turn == chess.Color.WHITE;
      final lastPlayedMove = _gameLogic!.history.last.move;

      /*
      We need to know if it was white move before the move which
      we want to add history node(s).
      */
      if (!whiteMove && !_gameStart) {
        final moveNumberCaption = "${_gameLogic!.fen.split(' ')[5]}.";
        setState(() {
          _historyNodesDescriptions
              .add(HistoryNode(caption: moveNumberCaption));
          _updateHistoryScrollPosition();
        });
      }

      // In order to get move SAN, it must not be done on board yet !
      // So we rollback the move, then we'll make it happen again.
      _gameLogic!.undo_move();
      final san = _gameLogic!.move_to_san(lastPlayedMove);
      _gameLogic!.make_move(lastPlayedMove);

      final fan = san.toFan(whiteMove: !whiteMove);

      setState(() {
        _historyNodesDescriptions.add(
          HistoryNode(
            caption: fan,
            fen: _gameLogic!.fen,
            move: Move(
              from: Cell.fromString(startSquareStr),
              to: Cell.fromString(endSquareStr),
            ),
          ),
        );
        _lastMoveToHighlight = BoardArrow(
          from: startSquareStr,
          to: endSquareStr,
        );
        _gameStart = false;
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        _updateHistoryScrollPosition();
      });

      _handleGameEndedIfNeeded();
      if (_gameInProgress) {
        _makeComputerPlay();
      }
    }
  }

  void _purposeStartNewGame() {
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
            setState(() {
              _doStartNewGame();
            });
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

  void _toggleBoardOrientation() {
    setState(() {
      _blackSideAtBottom = !_blackSideAtBottom;
    });
  }

  void _onStopRequested() {
    final noGameRunning = _gameInProgress == false;
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
            _doStopGame();
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

  void _doStopGame() {
    final snackBar = SnackBar(
      content: Text(t.game_page.game_stopped),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      _gameInProgress = false;
    });
    _selectLastHistoryNode();
  }

  Future<PieceType?> _onPromote() {
    if (_gameLogic == null) return Future.value(null);
    final whiteTurn = _gameLogic!.fen.split(' ')[1] == 'w';

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

  void _onMove({required ShortMove move}) {
    if (_gameLogic == null) return;
    final iswhiteTurn = _gameLogic!.turn == chess.Color.WHITE;
    final isPlayerTurn =
        (iswhiteTurn && _whitePlayerType == PlayerType.human) ||
            (!iswhiteTurn && _blackPlayerType == PlayerType.human);
    if (!isPlayerTurn) return;
    final moveHasBeenMade = _gameLogic!.move({
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion?.name,
    });
    if (moveHasBeenMade) {
      final whiteMove = _gameLogic!.turn == chess.Color.WHITE;
      final lastPlayedMove = _gameLogic!.history.last.move;

      /*
      We need to know if it was white move before the move which
      we want to add history node(s).
      */
      if (!whiteMove && !_gameStart) {
        final moveNumberCaption = "${_gameLogic!.fen.split(' ')[5]}.";
        setState(() {
          _historyNodesDescriptions
              .add(HistoryNode(caption: moveNumberCaption));
          _updateHistoryScrollPosition();
        });
      }

      // In order to get move SAN, it must not be done on board yet !
      // So we rollback the move, then we'll make it happen again.
      _gameLogic!.undo_move();
      final san = _gameLogic!.move_to_san(lastPlayedMove);
      _gameLogic!.make_move(lastPlayedMove);

      final fan = san.toFan(whiteMove: !whiteMove);

      setState(() {
        _historyNodesDescriptions.add(
          HistoryNode(
            caption: fan,
            fen: _gameLogic!.fen,
            move: Move(
              from: Cell.fromString(move.from),
              to: Cell.fromString(move.to),
            ),
          ),
        );
        _lastMoveToHighlight = BoardArrow(
          from: move.from,
          to: move.to,
        );
        _gameStart = false;
      });

      _updateHistoryScrollPosition();

      _handleGameEndedIfNeeded();
      if (_gameInProgress) {
        _makeComputerPlay();
      }
    }
  }

  void _handleGameEndedIfNeeded() {
    if (_gameLogic == null) return;
    String? snackMessage;
    if (_gameLogic!.in_checkmate) {
      final whiteTurnBeforeMove = _gameLogic!.turn == chess.Color.BLACK;
      snackMessage = whiteTurnBeforeMove
          ? t.game_page.checkmate_white
          : t.game_page.checkmate_black;
    } else if (_gameLogic!.in_stalemate) {
      snackMessage = t.game_page.stalemate;
    } else if (_gameLogic!.in_threefold_repetition) {
      snackMessage = t.game_page.three_fold_repetition;
    } else if (_gameLogic!.insufficient_material) {
      snackMessage = t.game_page.missing_material;
    } else if (_gameLogic!.in_draw) {
      snackMessage = t.game_page.fifty_moves_rule;
    }

    if (snackMessage != null) {
      setState(() {
        _gameInProgress = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackMessage),
        ),
      );
      _selectLastHistoryNode();
    }
  }

  void _selectFirstGamePosition() {
    if (_gameInProgress) return;
    final startPosition = ref.read(gameProvider).startPosition;
    setState(() {
      _historySelectedNodeIndex = null;
      _lastMoveToHighlight = null;
      _gameLogic = chess.Chess.fromFEN(startPosition);
    });
    _historyScrollController.animateTo(
      0,
      duration: const Duration(
        milliseconds: 50,
      ),
      curve: Curves.linear,
    );
  }

  void _selectPreviousHistoryNode() {
    if (_gameInProgress) return;
    if (_historySelectedNodeIndex == null) return;
    /*
    We test against value 2 because
    value 0 is for the first move number
    and value 1 is for the first move san
    */
    if (_historySelectedNodeIndex! < 2) {
      // selecting first game position
      final startPosition = ref.read(gameProvider).startPosition;
      setState(() {
        _historySelectedNodeIndex = null;
        _lastMoveToHighlight = null;
        _gameLogic = chess.Chess.fromFEN(startPosition);
      });
      _historyScrollController.animateTo(
        0,
        duration: const Duration(
          milliseconds: 50,
        ),
        curve: Curves.linear,
      );
      return;
    }
    final previousNodeData = _historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .takeWhile((element) => element.$1 != _historySelectedNodeIndex)
        .lastOrNull;
    if (previousNodeData == null) return;

    final moveData = previousNodeData.$2.move!;

    setState(() {
      _historySelectedNodeIndex = previousNodeData.$1;
      _gameLogic = chess.Chess.fromFEN(previousNodeData.$2.fen!);
      _lastMoveToHighlight = BoardArrow(
        from: moveData.from.getUciString(),
        to: moveData.to.getUciString(),
      );
    });
    _updateHistoryScrollPosition();
  }

  void _selectNextHistoryNode() {
    if (_gameInProgress) return;
    if (_historySelectedNodeIndex == null) {
      // Move number and first move san, at least
      if (_historyNodesDescriptions.length >= 2) {
        setState(() {
          // First move san
          _historySelectedNodeIndex = 1;
        });
      }
      return;
    }
    final nextNodeData = _historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .skipWhile((element) => element.$1 != _historySelectedNodeIndex)
        .skip(1)
        .firstOrNull;
    if (nextNodeData == null) return;

    final moveData = nextNodeData.$2.move!;
    setState(() {
      _historySelectedNodeIndex = nextNodeData.$1;
      _gameLogic = chess.Chess.fromFEN(nextNodeData.$2.fen!);
      _lastMoveToHighlight = BoardArrow(
        from: moveData.from.getUciString(),
        to: moveData.to.getUciString(),
      );
    });
    _updateHistoryScrollPosition();
  }

  void _selectLastHistoryNode() {
    if (_gameInProgress) return;
    final lastNodeData = _historyNodesDescriptions
        .asMap()
        .entries
        .map((entry) => (entry.key, entry.value))
        .where((element) => element.$2.fen != null)
        .lastOrNull;
    if (lastNodeData == null) return;

    final moveData = lastNodeData.$2.move!;
    setState(() {
      _historySelectedNodeIndex = lastNodeData.$1;
      _gameLogic = chess.Chess.fromFEN(lastNodeData.$2.fen!);
      _lastMoveToHighlight = BoardArrow(
        from: moveData.from.getUciString(),
        to: moveData.to.getUciString(),
      );
    });
    _updateHistoryScrollPosition();
  }

  void _onHistoryMoveRequest(
      {required Move historyMove, required int? selectedHistoryNodeIndex}) {
    if (_gameInProgress || selectedHistoryNodeIndex == null) return;
    final historyNode = _historyNodesDescriptions[selectedHistoryNodeIndex];
    setState(() {
      _historySelectedNodeIndex = selectedHistoryNodeIndex;
      _gameLogic = chess.Chess.fromFEN(historyNode.fen!);
      _lastMoveToHighlight = BoardArrow(
        from: historyNode.move!.from.getUciString(),
        to: historyNode.move!.to.getUciString(),
      );
    });
  }

  void _makeComputerPlay() {
    if (!_stockfishReady) return;
    if (_gameLogic == null) return;

    final iswhiteTurn = _gameLogic!.turn == chess.Color.WHITE;
    final isComputerTurn =
        (iswhiteTurn && _whitePlayerType == PlayerType.computer) ||
            (!iswhiteTurn && _blackPlayerType == PlayerType.computer);
    if (!isComputerTurn) return;

    setState(() {
      _engineThinking = true;
    });

    _stockfish.stdin = "position fen ${_gameLogic!.fen}";
    _stockfish.stdin = "go movetime 1200";
  }

  Future<bool> _handleExitPage() async {
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
                  Navigator.of(context).pop(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
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
                  Navigator.of(context).pop(true);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
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
    required ShortMove moveDone,
    required PieceType pieceType,
  }) {
    moveDone.promotion = pieceType;
    _onMove(move: moveDone);
  }

  void _showGamePageHelpDialog() {
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
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
    final gameGoal = ref.read(gameProvider).goal;
    final loadingSpinnerSize = MediaQuery.of(context).size.shortestSide * 0.80;

    return WillPopScope(
      onWillPop: _handleExitPage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            t.game_page.title,
          ),
          actions: [
            IconButton(
              onPressed: _purposeStartNewGame,
              icon: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
            IconButton(
              onPressed: _toggleBoardOrientation,
              icon: const FaIcon(
                FontAwesomeIcons.arrowsUpDown,
              ),
            ),
            IconButton(
              onPressed: _onStopRequested,
              icon: const FaIcon(
                FontAwesomeIcons.hand,
              ),
            ),
            IconButton(
              onPressed: _showGamePageHelpDialog,
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
                      gameInProgress: _gameInProgress,
                      positionFen: _gameLogic?.fen ?? emptyPosition,
                      isWhiteTurn: _gameLogic?.turn == chess.Color.WHITE,
                      blackSideAtBottom: _blackSideAtBottom,
                      whitePlayerType: _whitePlayerType ?? PlayerType.computer,
                      blackPlayerType: _blackPlayerType ?? PlayerType.computer,
                      lastMoveToHighlight: _lastMoveToHighlight,
                      onPromote: _onPromote,
                      onMove: _onMove,
                      onPromotionCommited: _onPromotionCommited,
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: _historySelectedNodeIndex,
                      historyNodesDescriptions: _historyNodesDescriptions,
                      historyScrollController: _historyScrollController,
                      requestGotoFirst: _selectFirstGamePosition,
                      requestGotoPrevious: _selectPreviousHistoryNode,
                      requestGotoNext: _selectNextHistoryNode,
                      requestGotoLast: _selectLastHistoryNode,
                      requestHistoryMove: _onHistoryMoveRequest,
                      engineThinking: _engineThinking,
                    )
                  : LandscapeWidget(
                      gameInProgress: _gameInProgress,
                      positionFen: _gameLogic?.fen ?? emptyPosition,
                      isWhiteTurn: _gameLogic?.turn == chess.Color.WHITE,
                      blackSideAtBottom: _blackSideAtBottom,
                      whitePlayerType: _whitePlayerType ?? PlayerType.computer,
                      blackPlayerType: _blackPlayerType ?? PlayerType.computer,
                      lastMoveToHighlight: _lastMoveToHighlight,
                      onPromote: _onPromote,
                      onMove: _onMove,
                      onPromotionCommited: _onPromotionCommited,
                      gameGoal: gameGoal,
                      historySelectedNodeIndex: _historySelectedNodeIndex,
                      historyNodesDescriptions: _historyNodesDescriptions,
                      historyScrollController: _historyScrollController,
                      requestGotoFirst: _selectFirstGamePosition,
                      requestGotoPrevious: _selectPreviousHistoryNode,
                      requestGotoNext: _selectNextHistoryNode,
                      requestGotoLast: _selectLastHistoryNode,
                      requestHistoryMove: _onHistoryMoveRequest,
                      engineThinking: _engineThinking,
                    ),
            ),
            if (!_stockfishReady)
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
