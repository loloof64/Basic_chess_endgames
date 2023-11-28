import 'dart:io';

import 'package:basicchessendgamestrainer/pages/widgets/explorer_widgets.dart';
import 'package:flutter/material.dart';

class ExplorerContentWidget extends StatelessWidget {
  final String rootDirectoryText;
  final Directory rootDirectory;
  final Directory currentDirectory;
  final FolderItem? selectedItem;
  final List<String> allowedExtensions;
  final List<FolderItem> elements;

  final void Function({required FolderItem folderItem}) handleFolderClic;
  final void Function({required FolderItem folderItem}) handleFolderLongClic;
  final void Function({required FolderItem fileItem}) handleFileClic;

  const ExplorerContentWidget({
    super.key,
    required this.rootDirectoryText,
    required this.rootDirectory,
    required this.currentDirectory,
    required this.selectedItem,
    required this.allowedExtensions,
    required this.elements,
    required this.handleFolderClic,
    required this.handleFolderLongClic,
    required this.handleFileClic,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        children: [
          CurrentFolderPathWidget(
            rootDirectory: rootDirectory,
            currentDirectory: currentDirectory,
            rootDirectoryText: rootDirectoryText,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = elements[index];
                final isDirectory = item.isFolder;
                final isSelected = selectedItem == item;
      
                return isDirectory
                    ? FolderItemWidget(
                      isSelected: isSelected,
                        item: item,
                        onClic: handleFolderClic,
                        onLongClic: handleFolderLongClic,
                      )
                    : FileItemWidget(
                        isSelected: isSelected,
                        item: item,
                        onClic: handleFileClic,
                        onLongClic: ({required FolderItem fileItem}){},
                      );
              },
              itemCount: elements.length,
            ),
          ),
        ],
      ),
    );
  }
}
