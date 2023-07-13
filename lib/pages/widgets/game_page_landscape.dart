import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:simple_chess_board/models/board_color.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandscapeWidget extends StatelessWidget {
  final bool gameInProgress;
  final bool engineThinking;
  final String positionFen;
  final BoardColor boardOrientation;
  final PlayerType whitePlayerType;
  final PlayerType blackPlayerType;
  final BoardArrow? lastMoveToHighlight;
  final void Function({required ShortMove move}) onMove;
  final Future<PieceType?> Function() onPromote;

  final Goal gameGoal;

  final int? historySelectedNodeIndex;
  final List<HistoryNode> historyNodesDescriptions;
  final ScrollController historyScrollController;
  final void Function() requestGotoFirst;
  final void Function() requestGotoPrevious;
  final void Function() requestGotoNext;
  final void Function() requestGotoLast;
  final void Function(
      {required Move historyMove,
      required int? selectedHistoryNodeIndex}) requestHistoryMove;

  const LandscapeWidget({
    super.key,
    required this.gameInProgress,
    required this.engineThinking,
    required this.positionFen,
    required this.boardOrientation,
    required this.whitePlayerType,
    required this.blackPlayerType,
    required this.lastMoveToHighlight,
    required this.onPromote,
    required this.onMove,
    required this.gameGoal,
    required this.historySelectedNodeIndex,
    required this.historyNodesDescriptions,
    required this.historyScrollController,
    required this.requestGotoFirst,
    required this.requestGotoPrevious,
    required this.requestGotoNext,
    required this.requestGotoLast,
    required this.requestHistoryMove,
  });

  @override
  Widget build(BuildContext context) {
    final goalText = gameGoal == Goal.win
        ? AppLocalizations.of(context)!.gamePage_goalWin
        : AppLocalizations.of(context)!.gamePage_goalDraw;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: SimpleChessBoard(
            fen: positionFen,
            orientation: boardOrientation,
            whitePlayerType:
                gameInProgress ? whitePlayerType : PlayerType.computer,
            blackPlayerType:
                gameInProgress ? blackPlayerType : PlayerType.computer,
            onMove: onMove,
            onPromote: onPromote,
            lastMoveToHighlight: lastMoveToHighlight,
            engineThinking: engineThinking,
            onPromotionCommited: ({required ShortMove moveDone}) {},
            chessBoardColors: ChessBoardColors(),
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                goalText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                height: 20.0,
              ),
              Expanded(
                child: LayoutBuilder(builder: (ctx2, constraints2) {
                  return ChessHistory(
                    fontSize: constraints2.biggest.height * 0.07,
                    selectedNodeIndex: historySelectedNodeIndex,
                    nodesDescriptions: historyNodesDescriptions,
                    scrollController: historyScrollController,
                    requestGotoFirst: requestGotoFirst,
                    requestGotoPrevious: requestGotoPrevious,
                    requestGotoNext: requestGotoNext,
                    requestGotoLast: requestGotoLast,
                    onHistoryMoveRequested: requestHistoryMove,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
