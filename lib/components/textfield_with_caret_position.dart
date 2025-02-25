import 'package:basicchessendgamestrainer/logic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextfieldWithPositionTracker extends HookWidget {
  const TextfieldWithPositionTracker({
    super.key,
    required this.controller,
    this.focusNode,
    required this.readOnly,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool readOnly;

  void initState(void Function() listener) {
    controller.addListener(listener);
  }

  String getUpdatedCursorPosition() {
    final text = controller.text;
    final selection = controller.selection;

    if (selection.baseOffset == -1) {
      return "1:1";
    }

    final beforeCursor = text.substring(0, selection.baseOffset);
    var lines = splitTextLinesKeepingDelimiters(beforeCursor)
        .where((currentLine) => currentLine.isNotEmpty);

    final lastLineEndedWithCarriageReturn = lines.lastOrNull == '\n';
    lines = lines.where((elt) => elt != '\n');

    if (lines.isEmpty) {
      return "1:1";
    }

    var lineNumber = lines.length;
    var columnNumber = lines.last.length + 1;

    // A tiny fix for start of lines.
    if (lastLineEndedWithCarriageReturn) {
      lineNumber = lineNumber + 1;
      columnNumber = 1;
    }

    return '$lineNumber:$columnNumber';
  }

  void dispose(void Function() listener) {
    controller.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final cursorPosition = useState("1:1");
    useEffect(() {
      listener() {
        cursorPosition.value = getUpdatedCursorPosition();
      }
      initState(listener);
      return () => dispose(listener);
    }, []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cursorPosition.value),
        const SizedBox(height: 20),
        TextField(
          readOnly: readOnly,
          autofocus: true,
          focusNode: focusNode,
          controller: controller,
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
