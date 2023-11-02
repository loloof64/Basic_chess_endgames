import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const countTextSize = 16.0;
final allSelectableTypes = [
  PieceKind.playerPawn,
  PieceKind.playerKnight,
  PieceKind.playerBishop,
  PieceKind.playerRook,
  PieceKind.playerQueen,
  PieceKind.computerPawn,
  PieceKind.computerKnight,
  PieceKind.computerBishop,
  PieceKind.computerRook,
  PieceKind.computerQueen,
];

class PieceCountWidget extends StatefulWidget {
  final PieceKind type;
  final int initialCount;
  final void Function(int newValue) onChanged;
  final void Function(PieceKind type) onRemove;

  const PieceCountWidget({
    super.key,
    required this.type,
    required this.onChanged,
    required this.onRemove,
    this.initialCount = 0,
  });

  @override
  State<PieceCountWidget> createState() => _PieceCountWidgetState();
}

class _PieceCountWidgetState extends State<PieceCountWidget> {
  late int _count;

  @override
  void initState() {
    _count = widget.initialCount;
    super.initState();
  }

  int _maxCountForPieceKind(PieceKind type) {
    return (type == PieceKind.playerQueen || type == PieceKind.computerQueen)
        ? 9
        : (type == PieceKind.playerPawn || type == PieceKind.computerPawn)
            ? 8
            : 10;
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _maxCountForPieceKind(widget.type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: PieceKingWidget(kind: widget.type)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Slider(
            value: _count.toDouble(),
            divisions: maxCount,
            min: 1,
            max: maxCount.toDouble(),
            label: "$_count",
            onChanged: (newValue) => setState(() {
              _count = newValue.round();
            }),
            onChangeEnd: (newValue) => widget.onChanged(newValue.round()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            _count.toString(),
            style: const TextStyle(
              fontSize: countTextSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 2),
          child: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: Colors.red,
              size: chessImagesSize,
            ),
            onPressed: () => widget.onRemove(widget.type),
          ),
        ),
      ],
    );
  }
}

class PieceCountAdderWidget extends StatelessWidget {
  final PieceKind? selectedType;
  final void Function(PieceKind?) onSelectionChanged;
  final void Function() onValidate;

  const PieceCountAdderWidget({
    super.key,
    required this.selectedType,
    required this.onValidate,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<PieceKind>(
            value: selectedType,
            items: allSelectableTypes.map((elt) {
              return DropdownMenuItem(
                value: elt,
                child: PieceKingWidget(
                  kind: elt,
                ),
              );
            }).toList(),
            onChanged: onSelectionChanged),
        ElevatedButton(
          onPressed: onValidate,
          child: Text(
            t.script_editor_page.add_count,
          ),
        ),
      ],
    );
  }
}