import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:flutter/material.dart';

class ComplexEditorWidget extends StatefulWidget {
  final String currentScript;
  final List<PieceKind> availablePiecesKinds;

  const ComplexEditorWidget({
    super.key,
    required this.currentScript,
    required this.availablePiecesKinds,
  });

  @override
  State<ComplexEditorWidget> createState() => _ComplexEditorWidgetState();
}

class _ComplexEditorWidgetState extends State<ComplexEditorWidget> {
  PieceKind? _selectedType;
  final Map<PieceKind, TextEditingController> _scriptsControllersByKinds =
      <PieceKind, TextEditingController>{};

  @override
  void initState() {
    _setControllers();
    _loadScriptsWith(widget.currentScript);
    super.initState();
  }

  void _setControllers() {
    for (var kind in _scriptsControllersByKinds.keys) {
      _scriptsControllersByKinds[kind] = TextEditingController();
    }
  }

  void _loadScriptsWith(String currentScript) {}

  void _replaceScriptWithScriptForKind(PieceKind kind) {}

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
            _replaceScriptWithScriptForKind(newValue);
          },
        ),
        EditorWidget(
          enabled: _selectedType != null,
          controller: _selectedType == null
              ? TextEditingController()
              : _scriptsControllersByKinds[_selectedType!]!,
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

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
