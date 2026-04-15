import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../services/database_provider.dart';

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

  Future<Directory?> getPlatformDownloadsDirectory() async {
    try {
      // Check if a recordings path is saved in the database
      final allSettings = await _databaseProvider.getAllSettings();
      if (allSettings.isNotEmpty) {
        final settings = allSettings.first;
        final isPathAvailable = settings['isPathAvailable'] == 1;
        final recordingsPath = settings['recordings_path'];

        if (isPathAvailable && recordingsPath != null && recordingsPath.isNotEmpty) {
          final dir = Directory(recordingsPath);
          if (await dir.exists()) {
            print('✓ Path retrieved from database: $recordingsPath');
            return dir;
          }
        }
      }
    } catch (e) {
      // If database lookup fails, fall back to default behavior
      print('Error fetching path from database: $e');
    }

    // Fall back to default behavior if no valid path in database
    String downloadsPath;
    if (Platform.isAndroid || Platform.isIOS) {
      downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
            RecordingsRepositoryConstants.downloadsDirectoryType,
          );
      print('✓ Path retrieved from ExternalPath: $downloadsPath');
    } else {
      final dir = await getDownloadsDirectory();
      if (dir == null) return null;
      downloadsPath = dir.path;
      print('✓ Path retrieved from getDownloadsDirectory: $downloadsPath');
    }

    // Save the path to database for future use
    try {
      final allSettings = await _databaseProvider.getAllSettings();
      if (allSettings.isEmpty) {
        // Create new settings record
        await _databaseProvider.createSettings(
          isPathAvailable: true,
          recordingsPath: downloadsPath,
        );
        print('✓ New settings created and path saved to database: $downloadsPath');
      } else {
        // Update existing settings record
        final settingId = allSettings.first['id'];
        await _databaseProvider.updateSettings(
          settingId: settingId,
          isPathAvailable: true,
          recordingsPath: downloadsPath,
        );
        print('✓ Existing settings updated with path: $downloadsPath');
      }
    } catch (e) {
      print('Error saving path to database: $e');
    }

    // await deleteAllSettings(); // Uncomment for testing

    print('✓ Final directory path being returned: $downloadsPath');
    return Directory(downloadsPath);
  }

  Future<List<FileSystemEntity>> listDownloads() async {
    final downloadsDir = await getPlatformDownloadsDirectory();

    if (downloadsDir == null) {
      throw Exception(
        RecordingsRepositoryConstants.unableToDetermineDownloadsFolder,
      );
    }

    if (!await downloadsDir.exists()) {
      throw Exception(
        '${RecordingsRepositoryConstants.downloadsFolderNotFound} ${downloadsDir.path}',
      );
    }

    return downloadsDir.listSync();
  }

  Future<List<FileSystemEntity>> fetchDownloads() async {
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
