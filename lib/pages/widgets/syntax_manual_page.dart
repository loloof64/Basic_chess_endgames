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
          "${t.syntax_manual_page.introduction.part_3}\n" +
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

class SyntaxManualPage extends StatelessWidget {
  const SyntaxManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.syntax_manual_page.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...luaAdaptationPage.toWidgets(),
          ],
        ),
      ),
    );
  }
}
