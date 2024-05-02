import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';

enum FileChooserMode { open, save }

class _PathEntry extends Equatable {
  final String caption;
  final int index;

  const _PathEntry({
    required this.caption,
    required this.index,
  });

  @override
  List<Object> get props => [caption, index];
}

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
  List<String> _pathItems = [];
  _PathEntry? _selectedPath;
  String? _selectedItemName;
  Directory? _currentDirectory;

  String _buildTitle() {
    return widget.mode == FileChooserMode.open
        ? t.file_chooser.open
        : t.file_chooser.save;
  }

  List<String> _getPathItemsFromCurrentDirectory() {
    if (_currentDirectory == null) return [];
    final topDirectoryName = widget.topDirectory.path.split(p.separator).last;
    final simplifiedCurrentDirectoryPath = _currentDirectory!.path.replaceAll(
      widget.topDirectory.path,
      topDirectoryName,
    );
    return simplifiedCurrentDirectoryPath.split(p.separator);
  }

  void _updateSelectedPath(_PathEntry selectedPathEntry) {
    setState(() {
      _pathItems = _getPathItemsFromCurrentDirectory();
    });
  }

  @override
  void initState() {
    super.initState();
    _title = _buildTitle();
    _currentDirectory = widget.startDirectory;
    _pathItems = _getPathItemsFromCurrentDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FileChooserHeader(
            title: _title,
            pathItems: _pathItems,
            topDirectory: widget.topDirectory,
            updateSelectedPath: _updateSelectedPath,
          ),
          if (_currentDirectory != null)
            _FileChooserMainZone(
              currentDirectory: _currentDirectory!,
            ),
          if (widget.mode == FileChooserMode.save)
            _FileChooserValidationZone(
              confirmEnabled: _selectedPath != null,
              onValidationCallback: () {
                if (_selectedPath == null || _selectedItemName == null) return;
                final basePathIndex = _selectedPath!.index;
                final basePath = _pathItems
                    .sublist(0, basePathIndex)
                    .join(Platform.pathSeparator);
                final returnedValue =
                    "$basePath${Platform.pathSeparator}$_selectedItemName";
                Navigator.of(context).pop(returnedValue);
              },
            )
        ],
      ),
    );
  }
}

class _FileChooserHeader extends StatelessWidget {
  const _FileChooserHeader({
    required this.title,
    required this.pathItems,
    required this.topDirectory,
    required this.updateSelectedPath,
  });

  final String title;
  final List<String> pathItems;
  final Directory topDirectory;
  final void Function(_PathEntry selectedPathEntry) updateSelectedPath;

  List<DropdownMenuItem<_PathEntry>> _getDropdownItems() {
    return pathItems.asMap().entries.map((entry) {
      return DropdownMenuItem<_PathEntry>(
        value: _PathEntry(caption: entry.value, index: entry.key + 1),
        child: Text(
          entry.value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }).toList();
  }

  void _dropdownCallback(_PathEntry? selectedValue) {
    if (selectedValue != null) updateSelectedPath(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = _getDropdownItems();

    return LayoutBuilder(builder: (context, constraints) {
      final commonWidth = constraints.maxWidth;
      return Container(
        width: commonWidth,
        color: Colors.lightBlue,
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(t.file_chooser.location),
                ),
                DropdownButton<_PathEntry>(
                  items: dropdownItems,
                  onChanged: _dropdownCallback,
                  value: dropdownItems.last.value!,
                  dropdownColor: Colors.lightBlue,
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class _FileChooserMainZone extends StatelessWidget {
  const _FileChooserMainZone({
    required this.currentDirectory,
  });

  final Directory currentDirectory;

  @override
  Widget build(BuildContext context) {
    return Text(currentDirectory.path);
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
        ElevatedButton(
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
      ],
    );
  }
}
