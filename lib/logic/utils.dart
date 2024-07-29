const piecesRefs = "NBRQK";

extension FanConverter on String {
  String toFan({required bool whiteMove}) {
    String result = this;

    final thisAsIndexedArray = split('').asMap();
    var firstOccurenceIndex = -1;
    for (var index = 0; index < thisAsIndexedArray.length; index++) {
      final element = thisAsIndexedArray[index]!;
      if (piecesRefs.contains(element)) {
        firstOccurenceIndex = index;
        break;
      }
    }

    if (firstOccurenceIndex > -1) {
      final element = thisAsIndexedArray[firstOccurenceIndex];
      dynamic replacement;
      switch (element) {
        case 'N':
          replacement = whiteMove ? "\u2658" : "\u265e";
          break;
        case 'B':
          replacement = whiteMove ? "\u2657" : "\u265d";
          break;
        case 'R':
          replacement = whiteMove ? "\u2656" : "\u265c";
          break;
        case 'Q':
          replacement = whiteMove ? "\u2655" : "\u265b";
          break;
        case 'K':
          replacement = whiteMove ? "\u2654" : "\u265a";
          break;
        default:
          throw Exception("Unrecognized piece char $element into SAN $this");
      }

      final firstPart = substring(0, firstOccurenceIndex);
      final lastPart = substring(firstOccurenceIndex + 1);

      result = "$firstPart$replacement$lastPart";
    }

    return result;
  }
}

List<String> splitTextLinesKeepingDelimiters(String text) {
  List<String> result = [];
  int start = 0;

  for (int i = 0; i < text.length; i++) {
    if (text[i] == '\n') {
      if (i > start) {
        result.add(text.substring(start, i));
      }
      result.add('\n');
      start = i + 1;
    }
  }

  if (start < text.length) {
    result.add(text.substring(start));
  }

  return result;
}
