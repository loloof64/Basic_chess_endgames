import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'random_testing_results_provider.g.dart';

const itemsPerPage = 6;

class RandomTestingResult {
  final int pageIndex;
  final int pagesCount;
  final List<String> loadedPositions;

  RandomTestingResult(
      {required this.pageIndex,
      required this.pagesCount,
      required this.loadedPositions});
}

abstract mixin class ResultsPageManager {
  int _page = 0;
  int _pagesCount = 1;
  List<String> _allResults = [];

  void setResults(List<String> results) {
    final uniqueResults = results.toSet().toList();
    _page = 0;
    _pagesCount = (uniqueResults.length / itemsPerPage).toInt();
    _allResults = uniqueResults;
    updateStateFromBounds(0, itemsPerPage);
  }

  void goToNextPage() {
    final firstPositionInCurrentPage = _page * itemsPerPage;
    final alreadyInLastPage =
        (firstPositionInCurrentPage + itemsPerPage) > positionsCount;
    if (alreadyInLastPage) {
      return;
    }

    _page++;
    _updateState();
  }

  void goToPreviousPage() {
    final firstPositionInCurrentPage = _page * itemsPerPage;
    final bool alreadyInFirstPage = firstPositionInCurrentPage <= 0;
    if (alreadyInFirstPage) {
      return;
    }

    _page--;
    _updateState();
  }

  void goToFirstPage() {
    _page = 0;
    _updateState();
  }

  void gotoLastPage() {
    final lastPage = _pagesCount - 1;
    _page = lastPage;
    _updateState();
  }

  void gotoToPageIndex(int pageIndex) {
    final isInRange = (pageIndex >= 0) && (pageIndex < pagesCount);
    if (!isInRange) {
      return;
    }
    _page = pageIndex;
    _updateState();
  }

  void _updateState() {
    final firstBound = _page * itemsPerPage;
    final lastBound = firstBound + itemsPerPage;
    updateStateFromBounds(firstBound, lastBound);
  }

  void updateStateFromBounds(int firstBound, int lastBound);

  int get currentPageIndex => _page;
  int get pagesCount => _pagesCount;
  int get positionsCount => _allResults.length;
}

@riverpod
class SuccessRandomTestingResults extends _$SuccessRandomTestingResults
    with ResultsPageManager {
  @override
  RandomTestingResult build() {
    return RandomTestingResult(
      pageIndex: 0,
      pagesCount: pagesCount,
      loadedPositions: [],
    );
  }

  @override
  void updateStateFromBounds(int firstBound, int lastBound) {
    if (lastBound > _allResults.length) {
      final lastPositions = _allResults.sublist(firstBound);
      state = RandomTestingResult(
        pageIndex: pagesCount - 1,
        pagesCount: pagesCount,
        loadedPositions: lastPositions,
      );
      return;
    }
    state = RandomTestingResult(
        pageIndex: _page,
        pagesCount: pagesCount,
        loadedPositions: _allResults.sublist(firstBound, lastBound));
  }
}

@riverpod
class ErrorsRandomTestingResults extends _$ErrorsRandomTestingResults
    with ResultsPageManager {
  @override
  RandomTestingResult build() {
    return RandomTestingResult(
      pageIndex: 0,
      pagesCount: pagesCount,
      loadedPositions: [],
    );
  }

  @override
  void updateStateFromBounds(int firstBound, int lastBound) {
    if (lastBound > _allResults.length) {
      final lastPositions = _allResults.sublist(firstBound);
      state = RandomTestingResult(
        pageIndex: pagesCount - 1,
        pagesCount: pagesCount,
        loadedPositions: lastPositions,
      );
      return;
    }
    state = RandomTestingResult(
        pageIndex: _page,
        pagesCount: pagesCount,
        loadedPositions: _allResults.sublist(firstBound, lastBound));
  }
}
