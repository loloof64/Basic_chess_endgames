// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:flutter/material.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';

class Page {
  final String title;
  final List<Section> sections;

  Page({
    required this.title,
    required this.sections,
  });

  List<Widget> toWidgets() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      for (final currentSection in sections) ...currentSection.toWidgets()
    ];
  }

  @override
  String toString() {
    return title;
  }
}

class Section {
  final String title;
  final String content;

  Section({
    required this.title,
    required this.content,
  });

  List<Widget> toWidgets() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          title,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 16.0,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 13.0,
          ),
        ),
      ),
    ];
  }
}

final introductionPage = Page(
  title: t.syntax_manual_page.introduction.title,
  sections: <Section>[
    Section(
      title: "",
      content: "${t.syntax_manual_page.introduction.part_1} " +
          "${t.syntax_manual_page.introduction.part_2} " +
          "${t.syntax_manual_page.introduction.part_3}\n\n" +
          "${t.syntax_manual_page.introduction.part_4}",
    ),
  ],
);

final luaAdaptationPage =
    Page(title: t.syntax_manual_page.lua_adaptation.title, sections: <Section>[
  Section(
    title: t.syntax_manual_page.lua_adaptation.supported_types.title,
    content: "${t.syntax_manual_page.lua_adaptation.supported_types.part_1}\n" +
        "${t.syntax_manual_page.lua_adaptation.supported_types.part_2}",
  ),
  Section(
    title: t.syntax_manual_page.lua_adaptation.removed_types.title,
    content: "${t.syntax_manual_page.lua_adaptation.removed_types.part_1}\n" +
        "${t.syntax_manual_page.lua_adaptation.removed_types.part_2}\n" +
        "${t.syntax_manual_page.lua_adaptation.removed_types.part_3}\n" +
        "${t.syntax_manual_page.lua_adaptation.removed_types.part_4}",
  ),
  Section(
    title: t.syntax_manual_page.lua_adaptation.available_syntax_elements.title,
    content:
        "${t.syntax_manual_page.lua_adaptation.available_syntax_elements.part_1}\n" +
            "${t.syntax_manual_page.lua_adaptation.available_syntax_elements.part_2}",
  ),
  Section(
    title: t.syntax_manual_page.lua_adaptation.removed_syntax_elements.title,
    content: "${t.syntax_manual_page.lua_adaptation.removed_syntax_elements.part_1}\n" +
        "${t.syntax_manual_page.lua_adaptation.removed_syntax_elements.part_2}\n" +
        "${t.syntax_manual_page.lua_adaptation.removed_syntax_elements.part_3}",
  ),
  Section(
    title: t.syntax_manual_page.lua_adaptation.available_operators.title,
    content: "${t.syntax_manual_page.lua_adaptation.available_operators.part_1}\n" +
        "${t.syntax_manual_page.lua_adaptation.available_operators.part_2}\n" +
        "${t.syntax_manual_page.lua_adaptation.available_operators.part_3}\n" +
        "${t.syntax_manual_page.lua_adaptation.available_operators.part_4}\n" +
        "${t.syntax_manual_page.lua_adaptation.available_operators.part_5}",
  ),
]);

final algorithmPage = Page(
  title: t.syntax_manual_page.explaining_generation_algorithm.title,
  sections: <Section>[
    Section(
      title: t.syntax_manual_page.explaining_generation_algorithm
          .general_considerations.title,
      content: "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_1_1} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_1_2} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_1_3} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_1_4}\n\n" +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_2_1} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_2_2} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_2_3} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_2_4}\n\n" +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_3_1} " +
          "${t.syntax_manual_page.explaining_generation_algorithm.general_considerations.part_3_2} ",
    ),
    Section(
      title: t.syntax_manual_page.explaining_generation_algorithm
          .order_of_scripts_evaluations.title,
      content: "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_1_1}\n" +
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_1_2}\n" +
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_1_3}\n\n"+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_1} "+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_2}\n"+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_3}\n"+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_4}\n"+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_5}\n\n"+
          "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_3_1}",
    ),
  ],
);

final pages = <Page>[
  introductionPage,
  luaAdaptationPage,
  algorithmPage,
];

class SyntaxManualPage extends StatefulWidget {
  const SyntaxManualPage({super.key});

  @override
  State<SyntaxManualPage> createState() => _SyntaxManualPageState();
}

class _SyntaxManualPageState extends State<SyntaxManualPage> {
  Page _currentPage = pages[0];

  void _handlePageChanged(Page? page) {
    if (page == null) return;
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dropdownItems = pages.map((currentPage) {
      return DropdownMenuItem<Page>(
        value: currentPage,
        child: Text(currentPage.title),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.syntax_manual_page.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<Page>(
                items: dropdownItems,
                onChanged: _handlePageChanged,
                value: _currentPage,
              ),
            ),
            ..._currentPage.toWidgets(),
          ],
        ),
      ),
    );
  }
}
