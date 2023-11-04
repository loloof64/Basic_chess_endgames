import 'dart:ui';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';

enum SyntaxManualSection {
  scriptsGoal,
  scriptsKinds,
  scriptsFormat,
  comments,
  variables,
  predefinedVariables,
  intExpressions,
  booleanExpressions,
}

List<DropdownMenuItem<SyntaxManualSection>> dropDownItems = [
  DropdownMenuItem(
    value: SyntaxManualSection.scriptsGoal,
    child: Text(t.syntax_manual_page.scripts_goal),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.scriptsKinds,
    child: Text(t.syntax_manual_page.scripts_kinds),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.scriptsFormat,
    child: Text(t.syntax_manual_page.scripts_format),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.comments,
    child: Text(t.syntax_manual_page.comments),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.variables,
    child: Text(t.syntax_manual_page.variables),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.predefinedVariables,
    child: Text(t.syntax_manual_page.predefined_variables),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.intExpressions,
    child: Text(t.syntax_manual_page.int_expressions),
  ),
];

const Map<SyntaxManualSection, Widget> dropDownWidgets = {
  SyntaxManualSection.scriptsGoal: ScriptsGoalWidget(),
  SyntaxManualSection.scriptsKinds: ScriptsKindsWidget(),
  SyntaxManualSection.scriptsFormat: ScriptsFormatWidget(),
  SyntaxManualSection.comments: ScriptsCommentsWidget(),
  SyntaxManualSection.variables: ScriptsVariablesWidget(),
  SyntaxManualSection.predefinedVariables: ScriptPredefinedVariablesWidget(),
  SyntaxManualSection.intExpressions: ScriptIntExpressionsWidget(),
};

const typeTitleStyle = TextStyle(
  color: Colors.blue,
  decoration: TextDecoration.underline,
);

final codeSampleStyle = TextStyle(
  color: Colors.green.shade700,
  fontFeatures: const [
    FontFeature.tabularFigures(),
  ],
);

const tableHeaderStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

String trimLeadingWhitespace(String text) {
  return text.split("\n").map((line) => line.trimLeft()).join("\n");
}

class SyntaxManualPage extends StatefulWidget {
  const SyntaxManualPage({super.key});

  @override
  State<SyntaxManualPage> createState() => _SyntaxManualPageState();
}

class _SyntaxManualPageState extends State<SyntaxManualPage> {
  SyntaxManualSection _selectedSection = SyntaxManualSection.scriptsGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.syntax_manual_page.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<SyntaxManualSection>(
            items: dropDownItems,
            value: _selectedSection,
            onChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _selectedSection = newValue;
              });
            },
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: dropDownWidgets[_selectedSection],
            ),
          ),
        ],
      ),
    );
  }
}

class ScriptsGoalWidget extends StatelessWidget {
  const ScriptsGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(t.syntax_manual_page.scripts_goal_description),
    );
  }
}

class ScriptsKindsWidget extends StatelessWidget {
  const ScriptsKindsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: t.syntax_manual_page.scripts_kinds_head_description,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_player_king_constraint_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_player_king_constraint_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_computer_king_constraint_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_computer_king_constraint_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_kings_mutual_constraints_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_kings_mutual_constraints_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_count_constraints_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_count_constraints_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_global_constraints_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_global_constraints_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_mutual_constraints_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_mutual_constraints_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_indexed_constraints_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_other_pieces_indexed_constraints_description,
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptsFormatWidget extends StatelessWidget {
  const ScriptsFormatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: t.syntax_manual_page.scripts_format_head_description,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: t.syntax_manual_page.scripts_format_main_description_1,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_format_code_section_1,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_format_main_description_2,
            ),
            TextSpan(
              text: trimLeadingWhitespace(
                  """kingInCenterColumn := (file >= FileC) and (file <= FileF);
                       kingInCenterRank := (rank >= Rank3) and (rank <= Rank6);

                       return kingInCenterColumn and kingInCenterRank;"""),
              style: codeSampleStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptsCommentsWidget extends StatelessWidget {
  const ScriptsCommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: t.syntax_manual_page.scripts_comments_head_description,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: t
                  .syntax_manual_page.scripts_comments_multiline_comments_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_multiline_comments_description,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_multiline_comments_sample,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_single_line_comments_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_single_line_comments_description_1,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_single_line_comments_sample_1,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_single_line_comments_description_2,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_comments_single_line_comments_sample_2,
              style: codeSampleStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptsVariablesWidget extends StatelessWidget {
  const ScriptsVariablesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: t.syntax_manual_page.scripts_variables_head_description,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: t.syntax_manual_page.scripts_variables_name_rules_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text:
                  t.syntax_manual_page.scripts_variables_name_rules_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_variables_creation_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_variables_creation_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_variables_creation_format,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_variables_creation_sample_head_text,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_variables_creation_sample_code,
              style: codeSampleStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptPredefinedVariablesWidget extends StatelessWidget {
  const ScriptPredefinedVariablesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              text: t.syntax_manual_page
                  .scripts_predefined_variables_head_description,
            ),
          ),
          RichText(
            text: TextSpan(
              text: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_title,
              style: typeTitleStyle,
            ),
          ),
          VariablesTableWidget(entities: [
            VariablesTableEntity(
              isInteger: true,
              name: "file",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_file,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "rank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_rank,
            ),
            VariablesTableEntity(
              isInteger: false,
              name: "playerHasWhite",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_player_has_white,
            ),
          ]),
          RichText(
            text: TextSpan(
              text: t.syntax_manual_page
                  .scripts_predefined_variables_mutual_kings_constraints_title,
              style: typeTitleStyle,
            ),
          ),
          VariablesTableWidget(entities: [
            VariablesTableEntity(
              isInteger: true,
              name: "playerKingFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_file_player,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "playerKingRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_rank_player,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "computerKingFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_file_computer,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "computerKingRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_rank_computer,
            ),
            VariablesTableEntity(
              isInteger: false,
              name: "playerHasWhite",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_player_has_white,
            ),
          ]),
          RichText(
            text: TextSpan(
              text: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_global_constraints_title,
              style: typeTitleStyle,
            ),
          ),
          VariablesTableWidget(entities: [
            VariablesTableEntity(
              isInteger: true,
              name: "file",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_global_constraints_file,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "rank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_global_constraints_rank,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "playerKingFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_file_player,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "playerKingRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_rank_player,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "computerKingFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_file_computer,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "computerKingRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_rank_computer,
            ),
            VariablesTableEntity(
              isInteger: false,
              name: "playerHasWhite",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_player_has_white,
            ),
          ]),
          RichText(
            text: TextSpan(
              text: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_mutual_constraints_title,
              style: typeTitleStyle,
            ),
          ),
          VariablesTableWidget(entities: [
            VariablesTableEntity(
              isInteger: true,
              name: "firstPieceFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_mutual_constraints_file_first,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "firstPieceRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_mutual_constraints_rank_first,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "secondPieceFile",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_mutual_constraints_file_second,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "secondPieceRank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_mutual_constraints_rank_second,
            ),
            VariablesTableEntity(
              isInteger: false,
              name: "playerHasWhite",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_player_has_white,
            ),
          ]),
          RichText(
            text: TextSpan(
              text: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_indexed_constraints_title,
              style: typeTitleStyle,
            ),
          ),
          VariablesTableWidget(entities: [
            VariablesTableEntity(
              isInteger: true,
              name: "apparitionIndex",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_indexed_constraints_apparition,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "file",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_global_constraints_file,
            ),
            VariablesTableEntity(
              isInteger: true,
              name: "rank",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_other_pieces_global_constraints_rank,
            ),
            VariablesTableEntity(
              isInteger: false,
              name: "playerHasWhite",
              use: t.syntax_manual_page
                  .scripts_predefined_variables_single_king_constraints_variable_player_has_white,
            ),
          ]),
        ],
      ),
    );
  }
}

class ScriptIntExpressionsWidget extends StatelessWidget {
  const ScriptIntExpressionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          text: t.syntax_manual_page.scripts_int_expressions_head_description,
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_syntax,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_sample_text,
            ),
            TextSpan(
              text: "(playerKingFile % 2)\n\n",
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_conditional_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_conditional_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_conditional_syntax,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_sample_text,
            ),
            TextSpan(
              text: "numIf(playerKingFile > FileD) then 0 else 7\n\n",
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_absolute_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_absolute_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_absolute_syntax,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_sample_text,
            ),
            TextSpan(
              text: "abs(playerKingRank - Rank5)\n\n",
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_modulo_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_modulo_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_modulo_syntax,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_sample_text,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_modulo_sample_code,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_arithmetic_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_arithmetic_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_arithmetic_syntax_1,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_arithmetic_syntax_or,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_arithmetic_syntax_2,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_parenthesis_sample_text,
            ),
            TextSpan(
              text: "playerKingFile + computerKingFile\n\n",
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_literal_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_literal_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_variable_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_variable_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.int_expression_predefined_values_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .int_expression_predefined_values_description,
            ),
          ],
        ),
      ),
    );
  }
}

class VariablesTableEntity {
  final bool isInteger;
  final String name;
  final String use;

  const VariablesTableEntity({
    required this.isInteger,
    required this.name,
    required this.use,
  });
}

class VariablesTableWidget extends StatelessWidget {
  final List<VariablesTableEntity> entities;

  const VariablesTableWidget({
    super.key,
    required this.entities,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FractionColumnWidth(0.40),
        1: FractionColumnWidth(0.20),
        2: FractionColumnWidth(0.40)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              t.syntax_manual_page.table_header_variable_name,
              style: tableHeaderStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              t.syntax_manual_page.table_header_variable_type,
              style: tableHeaderStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              t.syntax_manual_page.table_header_variable_use,
              style: tableHeaderStyle,
            ),
          )
        ]),
        for (var entity in entities)
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(entity.name),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(entity.isInteger ? "int" : "boolean"),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(entity.use),
            ),
          ]),
      ],
    );
  }
}
