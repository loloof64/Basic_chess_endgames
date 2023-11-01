import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          OtherPiecesCountConstraintsEditorWidget(),
          OtherPiecesGlobalConstraintEditorWidget(
            onChanged: _updateOtherPiecesGlobalConstraintsScript,
          ),
          OtherPiecesMutualConstraintEditorWidget(
            onChanged: _updateOtherPiecesMutualConstraintsScript,
          ),
          OtherPiecesIndexedConstraintEditorWidget(
            onChanged: _updateOtherPiecesIndexedConstraintsScript,
          ),
          GameGoalEditorWidget(),
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

class OtherPiecesCountConstraintsEditorWidget extends StatelessWidget {
  const OtherPiecesCountConstraintsEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_count_constraint,
        ),
        const Placeholder(),
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
        minLines: 30,
        maxLines: 30,
        controller: _controller,
        onChanged: widget.onChanged,
      ),
    );
  }
}
