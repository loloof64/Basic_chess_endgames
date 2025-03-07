// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, prefer_adjacent_string_concatenation

import 'package:basicchessendgamestrainer/pages/widgets/common_drawer.dart';
import 'package:flutter/material.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_1_3}\n\n" +
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_1} " +
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_2}\n" +
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_3}\n" +
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_4}\n" +
            "${t.syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations.part_2_5}"),
  ],
);

final goalPage = Page(
  title: t.syntax_manual_page.goal_of_position.title,
  sections: <Section>[
    Section(
      title: "",
      content: "${t.syntax_manual_page.goal_of_position.part_1} " +
          "${t.syntax_manual_page.goal_of_position.part_2}",
    ),
  ],
);

final pages = <Page>[
  introductionPage,
  algorithmPage,
  goalPage,
];

class SyntaxManualPage extends HookWidget {
  const SyntaxManualPage({super.key});

  void handlePageChanged(ValueNotifier<Page> currentPage, Page? newPage) {
    if (newPage == null) return;
    currentPage.value = newPage;
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = useState(pages[0]);
    final dropdownItems = pages.map((currentPage) {
      return DropdownMenuItem<Page>(
        value: currentPage,
        child: Text(currentPage.title),
      );
    }).toList();

    return Scaffold(
      drawer: CommonDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(t.syntax_manual_page.title),
        leading: Builder(
          builder: (context) {
            return SizedBox(
              width: 80,
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(Icons.menu),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
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
                onChanged: (newPage) => handlePageChanged(currentPage, newPage),
                value: currentPage.value,
              ),
            ),
            ...currentPage.value.toWidgets(),
          ],
        ),
      ),
    );
  }
}
