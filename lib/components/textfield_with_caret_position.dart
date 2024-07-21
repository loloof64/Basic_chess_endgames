import 'package:flutter/material.dart';

class TextfieldWithPositionTracker extends StatefulWidget {
  const TextfieldWithPositionTracker({
    super.key,
    required this.controller,
    this.focusNode,
    required this.readOnly,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  TextfieldWithPositionTrackerState createState() =>
      TextfieldWithPositionTrackerState();
}

class TextfieldWithPositionTrackerState
    extends State<TextfieldWithPositionTracker> {
  String _cursorPosition = '1:1';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCursorPosition);
  }

  void _updateCursorPosition() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.baseOffset == -1) {
      return;
    }

    final beforeCursor = text.substring(0, selection.baseOffset);
    final lines = beforeCursor.split('\n');

    final lineNumber = lines.length;
    final columnNumber = lines.last.length + 1;

    setState(() {
      _cursorPosition = '$lineNumber:$columnNumber';
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCursorPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_cursorPosition),
        const SizedBox(height: 20),
        TextField(
          readOnly: widget.readOnly,
          autofocus: true,
          focusNode: widget.focusNode,
          controller: widget.controller,
          minLines: 100,
          maxLines: 100,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
