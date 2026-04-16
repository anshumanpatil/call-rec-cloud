import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/theme/theme.dart';

class RecordingPathSelector extends StatelessWidget {
  const RecordingPathSelector({
    super.key,
    required this.recordingsPathController,
    required this.onOpenFolder,
    required this.onReturnToMain,
  });

  final TextEditingController recordingsPathController;
  final VoidCallback onOpenFolder;
  final VoidCallback onReturnToMain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Open folder section
        const Text(
          AppStrings.openFolderLabel,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightGreenColor,
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: onOpenFolder,
          child: const Text(AppStrings.openButton),
        ),
        const SizedBox(height: 24),
        // Recordings path section
        const Text(
          AppStrings.recordingsPathLabel,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: recordingsPathController,
          decoration: InputDecoration(
            hintText: 'Enter recordings directory path',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(height: 100, color: Colors.green, thickness: 1),
        TextButton.icon(
          onPressed: onReturnToMain,
          icon: const Icon(Icons.arrow_back),
          label: const Text(AppStrings.returnToMainButton),
        ),
      ],
    );
  }
}
