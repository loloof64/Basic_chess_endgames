import 'dart:io';
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;
const rgpdWarningHeight = 200.0;
const folderItemIconSize = 45.0;
const folderItemTextSize = 20.0;
const folderPathFontSize = 22.0;

extension SampleItemsExtension on List<AssetGame> {
  List<FolderItem> toFolderItemsList() {
    return map((elt) {
      return FolderItem(name: elt.label, isFolder: false)..path = elt.assetPath;
    }).toList();
  }
}

class FolderItem {
  final String name;
  final bool isFolder;
  bool? hasWinningGoal;
  String? path;

  FolderItem({
    required this.name,
    required this.isFolder,
  });
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

class IntegratedExercisesWidget extends StatelessWidget {
  final List<FolderItem> games;
  final void Function(FolderItem game) onGameSelected;
  final void Function(FolderItem game) onGameLongClick;

  const IntegratedExercisesWidget({
    super.key,
    required this.games,
    required this.onGameSelected,
    required this.onGameLongClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: mainListItemsGap,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (ctx2, index) {
                final game = games[index];

                final leadingImage = game.hasWinningGoal == null
                    ? const FaIcon(
                        FontAwesomeIcons.fileLines,
                        color: Colors.black,
                        size: leadingImagesSize,
                      )
                    : game.hasWinningGoal!
                        ? SvgPicture.asset(
                            'assets/images/trophy.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          )
                        : SvgPicture.asset(
                            'assets/images/handshake.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          );

                final title = Text(
                  game.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titlesFontSize,
                  ),
                );

                return ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: leadingImage,
                  title: title,
                  onTap: () => onGameSelected(game),
                  onLongPress: () => onGameLongClick(game),
                );
              }),
        ),
      ],
    );
  }
}

class AddedExercisesWidget extends StatelessWidget {
  //true if and only if we failed to load content
  final bool failedLoadingContent;

  /*
  null if we have not yet loaded content, otherwise,
  it's the list of contents.
  */
  final List<FolderItem>? folderItems;

  final Directory? rootDirectory;
  final Directory? currentDirectory;

  final void Function({required String fileName}) onFileClic;
  final void Function({required String fileName}) onFileLongClic;

  final void Function({required String folderName}) onFolderClic;
  final void Function({required String folderName}) onFolderLongClic;

  const AddedExercisesWidget({
    super.key,
    required this.failedLoadingContent,
    required this.rootDirectory,
    required this.currentDirectory,
    required this.folderItems,
    required this.onFileClic,
    required this.onFileLongClic,
    required this.onFolderClic,
    required this.onFolderLongClic,
  });

  @override
  Widget build(BuildContext context) {
    final failedLoadingExerciseWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const FaIcon(
          FontAwesomeIcons.xmark,
          color: Colors.red,
          size: 100.0,
        ),
        Text(t.home.failed_loading_added_exercises),
      ],
    );

    const waitingWidget = Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );

    final emptyFolderWidget = Center(
      child: Text(
        t.home.no_game_yet,
      ),
    );

    return failedLoadingContent
        ? failedLoadingExerciseWidget
        : folderItems == null
            ? waitingWidget
            : folderItems!.isEmpty
                ? emptyFolderWidget
                : FolderContentWidget(
                    rootDirectory: rootDirectory,
                    currentDirectory: currentDirectory,
                    elements: folderItems!,
                    onFileClic: onFileClic,
                    onFileLongClic: onFileLongClic,
                    onFolderClic: onFolderClic,
                    onFolderLongClic: onFolderLongClic,
                  );
  }
}

class FolderContentWidget extends StatelessWidget {
  final Directory? rootDirectory;
  final Directory? currentDirectory;
  final List<FolderItem> elements;

  final void Function({required String fileName}) onFileClic;
  final void Function({required String fileName}) onFileLongClic;

  final void Function({required String folderName}) onFolderClic;
  final void Function({required String folderName}) onFolderLongClic;

  const FolderContentWidget({
    super.key,
    required this.rootDirectory,
    required this.currentDirectory,
    required this.elements,
    required this.onFileClic,
    required this.onFileLongClic,
    required this.onFolderClic,
    required this.onFolderLongClic,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrentFolderPathWidget(
          rootDirectory: rootDirectory,
          currentDirectory: currentDirectory,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = elements[index];
              final isDirectory = item.isFolder;
              final name = item.path == '..' ? '..' : item.name;

              return isDirectory
                  ? FolderItemWidget(
                      name: name,
                      onClic: onFolderClic,
                      onLongClic: onFolderLongClic,
                    )
                  : FileItemWidget(
                      name: name,
                      hasWinningGoal: item.hasWinningGoal,
                      onClic: onFileClic,
                      onLongClic: onFileLongClic,
                    );
            },
            itemCount: elements.length,
          ),
        ),
      ],
    );
  }
}

class FileItemWidget extends StatelessWidget {
  final String name;
  final bool? hasWinningGoal;

  final void Function({required String fileName}) onClic;
  final void Function({required String fileName}) onLongClic;

  const FileItemWidget({
    super.key,
    required this.name,
    required this.hasWinningGoal,
    required this.onClic,
    required this.onLongClic,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClic(fileName: name),
      onLongPress: () => onLongClic(fileName: name),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: folderItemIconSize,
              height: folderItemIconSize,
              child: hasWinningGoal == true
                  ? SvgPicture.asset(
                      'assets/images/trophy.svg',
                      fit: BoxFit.cover,
                      width: folderItemIconSize,
                      height: folderItemIconSize,
                    )
                  : hasWinningGoal == false
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
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: folderItemTextSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FolderItemWidget extends StatelessWidget {
  final void Function({required String folderName}) onClic;
  final void Function({required String folderName}) onLongClic;

  const FolderItemWidget({
    super.key,
    required this.name,
    required this.onClic,
    required this.onLongClic,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClic(folderName: name),
      onLongPress: () => onLongClic(folderName: name),
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
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: folderItemTextSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentFolderPathWidget extends StatelessWidget {
  final Directory? rootDirectory;
  final Directory? currentDirectory;

  const CurrentFolderPathWidget({
    super.key,
    required this.rootDirectory,
    required this.currentDirectory,
  });

  @override
  Widget build(BuildContext context) {
    String text;
    if ((rootDirectory == null) || (currentDirectory == null)) {
      text = t.home.loading_content;
    } else {
      text = currentDirectory!.path
          .replaceFirst(rootDirectory!.path, t.home.root_directory);
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
