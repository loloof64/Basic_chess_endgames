import 'dart:io';

import 'package:basicchessendgamestrainer/commons.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:flutter/material.dart';

class VariableInsertor extends StatelessWidget {
  final TranslationsWrapper translations;
  final List<List<String>> data;
  final TextEditingController? controller;
  final void Function() onDone;

  const VariableInsertor({
    super.key,
    required this.translations,
    required this.data,
    required this.controller,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final headers = <String>[
      translations.variablesTableHeaderName,
      translations.variablesTableHeaderDescription,
      translations.variablesTableHeaderType,
    ];

    var columnProportions = <double>[
      3,
      5,
      2,
    ];

    if (Platform.isAndroid &&
        MediaQuery.of(context).orientation == Orientation.portrait) {
      columnProportions = <double>[1, 1, 1];
    }

    return ProportionalTable(
      headers: headers,
      data: data,
      columnProportions: columnProportions,
      callback: (rowIndex, _) {
        if (controller == null) {
          return;
        }
        insertTextAtCursor(
          controller: controller!,
          textToInsert: data[rowIndex][0],
        );
        onDone();
      },
    );
  }
}

class ProportionalTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> data;
  final List<double> columnProportions;
  final void Function(int rowIndex, int colIndex) callback;

  const ProportionalTable({
    super.key,
    required this.headers,
    required this.data,
    required this.columnProportions,
    required this.callback,
  }) : assert(headers.length == columnProportions.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sticky header
        _buildHeaderRow(context),
        // Scrolling rows
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: data
                  .asMap()
                  .entries
                  .map((entry) => _buildDataRow(
                        row: entry.value,
                        rowIndex: entry.key,
                        callback: callback,
                        context: context,
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.primary,
      ),
      columnWidths: {
        for (int i = 0; i < headers.length; i++)
          i: FlexColumnWidth(columnProportions[i]),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          children: List.generate(headers.length, (index) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                headers[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDataRow({
    required int rowIndex,
    required List<String> row,
    required BuildContext context,
    required void Function(int rowIndex, int colIndex) callback,
  }) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.primary,
      ),
      columnWidths: {
        for (int i = 0; i < row.length; i++)
          i: FlexColumnWidth(columnProportions[i]),
      },
      children: [
        TableRow(
          children: List.generate(row.length, (index) {
            return GestureDetector(
              onTap: () => callback(rowIndex, index),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row[index],
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
