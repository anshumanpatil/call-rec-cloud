import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docman/docman.dart';
import 'package:cll_upld/constants.dart';
import 'package:cll_upld/services/database_provider.dart';
import 'package:cll_upld/theme/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _recordingsPathController;
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  String? _initialDirectory;

  bool get _supportsDirectoryPicker {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android;
  }

  // Future<void> _loadInitialDirectory() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();

  //     if (!mounted) {
  //       return;
  //     }

  //     setState(() {
  //       _initialDirectory = directory.path;
  //       _recordingsPathController.text = directory.path;
  //     });

  //     try {
  //       final allSettings = await _databaseProvider.getAllSettings();
  //       if (allSettings.isEmpty) {
  //         // Create new settings record
  //         await _databaseProvider.createSettings(
  //           isPathAvailable: true,
  //           recordingsPath: _initialDirectory,
  //         );
  //         print(
  //           '✓ New settings created and path saved to database: $_initialDirectory',
  //         );
  //       } else {
  //         // Update existing settings record
  //         final settingId = allSettings.first['id'];
  //         await _databaseProvider.updateSettings(
  //           settingId: settingId,
  //           isPathAvailable: true,
  //           recordingsPath: _initialDirectory,
  //         );
  //         print('✓ Existing settings updated with path: $_initialDirectory');
  //       }
  //     } catch (e) {
  //       print('Error saving path to database: $e');
  //     }
  //   } catch (_) {
  //     // Keep picker functional even if the default path lookup fails.
  //   }
  // }

  void _showStatusDialog({
    required String title,
    required String message,
    required DialogType dialogType,
  }) {
    if (!mounted) {
      return;
    }

    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> _openFolderSelector() async {
    if (!_supportsDirectoryPicker) {
      _showStatusDialog(
        title: 'Unsupported Platform',
        message: 'Folder selection is not supported on this platform.',
        dialogType: DialogType.warning,
      );
      return;
    }

    DocumentFile? selectedDirectory;
    try {
      final initialTreeUri =
          (_initialDirectory != null &&
              _initialDirectory!.startsWith('content://'))
          ? _initialDirectory
          : null;

      selectedDirectory = await DocMan.pick.directory(initDir: initialTreeUri);
    } catch (_) {
      _showStatusDialog(
        title: 'Folder Picker Error',
        message: 'Unable to open folder selector on this platform.',
        dialogType: DialogType.error,
      );
      return;
    }

    if (!mounted || selectedDirectory == null) {
      return;
    }

    final selectedPath = selectedDirectory.uri.toString();

    setState(() {
      _recordingsPathController.text = selectedPath;
      _initialDirectory = selectedPath;
    });

    try {
      final allSettings = await _databaseProvider.getAllSettings();
      if (allSettings.isEmpty) {
        await _databaseProvider.createSettings(
          isPathAvailable: true,
          recordingsPath: selectedPath,
        );
      } else {
        final settingId = allSettings.first['id'] as int;
        await _databaseProvider.updateSettings(
          settingId: settingId,
          isPathAvailable: true,
          recordingsPath: selectedPath,
        );
      }
    } catch (e) {
      _showStatusDialog(
        title: 'Save Failed',
        message: 'Unable to save selected path: $e',
        dialogType: DialogType.error,
      );
      return;
    }

    _showStatusDialog(
      title: 'Folder Selected',
      message: 'Folder selected successfully.',
      dialogType: DialogType.success,
    );
  }

  @override
  void initState() {
    super.initState();
    _recordingsPathController = TextEditingController();
    // _loadInitialDirectory();
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
                backgroundColor: lightGreenColor,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _openFolderSelector,
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
              // readOnly: true,
            ),
            const SizedBox(height: 24),
            Divider(height: 100, color: Colors.green, thickness: 1),
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
