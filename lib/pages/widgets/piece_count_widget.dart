import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class PieceCountWidget extends HookWidget {
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
    final count = useState(initialCount);
    final maxCount = _maxCountForPieceKind(kind);
    return Row(
      mainAxisAlignment:
          readOnly ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PieceKindWidget(kind: kind),
        if (!readOnly)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Slider(
              value: count.value.toDouble(),
              divisions: maxCount,
              min: 1,
              max: maxCount.toDouble(),
              label: "${count.value}",
              onChanged: (newValue) => count.value = newValue.round(),
              onChangeEnd: (newValue) => onChanged(newValue.round()),
            ),
          ),
        if (readOnly)
          const Padding(
            padding: EdgeInsets.only(left: 2.0),
            child: Text('x'),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            count.value.toString(),
            style: const TextStyle(
              fontSize: countTextSize,
            ),
          ),
        ),
        if (!readOnly)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 2),
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                color: Colors.red,
                size: chessImagesSize,
              ),
              onPressed: () => onRemove(kind),
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
