import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PieceKind {
  playerPawn,
  playerKnight,
  playerBishop,
  playerRook,
  playerQueen,
  playerKing,
  computerPawn,
  computerKnight,
  computerBishop,
  computerRook,
  computerQueen,
  computerKing,
}

const chessImagesSize = 30.0;
const countTextSize = 16.0;
const allSelectableTypes = [
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
  final Map<PieceKind, int> initialContent;

  const OtherPiecesCountConstraintsEditorWidget({
    super.key,
    this.initialContent = const <PieceKind, int>{},
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
    _content = widget.initialContent.map((key, value) => MapEntry(key, value));
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
    final assets = pieceKindToAssetPathPair(widget.type);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 2.0),
          child: SvgPicture.asset(
            assets.first,
            fit: BoxFit.cover,
            width: chessImagesSize,
            height: chessImagesSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: SvgPicture.asset(
            assets.second,
            fit: BoxFit.cover,
            width: chessImagesSize,
            height: chessImagesSize,
          ),
        ),
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
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<PieceKind>(
              value: selectedType,
              items: allSelectableTypes.map((elt) {
                final assets = pieceKindToAssetPathPair(elt);
                final pictures = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: SvgPicture.asset(
                        assets.first,
                        fit: BoxFit.cover,
                        width: chessImagesSize,
                        height: chessImagesSize,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: SvgPicture.asset(
                        assets.second,
                        fit: BoxFit.cover,
                        width: chessImagesSize,
                        height: chessImagesSize,
                      ),
                    )
                  ],
                );
                return DropdownMenuItem(
                  value: elt,
                  child: pictures,
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

class StringPair {
  final String first;
  final String second;

  const StringPair({
    required this.first,
    required this.second,
  });
}

StringPair pieceKindToAssetPathPair(PieceKind kind) {
  switch (kind) {
    case PieceKind.playerPawn:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case PieceKind.playerKnight:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case PieceKind.playerBishop:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case PieceKind.playerRook:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case PieceKind.playerQueen:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    case PieceKind.computerPawn:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case PieceKind.computerKnight:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case PieceKind.computerBishop:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case PieceKind.computerRook:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case PieceKind.computerQueen:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    default:
      throw "Invalid piece type $PieceKind";
  }
}
