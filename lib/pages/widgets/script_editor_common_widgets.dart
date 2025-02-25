import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/components/textfield_with_caret_position.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';

class ComplexEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final ValueNotifier<Map<PieceKind, TextEditingController>>
      scriptsControllersByKinds;
  final bool readOnly;
  final PieceKind? selectedType;
  final FocusNode focusNode;
  final void Function(PieceKind kind) onPieceKindSelection;

  const ComplexEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.scriptsControllersByKinds,
    required this.readOnly,
    required this.selectedType,
    required this.focusNode,
    required this.onPieceKindSelection,
  });

  @override
  Widget build(BuildContext context) {
    final controller = selectedType == null
        ? TextEditingController()
        : scriptsControllersByKinds.value[selectedType!] ??
            TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<PieceKind>(
          value: selectedType,
          items: availablePiecesKinds.map((elt) {
            return DropdownMenuItem(
              value: elt,
              child: PieceKindWidget(
                kind: elt,
              ),
            );
          }).toList(),
          onChanged: (newValue) async {
            if (newValue == null) return;
            onPieceKindSelection(newValue);
            // waiting for the text field to be added to tree
            await Future.delayed(const Duration(milliseconds: 50));
            focusNode.requestFocus();
          },
        ),
        Expanded(
          flex: 6,
          child: EditorWidget(
            key: UniqueKey(),
            readOnly: readOnly,
            focusNode: focusNode,
            enabled: selectedType != null,
            controller: controller,
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
  final bool readOnly;
  final FocusNode focusNode;

  const EditorWidget({
    super.key,
    required this.focusNode,
    required this.readOnly,
    required this.controller,
    this.initialContent = "",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return enabled
        ? SingleChildScrollView(
            child: TextfieldWithPositionTracker(
              readOnly: readOnly,
              focusNode: focusNode,
              controller: controller,
            ),
          )
        : Center(
            child: Text(
              t.script_editor_page.no_content_yet,
            ),
          );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
    final kind = PieceKind.from(kindString);
    result[kind] = count;
  }

  return result;
}
