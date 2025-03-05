import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/common_drawer.dart';
import 'package:basicchessendgamestrainer/pages/widgets/random_testing_result_controls.dart';
import 'package:basicchessendgamestrainer/pages/widgets/random_testing_result_zone.dart';
import 'package:basicchessendgamestrainer/providers/random_testing_results_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const boardSize = 115.0;

class RandomTestingPage extends HookWidget {
  final List<String> generatedPositions;
  final List<String> rejectedPositions;

  const RandomTestingPage({
    super.key,
    required this.generatedPositions,
    required this.rejectedPositions,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      drawer: CommonDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(t.random_testing.title),
        leading: Builder(builder: (context) {
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
        }),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          GeneratedPositionsListWidget(
            generatedPositions: generatedPositions,
          ),
          RejectedPositionsWidget(
            rejectedPositions: rejectedPositions,
          ),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: t.random_testing.tab_generated_positions),
          Tab(text: t.random_testing.tab_rejected_positions),
        ],
      ),
    );
  }
}

class GeneratedPositionsListWidget extends HookConsumerWidget {
  const GeneratedPositionsListWidget({
    super.key,
    required this.generatedPositions,
  });

  final List<String> generatedPositions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 50)).then((value) {
        final positionsNotifier =
            ref.read(successRandomTestingResultsProvider.notifier);
        positionsNotifier.setResults(generatedPositions);
      });
      return null;
    }, []);
    final results = ref.watch(successRandomTestingResultsProvider);
    final positionsNotifier =
        ref.read(successRandomTestingResultsProvider.notifier);
    return Column(
      spacing: 10.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TestingControls(
          results: results,
          onBackwardFast: () {
            positionsNotifier.goToFirstPage();
          },
          onBackwardStep: () {
            positionsNotifier.goToPreviousPage();
          },
          onForwardStep: () {
            positionsNotifier.goToNextPage();
          },
          onForwardFast: () {
            positionsNotifier.gotoLastPage();
          },
          onPageSelectionSubmit: (pageIndex) {
            positionsNotifier.gotoToPageIndex(pageIndex);
          },
        ),
        TestingResultZone(
          results: results,
        ),
      ],
    );
  }
}

class RejectedPositionsWidget extends HookConsumerWidget {
  const RejectedPositionsWidget({
    super.key,
    required this.rejectedPositions,
  });

  final List<String> rejectedPositions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 50)).then((value) {
        final positionsNotifier =
            ref.read(errorsRandomTestingResultsProvider.notifier);
        positionsNotifier.setResults(rejectedPositions);
      });
      return null;
    }, []);
    final results = ref.watch(errorsRandomTestingResultsProvider);
    final positionsNotifier =
        ref.read(errorsRandomTestingResultsProvider.notifier);
    return Column(
      spacing: 10.0,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TestingControls(
          results: results,
          onBackwardFast: () {
            positionsNotifier.goToFirstPage();
          },
          onBackwardStep: () {
            positionsNotifier.goToPreviousPage();
          },
          onForwardStep: () {
            positionsNotifier.goToNextPage();
          },
          onForwardFast: () {
            positionsNotifier.gotoLastPage();
          },
          onPageSelectionSubmit: (pageIndex) {
            positionsNotifier.gotoToPageIndex(pageIndex);
          },
        ),
        TestingResultZone(
          results: results,
        ),
      ],
    );
  }
}
