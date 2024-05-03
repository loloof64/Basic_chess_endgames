import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/explorer_widgets.dart';
import 'package:basicchessendgamestrainer/pages/widgets/home_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

enum FileChooserMode { open, save }

class FileChooser extends StatefulWidget {
  FileChooser({
    super.key,
    required this.mode,
    required this.topDirectory,
    required this.startDirectory,
  }) {
    if (!startDirectory.path.contains(topDirectory.path)) {
      throw "currentDirectory must be a child of topDirectory";
    }
  }

  final FileChooserMode mode;
  // The topmost directory that user can navigate into.
  final Directory topDirectory;
  // The start directory : must be a child of topDirectory or the topDirectory itself.
  final Directory startDirectory;

  @override
  State<FileChooser> createState() => _FileChooserState();
}

class _FileChooserState extends State<FileChooser> {
  String _title = t.file_chooser.open;
  Directory? _currentDirectory;
  bool _failedLoadingContent = false;
  List<FolderItem>? _folderItems;

  String _buildTitle() {
    return widget.mode == FileChooserMode.open
        ? t.file_chooser.open
        : t.file_chooser.save;
  }

  Future<List<FolderItem>?> _getFolderItems() async {
    final items = _currentDirectory?.list(recursive: false);
    final result = await items?.toList();
    await result?.order();
    return result?.toFolderItemsList();
  }

  void _reloadCurrentFolder() async {
    setState(() {
      _failedLoadingContent = false;
    });
    try {
      _folderItems = await _getFolderItems();
      final isBelowRootLevel =
          _currentDirectory?.path != widget.topDirectory.path;
      if (isBelowRootLevel && _folderItems != null) {
        _folderItems = [
          FolderItem(name: '..', isFolder: true),
          ..._folderItems!
        ];
      }
      setState(() {});
    } catch (ex) {
      setState(() {
        _failedLoadingContent = true;
      });
    }
  }

  void _handleCustomFileClic({required FolderItem fileItem}) async {
    if (_currentDirectory == null) {
      throw "current folder is not ready";
    }

    final currentPath = _currentDirectory!.path;
    final selectedFilePath = "$currentPath${p.separator}${fileItem.name}";

    if (widget.mode == FileChooserMode.open) {
      Navigator.of(context).pop(selectedFilePath);
    } else {
      final confirmed = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(t.file_chooser.overwrite_dialog_title),
              content: Text(
                t.file_chooser.overwrite_dialog_message(Name: fileItem.name),
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
      if (confirmed) {
        if (!mounted) return;
        Navigator.of(context).pop(selectedFilePath);
      }
    }
  }

  void _handleCustomFolderClic({required FolderItem folderItem}) async {
    if (_currentDirectory == null) {
      throw "current folder is not ready";
    }

    if (folderItem.name == '..') {
      setState(() {
        _currentDirectory = _currentDirectory?.parent;
      });
      _reloadCurrentFolder();
      return;
    }

    final currentPath = _currentDirectory!.path;
    final folderInstance =
        Directory("$currentPath${p.separator}${folderItem.name}");
    if (!await folderInstance.exists()) return;

    setState(() {
      _currentDirectory = folderInstance;
    });
    _reloadCurrentFolder();
  }

  @override
  void initState() {
    super.initState();
    _title = _buildTitle();
    _currentDirectory = widget.startDirectory;
    _reloadCurrentFolder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_currentDirectory != null)
            Expanded(
              child: _FileChooserContentWidget(
                failedLoadingContent: _failedLoadingContent,
                rootDirectory: widget.topDirectory,
                currentDirectory: _currentDirectory,
                folderItems: _folderItems,
                onFileClic: _handleCustomFileClic,
                onFileLongClic: ({required FolderItem fileItem}) {},
                onFolderClic: _handleCustomFolderClic,
                onFolderLongClic: ({required FolderItem folderItem}) {},
              ),
            ),
          if (widget.mode == FileChooserMode.save)
            _FileChooserValidationZone(
              confirmEnabled: _currentDirectory != null,
              onValidationCallback: () {
                if (_currentDirectory != null) {
                  Navigator.of(context).pop(_currentDirectory!.path);
                }
              },
            )
        ],
      ),
    );
  }
}

class _FileChooserValidationZone extends StatelessWidget {
  const _FileChooserValidationZone({
    required this.confirmEnabled,
    required this.onValidationCallback,
  });

  final bool confirmEnabled;
  final void Function() onValidationCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (confirmEnabled)
          ElevatedButton(
            onPressed: onValidationCallback,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(
              t.misc.button_ok,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              t.misc.button_cancel,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FileChooserContentWidget extends StatelessWidget {
  // true if and only if we failed to load content
  final bool failedLoadingContent;

  /*
  null if we have not yet loaded content, otherwise,
  it's the list of contents.
  */
  final List<FolderItem>? folderItems;

  final Directory? rootDirectory;
  final Directory? currentDirectory;

  final void Function({required FolderItem fileItem}) onFileClic;
  final void Function({required FolderItem fileItem}) onFileLongClic;

  final void Function({required FolderItem folderItem}) onFolderClic;
  final void Function({required FolderItem folderItem}) onFolderLongClic;

  const _FileChooserContentWidget({
    required this.failedLoadingContent,
    required this.rootDirectory,
    required this.currentDirectory,
    required this.folderItems,
    required this.onFileClic,
    required this.onFileLongClic,
    required this.onFolderClic,
    required this.onFolderLongClic,
  });

  @override
  Widget build(BuildContext context) {
    final failedLoadingExerciseWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const FaIcon(
          FontAwesomeIcons.xmark,
          color: Colors.red,
          size: 100.0,
        ),
        Text(t.home.failed_loading_added_exercises),
      ],
    );

    const waitingWidget = Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );

    final emptyFolderWidget = Center(
      child: Text(
        t.home.no_game_yet,
      ),
    );

    return failedLoadingContent
        ? failedLoadingExerciseWidget
        : folderItems == null
            ? waitingWidget
            : folderItems!.isEmpty
                ? emptyFolderWidget
                : FolderContentWidget(
                    rootDirectory: rootDirectory,
                    currentDirectory: currentDirectory,
                    elements: folderItems!,
                    onFileClic: onFileClic,
                    onFileLongClic: onFileLongClic,
                    onFolderClic: onFolderClic,
                    onFolderLongClic: onFolderLongClic,
                  );
  }
}
