import 'package:external_path/external_path.dart';

class DownloadsRepositoryConstants {
  static const String downloadsDirectoryType = ExternalPath.DIRECTORY_DOWNLOAD;
  static const String unableToDetermineDownloadsFolder =
      'Unable to determine downloads folder.';
  static const String downloadsFolderNotFound = 'Downloads folder not found:';
  static const String manageExternalStoragePermissionError =
      'Manage external storage permission is required to access Downloads.';
}
