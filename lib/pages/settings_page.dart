import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docman/docman.dart';
import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/settings_repository.dart';
import 'package:cll_upld/services/database_provider.dart';
import 'package:cll_upld/widgets/notification_settings_widget.dart';
import 'package:cll_upld/theme/theme.dart';
import 'package:cll_upld/widgets/recording_path_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _recordingsPathController;
  late TextEditingController _notificationTitleController;
  late TextEditingController _notificationBodyController;
  final SettingsRepository _settingsRepository = SettingsRepository();
  final DatabaseProvider _databaseProvider = DatabaseProvider();
  static const Set<String> _validRepeatIntervals = {
    'hourly',
    'daily',
    'weekly',
  };
  String _selectedRepeatInterval = 'daily';
  String? _initialDirectory;
  int? _notificationDetailsId;

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
  //         log(
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
  //         log('✓ Existing settings updated with path: $_initialDirectory');
  //       }
  //     } catch (e) {
  //       log('Error saving path to database: $e');
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

  // Future<void> _sendTestNotification() async {
  //   try {
  //     final log = await _localNotificationService
  //         .sendImmediateTestNotification();
  //     _showStatusDialog(
  //       title: 'Notification Test',
  //       message: log,
  //       dialogType: DialogType.info,
  //     );
  //   } catch (e) {
  //     _showStatusDialog(
  //       title: 'Notification Test Failed',
  //       message: '$e',
  //       dialogType: DialogType.error,
  //     );
  //   }
  // }

  Future<void> _loadNotificationDetails() async {
    final allDetails = await _databaseProvider.getAllNotificationDetails();
    if (allDetails.isEmpty) {
      final id = await _databaseProvider.createNotificationDetails(
        title: 'Reminder',
        body: 'upload files to storage',
        repeatInterval: 'daily',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _notificationDetailsId = id;
        _notificationTitleController.text = 'Reminder';
        _notificationBodyController.text = 'upload files to storage';
        _selectedRepeatInterval = 'daily';
      });
      return;
    }

    final first = allDetails.first;
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationDetailsId = first['id'] as int?;
      _notificationTitleController.text =
          (first['title'] as String?) ?? 'Reminder';
      _notificationBodyController.text =
          (first['body'] as String?) ?? 'upload files to storage';
      final dbInterval = (first['repeat_interval'] as String?)?.trim();
      _selectedRepeatInterval = _normalizeRepeatInterval(dbInterval);
    });
  }

  String _normalizeRepeatInterval(String? raw) {
    if (raw == null) {
      return 'daily';
    }
    final normalized = raw.trim().toLowerCase();
    if (_validRepeatIntervals.contains(normalized)) {
      return normalized;
    }
    return 'daily';
  }

  Future<void> _saveNotificationDetails() async {
    final title = _notificationTitleController.text.trim();
    final body = _notificationBodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      _showStatusDialog(
        title: 'Invalid Notification Details',
        message: 'Title and body are required.',
        dialogType: DialogType.warning,
      );
      return;
    }

    try {
      if (_notificationDetailsId == null) {
        final id = await _databaseProvider.createNotificationDetails(
          title: title,
          body: body,
          repeatInterval: _selectedRepeatInterval,
        );
        if (!mounted) {
          return;
        }
        setState(() {
          _notificationDetailsId = id;
        });
      } else {
        await _databaseProvider.updateNotificationDetails(
          notificationId: _notificationDetailsId!,
          title: title,
          body: body,
          repeatInterval: _selectedRepeatInterval,
        );
      }

      _showStatusDialog(
        title: 'Notification Details Saved',
        message: 'Notification title and body updated successfully.',
        dialogType: DialogType.success,
      );
    } catch (e) {
      _showStatusDialog(
        title: 'Save Failed',
        message: 'Unable to save notification details: $e',
        dialogType: DialogType.error,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _recordingsPathController = TextEditingController();
    _notificationTitleController = TextEditingController();
    _notificationBodyController = TextEditingController();
    _loadNotificationDetails();
    // _loadInitialDirectory();
  }

  @override
  void dispose() {
    _recordingsPathController.dispose();
    _notificationTitleController.dispose();
    _notificationBodyController.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationSettingsWidget(
                notificationTitleController: _notificationTitleController,
                notificationBodyController: _notificationBodyController,
                selectedRepeatInterval: _selectedRepeatInterval,
                onRepeatIntervalChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedRepeatInterval = _normalizeRepeatInterval(value);
                  });
                },
                onSaveNotificationDetails: _saveNotificationDetails,
              ),
              const Divider(height: 100, color: Colors.green, thickness: 1),
              RecordingPathSelector(
                recordingsPathController: _recordingsPathController,
                onOpenFolder: _openFolderSelector,
                onReturnToMain: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
