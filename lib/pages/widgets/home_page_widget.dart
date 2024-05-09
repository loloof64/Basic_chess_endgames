import 'dart:io';
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/pages/widgets/explorer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;
const rgpdWarningHeight = 200.0;

extension SampleItemsExtension on List<AssetGame> {
  List<FolderItem> toFolderItemsList() {
    return map((elt) {
      return FolderItem(name: elt.label, isFolder: false)..path = elt.assetPath;
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
  // true if and only if we failed to load content
  final bool failedLoadingContent;

  /*
  null if we have not yet loaded content, otherwise,
  it's the list of contents.
  */
  final List<FolderItem>? folderItems;

  final Directory? rootDirectory;
  final Directory? currentDirectory;

  final void Function({required FolderItem fileItem}) onFileClic;
  final void Function({required FolderItem fileItem}) onFileLongClic;

  final void Function({required FolderItem folderItem}) onFolderClic;
  final void Function({required FolderItem folderItem}) onFolderLongClic;

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
  final FolderItem? selectedItem;

  final void Function({required FolderItem fileItem}) onFileClic;
  final void Function({required FolderItem fileItem}) onFileLongClic;

  final void Function({required FolderItem folderItem}) onFolderClic;
  final void Function({required FolderItem folderItem}) onFolderLongClic;

  const FolderContentWidget({
    super.key,
    this.selectedItem,
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
          rootDirectoryText: t.home.root_directory,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final item = elements[index];
              final isDirectory = item.isFolder;

              return isDirectory
                  ? FolderItemWidget(
                      isSelected: false,
                      item: item,
                      onClic: onFolderClic,
                      onLongClic: onFolderLongClic,
                    )
                  : FileItemWidget(
                      isSelected: item == selectedItem,
                      item: item,
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
