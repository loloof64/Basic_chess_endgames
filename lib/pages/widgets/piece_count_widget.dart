import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const countTextSize = 16.0;
final allSelectableTypes = [
  PieceKind.from('player pawn'),
  PieceKind.from('player knight'),
  PieceKind.from('player bishop'),
  PieceKind.from('player rook'),
  PieceKind.from('player queen'),
  PieceKind.from('computer pawn'),
  PieceKind.from('computer knight'),
  PieceKind.from('computer bishop'),
  PieceKind.from('computer rook'),
  PieceKind.from('computer queen'),
];

class PieceCountWidget extends StatefulWidget {
  final PieceKind kind;
  final int initialCount;
  final bool readOnly;
  final void Function(int newValue) onChanged;
  final void Function(PieceKind kind) onRemove;

  const PieceCountWidget({
    super.key,
    required this.kind,
    required this.readOnly,
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
    final typeString = type.toEasyString();
    return (typeString == 'player queen' || typeString == 'computer queen')
        ? 9
        : (typeString == 'player pawn' || typeString == 'computer pawn')
            ? 8
            : 10;
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _maxCountForPieceKind(widget.kind);
    return Row(
      mainAxisAlignment: widget.readOnly
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PieceKindWidget(kind: widget.kind),
        if (!widget.readOnly)
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
        if (widget.readOnly) const Padding(
          padding: EdgeInsets.only(left: 2.0),
          child: Text('x'),
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
        if (!widget.readOnly)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 2),
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                color: Colors.red,
                size: chessImagesSize,
              ),
              onPressed: () => widget.onRemove(widget.kind),
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
                child: PieceKindWidget(
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
