import 'dart:ui';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';

enum SyntaxManualSection {
  scriptsGoal,
  scriptsKinds,
  scriptsFormat,
  comments,
  variables,
  predefinedValues,
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
];

const Map<SyntaxManualSection, Widget> dropDownWidgets = {
  SyntaxManualSection.scriptsGoal: ScriptsGoalWidget(),
  SyntaxManualSection.scriptsKinds: ScriptsKindsWidget(),
  SyntaxManualSection.scriptsFormat: ScriptsFormatWidget(),
  SyntaxManualSection.comments: ScriptsCommentsWidget(),
  SyntaxManualSection.variables: ScriptsVariablesWidget(),
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
              text: t.syntax_manual_page.scripts_kinds_multiline_comments_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_multiline_comments_description,
            ),
            TextSpan(
              text:
                  t.syntax_manual_page.scripts_kinds_multiline_comments_sample,
              style: codeSampleStyle,
            ),
            TextSpan(
              text:
                  t.syntax_manual_page.scripts_kinds_single_line_comments_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_single_line_comments_description_1,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_single_line_comments_sample_1,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_single_line_comments_description_2,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_single_line_comments_sample_2,
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
              text:
                  t.syntax_manual_page.scripts_kinds_variables_name_rules_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_variables_name_rules_description,
            ),
            TextSpan(
              text: t.syntax_manual_page.scripts_kinds_variables_creation_title,
              style: typeTitleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_variables_creation_description,
            ),
            TextSpan(
              text:
                  t.syntax_manual_page.scripts_kinds_variables_creation_format,
              style: codeSampleStyle,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_variables_creation_sample_head_text,
            ),
            TextSpan(
              text: t.syntax_manual_page
                  .scripts_kinds_variables_creation_sample_code,
                  style: codeSampleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
