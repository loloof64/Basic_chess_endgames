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
            fontStyle: FontStyle.italic,
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
            content:
                "${t.syntax_manual_page.introduction.part_1} ${t.syntax_manual_page.introduction.part_2} ${t.syntax_manual_page.introduction.part_3}\n${t.syntax_manual_page.introduction.part_4}"),
      ],
    );

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
            ...introductionPage.toWidgets(),
          ],
        ),
      ),
    );
  }
}
