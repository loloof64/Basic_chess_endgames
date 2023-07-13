import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum File { fileA, fileB, fileC, fileD, fileE, fileF, fileG, fileH }

enum Rank { rank_1, rank_2, rank_3, rank_4, rank_5, rank_6, rank_7, rank_8 }

class Cell extends Equatable {
  final File file;
  final Rank rank;

  const Cell({
    required this.file,
    required this.rank,
  });

  Cell.fromSquareIndex(int squareIndex)
      : this(
            file: File.values[squareIndex % 8],
            rank: Rank.values[squareIndex ~/ 8]);

  factory Cell.from(Cell other) {
    return Cell(file: other.file, rank: other.rank);
  }

  factory Cell.fromString(String squareStr) {
    final file = File.values[squareStr.codeUnitAt(0) - 'a'.codeUnitAt(0)];
    final rank = Rank.values[squareStr.codeUnitAt(1) - '1'.codeUnitAt(0)];

    return Cell(file: file, rank: rank);
  }

  @override
  List<Object?> get props => [file, rank];

  @override
  bool get stringify => true;

  String getUciString() {
    final fileStr = String.fromCharCode('a'.codeUnitAt(0) + file.index);
    final rankStr = String.fromCharCode('1'.codeUnitAt(0) + rank.index);
    return '$fileStr$rankStr';
  }
}

class Move extends Equatable {
  final Cell from;
  final Cell to;

  const Move({
    required this.from,
    required this.to,
  });

  factory Move.from(Move other) =>
      Move(from: Cell.from(other.from), to: Cell.from(other.to));

  @override
  List<Object?> get props => [from, to];
}

class HistoryNode extends Equatable {
  final String caption;
  final String? fen;
  final Move? move;

  const HistoryNode({
    required this.caption,
    this.fen,
    this.move,
  });

  @override
  String toString() => 'HistoryNode(caption: $caption, fen: $fen, move: $move)';

  @override
  List<Object?> get props => [caption, fen, move];
}

class ChessHistory extends StatelessWidget {
  final double fontSize;
  final int? selectedNodeIndex;

  final List<HistoryNode> nodesDescriptions;
  final ScrollController scrollController;

  final void Function() requestGotoFirst;
  final void Function() requestGotoPrevious;
  final void Function() requestGotoNext;
  final void Function() requestGotoLast;
  final void Function({
    required Move historyMove,
    required int? selectedHistoryNodeIndex,
  }) onHistoryMoveRequested;

  const ChessHistory({
    Key? key,
    required this.selectedNodeIndex,
    required this.fontSize,
    required this.nodesDescriptions,
    required this.scrollController,
    required this.requestGotoFirst,
    required this.requestGotoPrevious,
    required this.requestGotoNext,
    required this.requestGotoLast,
    required this.onHistoryMoveRequested,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> nodes = <Widget>[];
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: 'Free Serif',
      color: Theme.of(context).colorScheme.onSecondary,
    );

    nodesDescriptions.asMap().forEach((index, currentNode) {
      if (currentNode.fen != null) {
        final nodeSelected = index == selectedNodeIndex;
        final nodeButton = nodeSelected
            ? ElevatedButton(
                onPressed: () => onHistoryMoveRequested(
                  historyMove: currentNode.move!,
                  selectedHistoryNodeIndex: index,
                ),
                child: Text(
                  currentNode.caption,
                  style: textStyle,
                ),
              )
            : TextButton(
                onPressed: () => onHistoryMoveRequested(
                  historyMove: currentNode.move!,
                  selectedHistoryNodeIndex: index,
                ),
                child: Text(
                  currentNode.caption,
                  style: textStyle,
                ),
              );
        nodes.add(nodeButton);
      } else {
        nodes.add(
          Text(
            currentNode.caption,
            style: textStyle,
          ),
        );
      }
    });

    return LayoutBuilder(builder: (ctx2, constraints) {
      final isLandscapeMode = constraints.maxWidth > constraints.maxHeight;
      final commonHistoryButtonsSize = isLandscapeMode
          ? constraints.maxWidth * 0.12
          : constraints.maxWidth * 0.18;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: HistoryButtonsZone(
              buttonsSize: commonHistoryButtonsSize,
              requestGotoFirst: requestGotoFirst,
              requestGotoPrevious: requestGotoPrevious,
              requestGotoNext: requestGotoNext,
              requestGotoLast: requestGotoLast,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: nodes,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _HistoryNavigationButton extends StatelessWidget {
  final double size;
  final IconData icon;
  final void Function() onClick;

  const _HistoryNavigationButton({
    required this.icon,
    required this.size,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.5;
    final iconBackground = Theme.of(context).primaryColor;
    final iconForeground = Theme.of(context).colorScheme.onPrimary;
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        iconSize: iconSize,
        onPressed: onClick,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: iconBackground,
          foregroundColor: iconForeground,
        ),
        icon: FaIcon(
          icon,
        ),
      ),
    );
  }
}

class HistoryButtonsZone extends StatelessWidget {
  final double buttonsSize;

  final void Function() requestGotoFirst;
  final void Function() requestGotoPrevious;
  final void Function() requestGotoNext;
  final void Function() requestGotoLast;

  const HistoryButtonsZone({
    Key? key,
    required this.buttonsSize,
    required this.requestGotoFirst,
    required this.requestGotoPrevious,
    required this.requestGotoNext,
    required this.requestGotoLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _HistoryNavigationButton(
          size: buttonsSize,
          icon: FontAwesomeIcons.backwardFast,
          onClick: requestGotoFirst,
        ),
        _HistoryNavigationButton(
          size: buttonsSize,
          icon: FontAwesomeIcons.backwardStep,
          onClick: requestGotoPrevious,
        ),
        _HistoryNavigationButton(
          size: buttonsSize,
          icon: FontAwesomeIcons.forwardStep,
          onClick: requestGotoNext,
        ),
        _HistoryNavigationButton(
          size: buttonsSize,
          icon: FontAwesomeIcons.forwardFast,
          onClick: requestGotoLast,
        ),
      ],
    );
  }
}
