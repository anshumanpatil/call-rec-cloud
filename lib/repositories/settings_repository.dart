import 'package:docman/docman.dart';

import '../services/database_provider.dart';

class SettingsRepository {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  Future<DocumentFile?> pickDirectory({String? initialTreeUri}) async {
    return await DocMan.pick.directory(initDir: initialTreeUri);
  }

  Future<void> saveSelectedPath(String selectedPath) async {
    final allSettings = await _databaseProvider.getAllSettings();
    if (allSettings.isEmpty) {
      await _databaseProvider.createSettings(
        isPathAvailable: true,
        recordingsPath: selectedPath,
      );
      return;
    }

    final settingId = allSettings.first['id'] as int;
    await _databaseProvider.updateSettings(
      settingId: settingId,
      isPathAvailable: true,
      recordingsPath: selectedPath,
    );
  }

  Future<String?> getSavedRecordingsPath() async {
    final allSettings = await _databaseProvider.getAllSettings();
    if (allSettings.isEmpty) {
      return null;
    }

    final path = allSettings.first['recordings_path'] as String?;
    if (path == null || path.trim().isEmpty) {
      return null;
    }

    return path.trim();
  }
}
