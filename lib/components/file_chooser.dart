import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  const FileChooser({
    super.key,
    required this.mode,
  });

  final FileChooserMode mode;

  @override
  State<FileChooser> createState() => _FileChooserState();
}

class _FileChooserState extends State<FileChooser> {
  String _title = t.file_chooser.open;
  final List<String> _pathItems = [];
  _PathEntry? _selectedPath;
  String? _selectedItemName;

  String _buildTitle() {
    return widget.mode == FileChooserMode.open
        ? t.file_chooser.open
        : t.file_chooser.save;
  }

  @override
  void initState() {
    super.initState();
    _title = _buildTitle();
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
          ),
          const _FileChooserMainZone(),
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

class _FileChooserHeader extends StatefulWidget {
  const _FileChooserHeader({
    required this.title,
    required this.pathItems,
  });

  final String title;
  final List<String> pathItems;

  @override
  State<_FileChooserHeader> createState() => _FileChooserHeaderState();
}

class _FileChooserHeaderState extends State<_FileChooserHeader> {
  _PathEntry? _selectedEntry;

  void _dropdownCallback(_PathEntry? selectedValue) {
    setState(() {
      _selectedEntry = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = widget.pathItems.asMap().entries.map((entry) {
      return DropdownMenuItem<_PathEntry>(
        value: _PathEntry(caption: entry.value, index: entry.key),
        child: Text(entry.value),
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.green,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(t.file_chooser.location),
            DropdownButton<_PathEntry>(
              items: dropdownItems,
              onChanged: _dropdownCallback,
              value: _selectedEntry,
            ),
          ],
        )
      ],
    );
  }
}

class _FileChooserMainZone extends StatelessWidget {
  const _FileChooserMainZone();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Text("Hello, explorer !"),
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
