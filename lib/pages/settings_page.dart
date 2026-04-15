import 'package:flutter/material.dart';
import 'package:cll_upld/constants.dart';
import 'package:cll_upld/theme/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _recordingsPathController;

  @override
  void initState() {
    super.initState();
    _recordingsPathController = TextEditingController();
  }

  @override
  void dispose() {
    _recordingsPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPurpleColor,
        title: const Text(AppStrings.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                // TODO: Implement folder selection logic
                print('Open folder button pressed');
              },
              child: const Text(AppStrings.openButton),
            ),
            const SizedBox(height: 32),
            // Recordings path section
            const Text(
              AppStrings.recordingsPathLabel,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _recordingsPathController,
              decoration: InputDecoration(
                hintText: 'Enter recordings directory path',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text(AppStrings.returnToMainButton),
            ),
          ],
        ),
      ),
    );
  }
}
