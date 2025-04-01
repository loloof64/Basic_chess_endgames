import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/models/action_result.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:open_save_file_dialogs/open_save_file_dialogs.dart';

final _openSaveFileDialogsPlugin = OpenSaveFileDialogs();
Future<ActionResult> saveTextFile({
  required BuildContext context,
  required String filePath,
  required String content,
}) async {
  try {
    final newFile = File(filePath);

    await newFile.writeAsString(
      content,
      mode: FileMode.writeOnly,
    );

    return ActionResult.success;
  } on Exception catch (error) {
    debugPrint("File saving error: $error");
    return ActionResult.error;
  }
}

Future<ActionResult> purposeSaveFile({
  required BuildContext context,
  required String content,
}) async {
  if (Platform.isAndroid) {
    try {
      final filePath =
          await _openSaveFileDialogsPlugin.saveFileDialog(content: content);
      if (filePath == null) {
        debugPrint("File saving cancellation.");

        if (!context.mounted) return ActionResult.cancelled;

        Navigator.of(context).pop();
        return ActionResult.cancelled;
      }

      return ActionResult.success;
    } on FileSystemException catch (e) {
      debugPrint("File saving error: $e");
      return ActionResult.error;
    }
  } else {
    final filePath = await FilePicker.platform.saveFile(
      dialogTitle: t.pickers.save_file_title,
    );
    if (filePath == null) {
      debugPrint("File saving cancellation.");
      return ActionResult.cancelled;
    }

    if (!context.mounted) return ActionResult.cancelled;

    final result = await saveTextFile(
      context: context,
      filePath: filePath,
      content: content,
    );
    return result;
  }
}
