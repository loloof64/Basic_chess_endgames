import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const chessImagesSize = 30.0;
const countTextSize = 16.0;
const allSelectableTypes = ['Q', 'R', 'N', 'B', 'P', 'q', 'r', 'n', 'b', 'p'];

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

  @override
  Widget build(BuildContext context) {
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
          const OtherPiecesCountConstraintsEditorWidget(),
          OtherPiecesGlobalConstraintEditorWidget(
            onChanged: _updateOtherPiecesGlobalConstraintsScript,
          ),
          OtherPiecesMutualConstraintEditorWidget(
            onChanged: _updateOtherPiecesMutualConstraintsScript,
          ),
          OtherPiecesIndexedConstraintEditorWidget(
            onChanged: _updateOtherPiecesIndexedConstraintsScript,
          ),
          const GameGoalEditorWidget(),
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
  final Map<String, int> initialContent;

  const OtherPiecesCountConstraintsEditorWidget({
    super.key,
    this.initialContent = const <String, int>{},
  });

  @override
  State<OtherPiecesCountConstraintsEditorWidget> createState() =>
      _OtherPiecesCountConstraintsEditorWidgetState();
}

class _OtherPiecesCountConstraintsEditorWidgetState
    extends State<OtherPiecesCountConstraintsEditorWidget> {
  late Map<String, int> _content;
  String? _selectedType;
  List<String> _remainingTypes = [];

  @override
  void initState() {
    _content = widget.initialContent.map((key, value) => MapEntry(key, value));
    _content.removeWhere((key, value) => key.toLowerCase() == 'k');
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
  }

  @override
  Widget build(BuildContext context) {
    final countChildren = <Widget>[
      for (var entry in _content.entries)
        PieceCountWidget(
          type: entry.key,
          initialCount: entry.value,
          onChanged: (newValue) {
            setState(() {
              _content[entry.key] = newValue;
            });
          },
          onRemove: (valueToRemove) {
            setState(() {
              _content.removeWhere((type, count) => type == valueToRemove);
            });
            _updateAvailableTypes();
          },
        )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: countChildren,
        ),
      ],
    );
  }
}

class OtherPiecesGlobalConstraintEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const OtherPiecesGlobalConstraintEditorWidget({
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
          title: t.script_editor_page.other_pieces_global_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class OtherPiecesMutualConstraintEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const OtherPiecesMutualConstraintEditorWidget({
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
          title: t.script_editor_page.other_pieces_mutual_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class OtherPiecesIndexedConstraintEditorWidget extends StatelessWidget {
  final void Function(String) onChanged;

  const OtherPiecesIndexedConstraintEditorWidget({
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
          title: t.script_editor_page.other_pieces_indexed_constraint,
        ),
        Flexible(child: EditorWidget(onChanged: onChanged)),
      ],
    );
  }
}

class GameGoalEditorWidget extends StatelessWidget {
  const GameGoalEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.game_goal,
        ),
        const Placeholder(),
      ],
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

class EditorWidget extends StatefulWidget {
  final String initialContent;
  final void Function(String) onChanged;

  const EditorWidget({
    super.key,
    required this.onChanged,
    this.initialContent = "",
  });

  @override
  State<EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialContent);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
        minLines: 100,
        maxLines: 100,
        controller: _controller,
        onChanged: widget.onChanged,
      ),
    );
  }
}

class PieceCountWidget extends StatefulWidget {
  final String type;
  final int initialCount;
  final void Function(int newValue) onChanged;
  final void Function(String type) onRemove;

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

  int _maxCountForPieceType(String type) {
    return type.toLowerCase() == 'q'
        ? 9
        : type.toLowerCase() == 'p'
            ? 8
            : 10;
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _maxCountForPieceType(widget.type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            pieceTypeToAssetPath(widget.type),
            fit: BoxFit.cover,
            width: chessImagesSize,
            height: chessImagesSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
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
          padding: const EdgeInsets.all(8),
          child: Text(
            _count.toString(),
            style: const TextStyle(
              fontSize: countTextSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
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
  final String? selectedType;
  final void Function(String?) onSelectionChanged;
  final void Function() onValidate;

  const PieceCountAdderWidget({
    super.key,
    required this.selectedType,
    required this.onValidate,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
              value: selectedType,
              items: allSelectableTypes.map((elt) {
                final picture = SvgPicture.asset(
                  pieceTypeToAssetPath(elt),
                  fit: BoxFit.cover,
                  width: chessImagesSize,
                  height: chessImagesSize,
                );
                return DropdownMenuItem(
                  value: elt,
                  child: picture,
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
      ),
    );
  }
}

String pieceTypeToAssetPath(String pieceType) {
  switch (pieceType) {
    case 'Q':
      return 'assets/images/chess/Chess_qlt45.svg';
    case 'R':
      return 'assets/images/chess/Chess_rlt45.svg';
    case 'B':
      return 'assets/images/chess/Chess_blt45.svg';
    case 'N':
      return 'assets/images/chess/Chess_nlt45.svg';
    case 'P':
      return 'assets/images/chess/Chess_plt45.svg';

    case 'q':
      return 'assets/images/chess/Chess_qdt45.svg';
    case 'r':
      return 'assets/images/chess/Chess_rdt45.svg';
    case 'b':
      return 'assets/images/chess/Chess_bdt45.svg';
    case 'n':
      return 'assets/images/chess/Chess_ndt45.svg';
    case 'p':
      return 'assets/images/chess/Chess_pdt45.svg';
    default:
      throw "Invalid piece type $pieceType";
  }
}
