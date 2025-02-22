import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';

class RandomTestingPage extends StatelessWidget {
  final List<String> generatedPositions;
  const RandomTestingPage({super.key, required this.generatedPositions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.random_testing.title),
      ),
      body: ListView.builder(
        itemCount: generatedPositions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: SizedBox(
              width: 200,
              height: 200,
              child: SimpleChessBoard(
                fen: generatedPositions[index],
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
              ),
            ),
          );
        },
      ),
    );
  }
}
