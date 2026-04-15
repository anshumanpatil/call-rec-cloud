import 'package:docman/docman.dart';
import 'package:flutter/material.dart';
import 'package:cll_upld/constants.dart';

class RecordingsListView extends StatelessWidget {
  const RecordingsListView({
    super.key,
    required this.recordings,
    required this.selectedItems,
    required this.allSelected,
    required this.onToggleSelectAll,
    required this.onSelectedChanged,
  });

  final List<DocumentFile> recordings;
  final List<bool> selectedItems;
  final bool allSelected;
  final VoidCallback onToggleSelectAll;
  final ValueChanged<int> onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recordings.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return CheckboxListTile(
            title: const Text(AppStrings.selectAllLabel),
            value: allSelected,
            onChanged: (bool? value) {
              onToggleSelectAll();
            },
          );
        }

        final fileIndex = index - 1;
        final file = recordings[fileIndex];
        final fileName = file.name;
        final icon = file.isDirectory ? Icons.folder : Icons.insert_drive_file;

        return CheckboxListTile(
          title: Text(fileName),
          secondary: Icon(icon),
          value: selectedItems[fileIndex],
          onChanged: (bool? value) {
            onSelectedChanged(fileIndex);
          },
        );
      },
    );
  }
}
