import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';

class RandomTestingPage extends HookWidget {
  final List<String> generatedPositions;
  final List<String> rejectedFinalizedPositions;

  const RandomTestingPage({
    super.key,
    required this.generatedPositions,
    required this.rejectedFinalizedPositions,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.random_testing.title),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GeneratedPositionsListWidget(
            generatedPositions: generatedPositions,
          ),
          RejectedPositionsWidget(
            rejectedPositions: rejectedFinalizedPositions,
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: t.random_testing.tab_generated_positions),
          Tab(text: t.random_testing.tab_rejected_positions),
        ],
      ),
    );
  }
}

class GeneratedPositionsListWidget extends StatelessWidget {
  const GeneratedPositionsListWidget({
    super.key,
    required this.generatedPositions,
  });

  final List<String> generatedPositions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: generatedPositions.length,
      itemBuilder: (context, index) {
        final fen = generatedPositions[index];
        final blackAtBottom = fen.split(" ")[1] == 'b';
        return ListTile(
          title: SizedBox(
            width: 200,
            height: 200,
            child: SimpleChessBoard(
              fen: fen,
              whitePlayerType: PlayerType.computer,
              blackPlayerType: PlayerType.computer,
              onMove: ({required ShortMove move}) {},
              onPromote: () {
                return Future.value(null);
              },
              onPromotionCommited: (
                  {required ShortMove moveDone,
                  required PieceType pieceType}) {},
              onTap: ({required String cellCoordinate}) {},
              chessBoardColors: ChessBoardColors(),
              cellHighlights: <String, Color>{},
              blackSideAtBottom: blackAtBottom,
            ),
          ),
        );
      },
    );
  }
}

class RejectedPositionsWidget extends StatelessWidget {
  const RejectedPositionsWidget({
    super.key,
    required this.rejectedPositions,
  });

  final List<String> rejectedPositions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rejectedPositions.length,
      itemBuilder: (context, index) {
        final fen = rejectedPositions[index];
        final blackAtBottom = fen.split(" ")[1] == 'b';
        return ListTile(
          title: SizedBox(
            width: 200,
            height: 200,
            child: SimpleChessBoard(
              fen: fen,
              whitePlayerType: PlayerType.computer,
              blackPlayerType: PlayerType.computer,
              onMove: ({required ShortMove move}) {},
              onPromote: () {
                return Future.value(null);
              },
              onPromotionCommited: (
                  {required ShortMove moveDone,
                  required PieceType pieceType}) {},
              onTap: ({required String cellCoordinate}) {},
              chessBoardColors: ChessBoardColors(),
              cellHighlights: <String, Color>{},
              blackSideAtBottom: blackAtBottom,
            ),
          ),
        );
      },
    );
  }
}
