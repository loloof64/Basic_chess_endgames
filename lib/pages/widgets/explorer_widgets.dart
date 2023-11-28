import 'dart:io';
import 'package:fast_equatable/fast_equatable.dart';
import 'package:flutter/material.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;

const folderItemIconSize = 45.0;
const folderItemTextSize = 20.0;
const folderPathFontSize = 22.0;

class FolderItem with FastEquatable{
  final String name;
  final bool isFolder;
  bool? hasWinningGoal;
  String? path;

  FolderItem({
    required this.name,
    required this.isFolder,
  });

  @override
  bool get cacheHash => false;

  @override
  List<Object?> get hashParameters => [name, isFolder];
}

extension FolderItemsExtension on List<FileSystemEntity> {
  Future<void> order() async {
    final isDirectory = Map.fromEntries(await map((entity) async =>
            MapEntry(entity, await FileSystemEntity.isDirectory(entity.path)))
        .wait);

    sort((first, second) {
      final firstIsFolder = isDirectory[first]!;
      final secondIsFolder = isDirectory[second]!;
      final areOfSameType = firstIsFolder == secondIsFolder;

      if (areOfSameType) {
        return first.path.compareTo(second.path);
      } else {
        return firstIsFolder ? -1 : 1;
      }
    });
  }

  List<FolderItem> toFolderItemsList() {
    return map((elt) {
      return FolderItem(
        name: elt.path.split(p.separator).last,
        isFolder: elt is Directory,
      );
    }).toList();
  }
}

class FolderItemWidget extends StatelessWidget {
  final void Function({required FolderItem folderItem}) onClic;
  final void Function({required FolderItem folderItem}) onLongClic;

  const FolderItemWidget({
    super.key,
    required this.isSelected,
    required this.item,
    required this.onClic,
    required this.onLongClic,
  });

  final bool isSelected;
  final FolderItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClic(folderItem: item),
      onLongPress: () => onLongClic(folderItem: item),
      child: Container(
        color: isSelected ? Colors.blue[400] : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: folderItemIconSize,
                child: FaIcon(
                  FontAwesomeIcons.solidFolder,
                  color: Colors.yellow,
                  size: folderItemIconSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: folderItemTextSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileItemWidget extends StatelessWidget {
  final bool isSelected; 
  final FolderItem item;

  final void Function({required FolderItem fileItem}) onClic;
  final void Function({required FolderItem fileItem}) onLongClic;

  const FileItemWidget({
    super.key,
    required this.isSelected,
    required this.item,
    required this.onClic,
    required this.onLongClic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.blue[400] : Colors.transparent,
      child: InkWell(
        onTap: () => onClic(fileItem: item),
        onLongPress: () => onLongClic(fileItem: item),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: folderItemIconSize,
                height: folderItemIconSize,
                child: item.hasWinningGoal == true
                    ? SvgPicture.asset(
                        'assets/images/trophy.svg',
                        fit: BoxFit.cover,
                        width: folderItemIconSize,
                        height: folderItemIconSize,
                      )
                    : item.hasWinningGoal == false
                        ? SvgPicture.asset(
                            'assets/images/handshake.svg',
                            fit: BoxFit.cover,
                            width: folderItemIconSize,
                            height: folderItemIconSize,
                          )
                        : const FaIcon(
                            FontAwesomeIcons.fileLines,
                            color: Colors.black,
                            size: folderItemIconSize,
                          ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: folderItemTextSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentFolderPathWidget extends StatelessWidget {
  final Directory? rootDirectory;
  final Directory? currentDirectory;
  final String rootDirectoryText;

  const CurrentFolderPathWidget({
    super.key,
    required this.rootDirectory,
    required this.currentDirectory,
    required this.rootDirectoryText,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    if ((rootDirectory == null) || (currentDirectory == null)) {
      text = t.home.loading_content;
    } else {
      text = currentDirectory!.path.replaceFirst(
        rootDirectory!.path,
        rootDirectoryText,
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.yellow.shade200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          text,
          maxLines: 1,
          style: const TextStyle(
            fontSize: folderPathFontSize,
          ),
        ),
      ),
    );
  }
}
