import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';

class ComplexEditorWidget extends StatefulWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> scriptsControllersByKinds;

  const ComplexEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.scriptsControllersByKinds,
  });

  @override
  State<ComplexEditorWidget> createState() => _ComplexEditorWidgetState();
}

class _ComplexEditorWidgetState extends State<ComplexEditorWidget> {
  PieceKind? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<PieceKind>(
          value: _selectedType,
          items: widget.availablePiecesKinds.map((elt) {
            return DropdownMenuItem(
              value: elt,
              child: PieceKingWidget(
                kind: elt,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue == null) return;
            setState(() {
              _selectedType = newValue;
            });
          },
        ),
        Expanded(
          flex: 6,
          child: EditorWidget(
            enabled: _selectedType != null,
            controller: _selectedType == null
                ? TextEditingController()
                : widget.scriptsControllersByKinds[_selectedType!]!,
          ),
        ),
      ],
    );
  }
}

class EditorWidget extends StatelessWidget {
  final String initialContent;
  final TextEditingController controller;
  final bool enabled;

  const EditorWidget({
    super.key,
    required this.controller,
    this.initialContent = "",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
        enabled: enabled,
        minLines: 100,
        maxLines: 100,
        controller: controller,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final void Function()? onSyntaxButtonPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSyntaxButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onSyntaxButtonPressed != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: onSyntaxButtonPressed,
                child: Text(t.script_editor_page.syntax_button_label),
              ),
            ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

Map<PieceKind, int> convertScriptToPiecesCounts(String script) {
  var result = <PieceKind, int>{};
  final trimmedScript = script.trim();
  final scriptLines = trimmedScript.isEmpty ? [] : trimmedScript.split("\n");

  for (var line in scriptLines) {
    final elementsStrings = line.split(" : ");
    final kindString = elementsStrings.first.trim();
    final count = int.parse(elementsStrings.last.trim());
    final kind = PieceKind.values
        .firstWhere((element) => element.stringRepr == kindString);
    result[kind] = count;
  }

  return result;
}

PieceKind kindFromString(String kindString) {
  switch (kindString) {
    case "player pawn":
      return PieceKind.playerPawn;
    case "player knight":
      return PieceKind.playerKnight;
    case "player bishop":
      return PieceKind.playerBishop;
    case "player rook":
      return PieceKind.playerRook;
    case "player queen":
      return PieceKind.playerQueen;
    case "player king":
      return PieceKind.playerKing;
    case "computer pawn":
      return PieceKind.computerPawn;
    case "computer knight":
      return PieceKind.computerKnight;
    case "computer bishop":
      return PieceKind.computerBishop;
    case "computer rook":
      return PieceKind.computerRook;
    case "computer queen":
      return PieceKind.computerQueen;
    case "computer king":
      return PieceKind.computerKing;
    default:
      throw "Invalid kind string '$kindString'";
  }
}
