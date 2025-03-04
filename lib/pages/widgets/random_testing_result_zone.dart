import 'package:basicchessendgamestrainer/providers/random_testing_results_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_chess_board/models/piece_type.dart';
import 'package:simple_chess_board/models/short_move.dart';
import 'package:simple_chess_board/widgets/chessboard.dart';

const lineSpacing = 10.0;
const columnSpacing = 12.0;

class TestingResultZone extends StatelessWidget {
  final RandomTestingResult results;
  const TestingResultZone({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final boardSize =
        MediaQuery.of(context).size.shortestSide * (isLandscape ? 0.25 : 0.40);
    final splitPositions = results.loadedPositions.isEmpty
        ? []
        : isLandscape
            ? splitKeepingThreeColumns(results.loadedPositions)
            : splitKeepingTwoColumns(results.loadedPositions);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: lineSpacing,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: splitPositions.map((positions) {
        return PreviewsLine(
          boardSize: boardSize,
          positions: positions,
        );
      }).toList(),
    );
  }
}

class PreviewsLine extends StatelessWidget {
  final double boardSize;
  final List<String> positions;

  const PreviewsLine({
    super.key,
    required this.boardSize,
    required this.positions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: columnSpacing,
      children: positions.map((fen) {
        final blackAtBottom = fen.split(" ")[1] == 'b';
        return SizedBox(
          width: boardSize,
          height: boardSize,
          child: SimpleChessBoard(
            fen: fen,
            whitePlayerType: PlayerType.computer,
            blackPlayerType: PlayerType.computer,
            onMove: ({required ShortMove move}) {},
            onPromote: () {
              return Future.value(null);
            },
            onPromotionCommited: (
                {required ShortMove moveDone, required PieceType pieceType}) {},
            onTap: ({required String cellCoordinate}) {},
            chessBoardColors: ChessBoardColors(),
            cellHighlights: <String, Color>{},
            blackSideAtBottom: blackAtBottom,
          ),
        );
      }).toList(),
    );
  }
}

// Example : [0,1,2,3] => [[0,1], [2,3]]
// Example : [0,1,2] => [[0,1], [2]]
// Example : [0] => [[0]]
List<List<String>> splitKeepingTwoColumns(List<String> original) {
  List<List<String>> result = [];
  for (int i = 0; i < original.length; i += 2) {
    result.add(original.sublist(i, i + 2 > original.length ? original.length : i + 2));
  }
  return result;
}

// Example : [0,1,2,3] => [[0,1,2], [3]]
// Example : [0,1,2,3,4] => [[0,1,2], [3,4]]
// Example : [0,1] => [[0,1]]
List<List<String>> splitKeepingThreeColumns(List<String> original) {
  List<List<String>> result = [];
  for (int i = 0; i < original.length; i += 3) {
    result.add(original.sublist(i, i + 3 > original.length ? original.length : i + 3));
  }
  return result;
}