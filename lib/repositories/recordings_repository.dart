import 'package:docman/docman.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/services/database_provider.dart';

class DownloadsRepository {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<bool> hasManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  Future<bool> requestManageExternalStoragePermission() async {
    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  Future<DocumentFile?> getPlatformDownloadsDirectory() async {
    try {
      final allSettings = await _databaseProvider.getAllSettings();
      if (allSettings.isEmpty) {
        throw Exception(RecordingsRepositoryConstants.noPathSettingsFound);
      }

      final settings = allSettings.first;
      final isPathAvailable = settings['isPathAvailable'] == 1;
      final recordingsPath = settings['recordings_path'];

      if (!isPathAvailable ||
          recordingsPath == null ||
          recordingsPath.isEmpty) {
        throw Exception(RecordingsRepositoryConstants.noPathSettingsFound);
      }
      print('✓ Recordings path from database: $recordingsPath');
      final directory = await DocumentFile(uri: recordingsPath).get();
      if (directory != null && directory.exists && directory.isDirectory) {
        return directory;
      }

      throw Exception(
        '${RecordingsRepositoryConstants.downloadsFolderNotFound} $recordingsPath',
      );
    } catch (e) {
      if (e.toString().contains(
        RecordingsRepositoryConstants.noPathSettingsFound,
      )) {
        rethrow;
      }

      throw Exception(
        RecordingsRepositoryConstants.unableToDetermineDownloadsFolder,
      );
    }
  }

  Future<List<DocumentFile>> listDownloads() async {
    final downloadsDir = await getPlatformDownloadsDirectory();

    if (downloadsDir == null) {
      throw Exception(
        RecordingsRepositoryConstants.unableToDetermineDownloadsFolder,
      );
    }

    if (!downloadsDir.exists || !downloadsDir.isDirectory) {
      throw Exception(
        '${RecordingsRepositoryConstants.downloadsFolderNotFound} ${downloadsDir.uri}',
      );
    }

    return downloadsDir.listDocuments();
  }

  Future<List<DocumentFile>> fetchDownloads() async {
    return await listDownloads();
  }

  // ===================== TESTING UTILITIES =====================

  /// Delete all settings from database for testing purposes
  /*
  Future<void> deleteAllSettings() async {
    try {
      final allSettings = await _databaseProvider.getAllSettings();
      for (final setting in allSettings) {
        final settingId = setting['id'];
        await _databaseProvider.deleteSettings(settingId);
      }
      print('All settings deleted for testing');
    } catch (e) {
      print('Error deleting settings: $e');
    }
  }
  */
}
