import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/syntax_manual.dart';
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
  final TextEditingController _playerKingConstraintsScriptController =
      TextEditingController(text: "");
  final TextEditingController _computerKingConstraintsScriptController =
      TextEditingController(text: "");
  final TextEditingController _kingsMutualConstraintsScriptController =
      TextEditingController(text: "");
  final Map<PieceKind, TextEditingController>
      _otherPiecesGlobalConstraintsScripts =
      <PieceKind, TextEditingController>{};
  final Map<PieceKind, TextEditingController>
      _otherPiecesMutualConstraintsScripts =
      <PieceKind, TextEditingController>{};
  final Map<PieceKind, TextEditingController>
      _otherPiecesIndexedConstraintsScripts =
      <PieceKind, TextEditingController>{};
  String _otherPiecesCountConstraintsScript = "";
  String _goalScript = winningString;

  @override
  void dispose() {
    _playerKingConstraintsScriptController.dispose();
    _computerKingConstraintsScriptController.dispose();
    _kingsMutualConstraintsScriptController.dispose();
    for (var controller in _otherPiecesGlobalConstraintsScripts.values) {
      controller.dispose();
    }
    for (var controller in _otherPiecesMutualConstraintsScripts.values) {
      controller.dispose();
    }
    for (var controller in _otherPiecesIndexedConstraintsScripts.values) {
      controller.dispose();
    }
    super.dispose();
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

  Future<bool> _handleExitPage() async {
    return await showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            title: Text(
              t.script_editor_page.before_exit_title,
            ),
            content: Text(
              t.script_editor_page.before_exit_message,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                child: Text(
                  t.misc.button_ok,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final otherPiecesKinds = _getOtherPiecesKindsFromPiecesCountScript(
        _otherPiecesCountConstraintsScript);

    return WillPopScope(
      onWillPop: _handleExitPage,
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              t.script_editor_page.title,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const SyntaxManualPage();
                    }),
                  );
                },
                icon: const FaIcon(
                  FontAwesomeIcons.book,
                ),
              )
            ],
            bottom: const TabBar(tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.chessKing),
              ),
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
              controller: _playerKingConstraintsScriptController,
            ),
            ComputerKingContraintsEditorWidget(
              controller: _computerKingConstraintsScriptController,
            ),
            KingsMutualConstraintEditorWidget(
              controller: _kingsMutualConstraintsScriptController,
            ),
            OtherPiecesCountConstraintsEditorWidget(
              onScriptUpdate: (counts) {
                _updateOtherPiecesCountConstraintsScript(counts);
              },
              onKindAdded: (kind) {
                setState(() {
                  _otherPiecesGlobalConstraintsScripts[kind] =
                      TextEditingController();
                  _otherPiecesMutualConstraintsScripts[kind] =
                      TextEditingController();
                  _otherPiecesIndexedConstraintsScripts[kind] =
                      TextEditingController();
                });
              },
              onKindRemoved: (kind) {
                setState(() {
                  _otherPiecesGlobalConstraintsScripts.remove(kind);
                  _otherPiecesMutualConstraintsScripts.remove(kind);
                  _otherPiecesIndexedConstraintsScripts.remove(kind);
                });
              },
              currentScript: _otherPiecesCountConstraintsScript,
            ),
            OtherPiecesGlobalConstraintEditorWidget(
              availablePiecesKinds: otherPiecesKinds,
              controllers: _otherPiecesGlobalConstraintsScripts,
            ),
            OtherPiecesMutualConstraintEditorWidget(
              availablePiecesKinds: otherPiecesKinds,
              controllers: _otherPiecesMutualConstraintsScripts,
            ),
            OtherPiecesIndexedConstraintEditorWidget(
              availablePiecesKinds: otherPiecesKinds,
              controllers: _otherPiecesIndexedConstraintsScripts,
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
      ),
    );
  }
}

class PlayerKingConstraintsEditorWidget extends StatelessWidget {
  final TextEditingController controller;

  const PlayerKingConstraintsEditorWidget({
    super.key,
    required this.controller,
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
        Flexible(
          child: EditorWidget(
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class ComputerKingContraintsEditorWidget extends StatelessWidget {
  final TextEditingController controller;

  const ComputerKingContraintsEditorWidget({
    super.key,
    required this.controller,
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
        Flexible(
          child: EditorWidget(
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class KingsMutualConstraintEditorWidget extends StatelessWidget {
  final TextEditingController controller;

  const KingsMutualConstraintEditorWidget({
    super.key,
    required this.controller,
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
        Flexible(
          child: EditorWidget(
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesCountConstraintsEditorWidget extends StatefulWidget {
  final String currentScript;
  final void Function(Map<PieceKind, int> counts) onScriptUpdate;
  final void Function(PieceKind kind) onKindAdded;
  final void Function(PieceKind kind) onKindRemoved;

  const OtherPiecesCountConstraintsEditorWidget({
    super.key,
    required this.onScriptUpdate,
    required this.onKindAdded,
    required this.onKindRemoved,
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
    // Here the order of following lines is important !
    widget.onKindAdded(_selectedType!);
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
              });
              _updateAvailableTypes();
              widget.onScriptUpdate(_content);
              widget.onKindRemoved(_selectedType!);
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
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;

  const OtherPiecesGlobalConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
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
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesMutualConstraintEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;

  const OtherPiecesMutualConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
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
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesIndexedConstraintEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;

  const OtherPiecesIndexedConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
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
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
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
