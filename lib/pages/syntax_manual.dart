import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';

enum SyntaxManualSection {
  scriptsGoal,
  scriptsKinds,
  scriptsFormat,
  comments,
  variablesCreation,
  predefinedValuesAndVariables,
  booleanExpressions,
  intExpressions,
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
  /*
  DropdownMenuItem(
    value: SyntaxManualSection.scriptsFormat,
    child: Text(t.syntax_manual_page.scripts_format),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.comments,
    child: Text(t.syntax_manual_page.comments),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.variablesCreation,
    child: Text(t.syntax_manual_page.variable_creation),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.predefinedValuesAndVariables,
    child: Text(t.syntax_manual_page.predefined_variables_and_values),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.booleanExpressions,
    child: Text(t.syntax_manual_page.boolean_expressions),
  ),
  DropdownMenuItem(
    value: SyntaxManualSection.intExpressions,
    child: Text(t.syntax_manual_page.int_expressions),
  ),
  */
];

const Map<SyntaxManualSection, Widget> dropDownWidgets = {
  SyntaxManualSection.scriptsGoal: ScriptsGoalWidget(),
  SyntaxManualSection.scriptsKinds: ScriptsKindsWidget()
};

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
          SingleChildScrollView(
            child: dropDownWidgets[_selectedSection],
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
      child: SingleChildScrollView(
        child: Text(t.syntax_manual_page.scripts_goal_description),
      ),
    );
  }
}

class ScriptsKindsWidget extends StatelessWidget {
  const ScriptsKindsWidget({super.key});

  final typeTitleStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
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
                      .scripts_kinds_player_king_constraint_description),
            ],
          ),
        ),
      ),
    );
  }
}
