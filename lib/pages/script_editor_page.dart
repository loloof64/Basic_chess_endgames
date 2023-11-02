import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_count_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_kind_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/script_editor_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const winningString = "win";
const drawingString = "draw";

class ScriptEditorPage extends StatefulWidget {
  const ScriptEditorPage({super.key});

  @override
  State<ScriptEditorPage> createState() => _ScriptEditorPageState();
}

class _ScriptEditorPageState extends State<ScriptEditorPage> {
  String _playerKingConstraintsScript = "";
  String _computerKingConstraintsScript = "";
  String _kingsMutualConstraintsScript = "";
  String _otherPiecesGlobalConstraintsScript = "";
  String _otherPiecesMutualConstraintsScript = "";
  String _otherPiecesIndexedConstraintsScript = "";
  String _otherPiecesCountConstraintsScript = "";
  String _goalScript = winningString;

  void _updatePlayerKingConstraintsScript(String newContent) {
    setState(() {
      _playerKingConstraintsScript = newContent;
    });
  }

  void _updateComputerKingConstraintsScript(String newContent) {
    setState(() {
      _computerKingConstraintsScript = newContent;
    });
  }

  void _updateKingsMutualConstraintsScript(String newContent) {
    setState(() {
      _kingsMutualConstraintsScript = newContent;
    });
  }

  void _updateOtherPiecesGlobalConstraintsScript(String newContent) {
    setState(() {
      _otherPiecesGlobalConstraintsScript = newContent;
    });
  }

  void _updateOtherPiecesMutualConstraintsScript(String newContent) {
    setState(() {
      _otherPiecesMutualConstraintsScript = newContent;
    });
  }

  void _updateOtherPiecesIndexedConstraintsScript(String newContent) {
    setState(() {
      _otherPiecesIndexedConstraintsScript = newContent;
    });
  }

  void _updateOtherPiecesCountConstraintsScript(Map<PieceKind, int> counts) {
    final script = [
      for (var entry in counts.entries)
        "${entry.key.stringRepr} : ${entry.value}"
    ].join("\n");
    setState(() {
      _otherPiecesCountConstraintsScript = script;
    });
  }

  void _updateGoalScript(bool shouldWin) {
    setState(() {
      _goalScript = shouldWin ? winningString : drawingString;
    });
  }

  List<PieceKind> _getOtherPiecesKindsFromPiecesCountScript(String script) {
    return convertScriptToPiecesCounts(script).keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    final otherPiecesKinds = _getOtherPiecesKindsFromPiecesCountScript(_otherPiecesCountConstraintsScript);

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            t.script_editor_page.title,
          ),
          bottom: const TabBar(tabs: [
            Tab(icon: FaIcon(FontAwesomeIcons.chessKing)),
            Tab(icon: FaIcon(FontAwesomeIcons.solidChessKing)),
            Tab(icon: FaIcon(FontAwesomeIcons.arrowsUpDown)),
            Tab(icon: FaIcon(FontAwesomeIcons.calculator)),
            Tab(icon: FaIcon(FontAwesomeIcons.globe)),
            Tab(icon: FaIcon(FontAwesomeIcons.arrowRightArrowLeft)),
            Tab(icon: FaIcon(FontAwesomeIcons.arrowDown19)),
            Tab(icon: FaIcon(FontAwesomeIcons.futbol)),
          ]),
        ),
        body: TabBarView(children: [
          PlayerKingConstraintsEditorWidget(
            onChanged: _updatePlayerKingConstraintsScript,
          ),
          ComputerKingContraintsEditorWidget(
            onChanged: _updateComputerKingConstraintsScript,
          ),
          KingsMutualConstraintEditorWidget(
            onChanged: _updateKingsMutualConstraintsScript,
          ),
          OtherPiecesCountConstraintsEditorWidget(
            onScriptUpdate: (counts) {
              _updateOtherPiecesCountConstraintsScript(counts);
            },
            currentScript: _otherPiecesCountConstraintsScript,
          ),
          OtherPiecesGlobalConstraintEditorWidget(
            onChanged: _updateOtherPiecesGlobalConstraintsScript,
            currentScript: _otherPiecesGlobalConstraintsScript,
            availablePiecesKinds: otherPiecesKinds,
          ),
          OtherPiecesMutualConstraintEditorWidget(
            onChanged: _updateOtherPiecesMutualConstraintsScript,
            currentScript: _otherPiecesMutualConstraintsScript,
            availablePiecesKinds: otherPiecesKinds,
          ),
          OtherPiecesIndexedConstraintEditorWidget(
            onChanged: _updateOtherPiecesIndexedConstraintsScript,
            currentScript: _otherPiecesIndexedConstraintsScript,
            availablePiecesKinds: otherPiecesKinds,
          ),
          GameGoalEditorWidget(
              script: _goalScript,
              onChanged: (newValue) {
                _updateGoalScript(newValue);
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
        ),
      ),
    );
  }
}

class PlayerKingConstraintsEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const PlayerKingConstraintsEditorWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.player_king_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class ComputerKingContraintsEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const ComputerKingContraintsEditorWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.computer_king_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class KingsMutualConstraintEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const KingsMutualConstraintEditorWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.kings_mutual_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class OtherPiecesCountConstraintsEditorWidget extends StatefulWidget {
  final String currentScript;
  final void Function(Map<PieceKind, int> counts) onScriptUpdate;

  const OtherPiecesCountConstraintsEditorWidget({
    super.key,
    required this.onScriptUpdate,
    this.currentScript = "",
  });

  @override
  State<OtherPiecesCountConstraintsEditorWidget> createState() =>
      _OtherPiecesCountConstraintsEditorWidgetState();
}

class _OtherPiecesCountConstraintsEditorWidgetState
    extends State<OtherPiecesCountConstraintsEditorWidget> {
  late Map<PieceKind, int> _content;
  PieceKind? _selectedType;
  List<PieceKind> _remainingTypes = [];

  @override
  void initState() {
    _content = convertScriptToPiecesCounts(widget.currentScript);
    _content.removeWhere((key, value) =>
        key == PieceKind.playerKing || key == PieceKind.computerKing);
    _updateAvailableTypes();
    super.initState();
  }

  void _updateAvailableTypes() {
    final storedTypes = _content.keys;
    final remainingTypes = allSelectableTypes
        .where((element) => !storedTypes.contains(element))
        .toList();
    setState(() {
      _remainingTypes = remainingTypes;
    });
  }

  void _addCurrentCount() {
    if (_selectedType == null) return;
    if (!_remainingTypes.contains(_selectedType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.script_editor_page.type_already_added),
        ),
      );
      return;
    }
    setState(() {
      _content[_selectedType!] = 1;
    });
    _updateAvailableTypes();
    widget.onScriptUpdate(_content);
  }

  @override
  Widget build(BuildContext context) {
    final countChildren = <Widget>[
      for (var entry in _content.entries)
        Padding(
          padding: const EdgeInsets.all(10),
          child: PieceCountWidget(
            type: entry.key,
            initialCount: entry.value,
            onChanged: (newValue) {
              setState(() {
                _content[entry.key] = newValue;
                widget.onScriptUpdate(_content);
              });
            },
            onRemove: (valueToRemove) {
              setState(() {
                _content.removeWhere((type, count) => type == valueToRemove);
                widget.onScriptUpdate(_content);
              });
              _updateAvailableTypes();
            },
          ),
        )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_count_constraint,
        ),
        PieceCountAdderWidget(
          selectedType: _selectedType,
          onSelectionChanged: (newValue) {
            if (newValue == null) return;
            setState(() {
              _selectedType = newValue;
            });
          },
          onValidate: _addCurrentCount,
        ),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: countChildren,
            ),
          ),
        ),
      ],
    );
  }
}

class OtherPiecesGlobalConstraintEditorWidget extends StatelessWidget {
  final String currentScript;
  final List<PieceKind> availablePiecesKinds;
  final void Function(String) onChanged;

  const OtherPiecesGlobalConstraintEditorWidget({
    super.key,
    required this.currentScript,
    required this.availablePiecesKinds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_global_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            currentScript: currentScript,
            availablePiecesKinds: availablePiecesKinds,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesMutualConstraintEditorWidget extends StatelessWidget {
  final String currentScript;
  final List<PieceKind> availablePiecesKinds;
  final void Function(String) onChanged;

  const OtherPiecesMutualConstraintEditorWidget({
    super.key,
    required this.currentScript,
    required this.availablePiecesKinds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_mutual_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            currentScript: currentScript,
            availablePiecesKinds: availablePiecesKinds,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesIndexedConstraintEditorWidget extends StatelessWidget {
  final String currentScript;
  final List<PieceKind> availablePiecesKinds;
  final void Function(String) onChanged;

  const OtherPiecesIndexedConstraintEditorWidget({
    super.key,
    required this.currentScript,
    required this.availablePiecesKinds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_indexed_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            currentScript: currentScript,
            availablePiecesKinds: availablePiecesKinds,
          ),
        ),
      ],
    );
  }
}

class GameGoalEditorWidget extends StatefulWidget {
  final String script;
  final void Function(bool) onChanged;

  const GameGoalEditorWidget({
    super.key,
    required this.script,
    required this.onChanged,
  });

  @override
  State<GameGoalEditorWidget> createState() => _GameGoalEditorWidgetState();
}

class _GameGoalEditorWidgetState extends State<GameGoalEditorWidget> {
  bool _shouldWin = true;

  @override
  void initState() {
    _shouldWin = widget.script.trim() == winningString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.game_goal,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(t.script_editor_page.should_win),
              leading: Radio<bool>(
                groupValue: _shouldWin,
                value: true,
                onChanged: (newValue) {
                  if (newValue == null) return;
                  setState(() {
                    _shouldWin = newValue;
                    widget.onChanged(newValue);
                  });
                },
              ),
            ),
            ListTile(
              title: Text(t.script_editor_page.should_draw),
              leading: Radio<bool>(
                groupValue: _shouldWin,
                value: false,
                onChanged: (newValue) {
                  if (newValue == null) return;
                  setState(() {
                    _shouldWin = newValue;
                    widget.onChanged(newValue);
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
