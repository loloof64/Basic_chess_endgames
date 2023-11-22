import 'dart:io';
import 'package:path/path.dart' as p;

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

Future<String> getTempFileNameInDirectory(Directory targetDirectory) async {
  const fileBaseName = 'temp';
  String fileDiscriminator = '';
  String tempFilePath =
      "${targetDirectory.path}${p.separator}$fileBaseName$fileDiscriminator.txt";
  File tempFileInstance = File(tempFilePath);

  if (await tempFileInstance.exists()) {
    int discriminatorNumber = 1;
    do {
      fileDiscriminator = '_$discriminatorNumber';
      tempFilePath =
          "${targetDirectory.path}${p.separator}$fileBaseName$fileDiscriminator.txt";
      tempFileInstance = File(tempFilePath);

      if (!await tempFileInstance.exists()) break;
      discriminatorNumber++;
    } while (true);
  }
  return "$fileBaseName$fileDiscriminator.txt";
}
