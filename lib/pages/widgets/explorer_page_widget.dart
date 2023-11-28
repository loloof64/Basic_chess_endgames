import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:basicchessendgamestrainer/pages/widgets/explorer_content_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/explorer_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as p;

enum ExplorerMode { open, save }

enum ExplorerItemType { folder, file }

class ExplorerPageWidget extends StatefulWidget {
  final String title;
  final String? originFileName;
  final String rootDirectoryText;
  final Directory rootDirectory;
  final ExplorerMode mode;
  final ExplorerItemType itemType;
  final List<String> allowedExtensions;

  const ExplorerPageWidget({
    super.key,
    required this.title,
    required this.originFileName,
    required this.rootDirectoryText,
    required this.rootDirectory,
    required this.mode,
    required this.itemType,
    required this.allowedExtensions,
  });

  @override
  State<ExplorerPageWidget> createState() => _ExplorerPageWidgetState();
}

class _ExplorerPageWidgetState extends State<ExplorerPageWidget> {
  late Directory _currentDirectory;

  bool _failedLoadingContent = false;

  TextEditingController _saveFileNameController = TextEditingController();
  final TextEditingController _newFolderNameController =
      TextEditingController();

  /*
  null if we have not yet loaded content, otherwise,
  it's the list of contents.
  */
  List<FolderItem>? _folderItems;

  FolderItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _currentDirectory = widget.rootDirectory;
    _saveFileNameController =
        TextEditingController(text: widget.originFileName ?? '');
    _reloadCurrentFolder();
  }

  @override
  void dispose() {
    _saveFileNameController.dispose();
    _newFolderNameController.dispose();
    super.dispose();
  }

  void _handleFileClic({required FolderItem fileItem}) {
    if (widget.itemType != ExplorerItemType.file) {
      return;
    }
    setState(() {
      _selectedItem = fileItem;
    });
  }

  void _handleFolderClic({required FolderItem folderItem}) async {
    if (folderItem.name == '..') {
      setState(() {
        _selectedItem = null;
        _currentDirectory = _currentDirectory.parent;
      });
      _reloadCurrentFolder();
      return;
    }

    final currentPath = _currentDirectory.path;
    final folderInstance =
        Directory("$currentPath${p.separator}${folderItem.name}");
    if (!await folderInstance.exists()) return;

    setState(() {
      _selectedItem = null;
      _currentDirectory = folderInstance;
    });
    _reloadCurrentFolder();
  }

  void _handleFolderLongClic({required FolderItem folderItem}) {
    if (widget.itemType != ExplorerItemType.folder) {
      return;
    }

    setState(() {
      _selectedItem = folderItem;
    });
  }

  void _reloadCurrentFolder() async {
    setState(() {
      _failedLoadingContent = false;
    });
    try {
      _folderItems = await _getFolderItems();
      final isBelowRootLevel =
          _currentDirectory.path != widget.rootDirectory.path;
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

  Future<List<FolderItem>?> _getFolderItems(
      {List<String>? extensionFilters}) async {
    final items = _currentDirectory.list(recursive: false);
    var result = await items.toList();
    //////////////////////////////////
    print("--------------------");
    print(result);
    //////////////////////////////////
    if (extensionFilters != null) {
      result = result
          .where(
            (element) => (element is Directory)
                ? true
                : extensionFilters.any(
                    (extension) => element.path.endsWith(extension),
                  ),
          )
          .toList();
    }
    await result.order();
    //////////////////////////////////
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(result);
    //////////////////////////////////
    return result.toFolderItemsList();
  }

  void _showAddFolderDialog() {
    _newFolderNameController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(t.explorer.new_folder_title),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(t.explorer.new_folder_prompt),
                Expanded(
                  child: TextField(
                    controller: _newFolderNameController,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _addNewFolder();
                },
                child: Text(
                  t.misc.button_validate,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          );
        });
  }

  void _addNewFolder() async {
    if (_newFolderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        t.explorer.empty_item_name,
      )));
      return;
    }
    final path =
        "${_currentDirectory.path}${p.separator}${_newFolderNameController.text}";
    if (await Directory(path).exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        t.explorer.folder_already_exists,
      )));
    }

    await Directory(path).create(recursive: true);
    _reloadCurrentFolder();
  }

  void _handleValidate() {
    if (widget.mode == ExplorerMode.open && _selectedItem == null) return;
    if (widget.mode == ExplorerMode.save &&
        _saveFileNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        t.explorer.empty_item_name,
      )));
      return;
    }
    if (widget.itemType == ExplorerItemType.file) {
      if (_selectedItem?.isFolder ?? false) throw "selected item is a folder";
      final path =
          "${_currentDirectory.path}${p.separator}${_saveFileNameController.text}";
      Navigator.of(context).pop(path);
    }
  }

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
        Text(t.explorer.failed_loading_content),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _showAddFolderDialog,
            icon: const FaIcon(
              FontAwesomeIcons.solidFolder,
            ),
          )
        ],
      ),
      body: _failedLoadingContent
          ? failedLoadingExerciseWidget
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExplorerContentWidget(
                  rootDirectoryText: widget.rootDirectoryText,
                  rootDirectory: widget.rootDirectory,
                  currentDirectory: _currentDirectory,
                  elements: _folderItems ?? [],
                  selectedItem: _selectedItem,
                  allowedExtensions: widget.allowedExtensions,
                  handleFileClic: _handleFileClic,
                  handleFolderClic: _handleFolderClic,
                  handleFolderLongClic: _handleFolderLongClic,
                ),
                if (widget.mode == ExplorerMode.save)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          t.explorer.save_file_prompt,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _saveFileNameController,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _handleValidate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          child: Text(
                            t.misc.button_validate,
                          ),
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(null);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                          child: Text(
                            t.misc.button_cancel,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
    );
  }
}
