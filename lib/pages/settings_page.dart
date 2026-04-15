import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docman/docman.dart';
import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/settings_repository.dart';
import 'package:cll_upld/theme/theme.dart';
import 'package:cll_upld/widgets/recording_path_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _recordingsPathController;
  final SettingsRepository _settingsRepository = SettingsRepository();
  String? _initialDirectory;

  bool get _supportsDirectoryPicker {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android;
  }

  String? get _initialTreeUri {
    if (_initialDirectory != null &&
        _initialDirectory!.startsWith('content://')) {
      return _initialDirectory;
    }
    return null;
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

  Future<DocumentFile?> _pickDirectory() async {
    return await _settingsRepository.pickDirectory(
      initialTreeUri: _initialTreeUri,
    );
  }

  void _applySelectedPath(String selectedPath) {
    setState(() {
      _recordingsPathController.text = selectedPath;
      _initialDirectory = selectedPath;
    });
  }

  Future<void> _saveSelectedPath(String selectedPath) async {
    await _settingsRepository.saveSelectedPath(selectedPath);
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

    final DocumentFile? selectedDirectory;
    try {
      selectedDirectory = await _pickDirectory();
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

    final selectedPath = selectedDirectory.uri;
    _applySelectedPath(selectedPath);

    try {
      await _saveSelectedPath(selectedPath);
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
        child: RecordingPathSelector(
          recordingsPathController: _recordingsPathController,
          onOpenFolder: _openFolderSelector,
          onReturnToMain: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
