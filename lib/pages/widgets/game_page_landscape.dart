import 'package:basicchessendgamestrainer/components/history.dart';
import 'package:basicchessendgamestrainer/providers/game_session_provider.dart';
import 'package:basicchessendgamestrainer/pages/widgets/player_turn_widget.dart';
import 'package:flutter/material.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';

const gapSize = 20.0;
const historyFontSizeFraction = 0.09;

class LandscapeWidget extends StatelessWidget {
  final bool gameInProgress;
  final bool engineThinking;
  final bool isWhiteTurn;
  final String positionFen;
  final bool blackSideAtBottom;
  final PlayerType whitePlayerType;
  final PlayerType blackPlayerType;
  final BoardArrow? lastMoveToHighlight;
  final void Function({required ShortMove move}) onMove;
  final Future<PieceType?> Function() onPromote;
  final void Function({
    required ShortMove moveDone,
    required PieceType pieceType,
  }) onPromotionCommited;

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
    required this.isWhiteTurn,
    required this.positionFen,
    required this.blackSideAtBottom,
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
    required this.onPromotionCommited,
  });

  @override
  Widget build(BuildContext context) {
    final goalText =
        gameGoal == Goal.win ? t.game_page.goal_win : t.game_page.goal_draw;
    final screenWidth = MediaQuery.of(context).size.width;
    final goalTextFontSize = screenWidth * 0.035;
    final playerTurnSize = screenWidth * 0.035;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SimpleChessBoard(
          fen: positionFen,
          blackSideAtBottom: blackSideAtBottom,
          whitePlayerType:
              gameInProgress ? whitePlayerType : PlayerType.computer,
          blackPlayerType:
              gameInProgress ? blackPlayerType : PlayerType.computer,
          onMove: onMove,
          onPromote: onPromote,
          lastMoveToHighlight: lastMoveToHighlight,
          engineThinking: engineThinking,
          onPromotionCommited: onPromotionCommited,
          chessBoardColors: ChessBoardColors(),
          cellHighlights: const <String, Color>{},
          onTap: ({required cellCoordinate}) => {},
        ),
        const SizedBox(
          width: gapSize,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    goalText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: goalTextFontSize,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  PlayerTurnWidget(
                    isWhiteTurn: isWhiteTurn,
                    size: playerTurnSize,
                  )
                ],
              ),
              const Divider(
                height: gapSize,
              ),
              Expanded(
                child: LayoutBuilder(builder: (ctx2, constraints2) {
                  return ChessHistory(
                    fontSize:
                        constraints2.biggest.height * historyFontSizeFraction,
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
