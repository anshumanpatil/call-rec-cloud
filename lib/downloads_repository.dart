import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'downloads_constants.dart';

class DownloadsRepository {
  Future<bool> hasManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }

  Future<bool> requestManageExternalStoragePermission() async {
    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  Future<Directory?> getPlatformDownloadsDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
            DownloadsRepositoryConstants.downloadsDirectoryType,
          );
      return Directory(downloadsPath);
    }

    return await getDownloadsDirectory();
  }

  Future<List<FileSystemEntity>> listDownloads() async {
    final downloadsDir = await getPlatformDownloadsDirectory();

    if (downloadsDir == null) {
      throw Exception(
        DownloadsRepositoryConstants.unableToDetermineDownloadsFolder,
      );
    }

    if (!await downloadsDir.exists()) {
      throw Exception(
        '${DownloadsRepositoryConstants.downloadsFolderNotFound} ${downloadsDir.path}',
      );
    }

    return downloadsDir.listSync();
  }

  Future<List<FileSystemEntity>> fetchDownloads() async {
    return await listDownloads();
  }
}
