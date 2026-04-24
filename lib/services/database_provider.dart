import 'database_service.dart';
import 'database_constants.dart';

class DatabaseProvider {
  final DatabaseService _databaseService = DatabaseService();

  // ===================== SETTINGS OPERATIONS =====================

  Future<int> createSettings({
    bool isPathAvailable = false,
    String? recordingsPath,
  }) async {
    return await _databaseService.insert(DatabaseConstants.settingsTable, {
      DatabaseConstants.settingIsPathAvailable: isPathAvailable ? 1 : 0,
      DatabaseConstants.settingRecordingsPath: recordingsPath,
    });
  }

  Future<Map<String, dynamic>?> getSettingsById(int settingId) async {
    return await _databaseService.queryOne(
      DatabaseConstants.settingsTable,
      where: 'id = ?',
      whereArgs: [settingId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllSettings() async {
    return await _databaseService.query(DatabaseConstants.settingsTable);
  }

  Future<int> updateSettings({
    required int settingId,
    bool? isPathAvailable,
    String? recordingsPath,
  }) async {
    final data = <String, dynamic>{};
    if (isPathAvailable != null) {
      data[DatabaseConstants.settingIsPathAvailable] = isPathAvailable ? 1 : 0;
    }
    if (recordingsPath != null) {
      data[DatabaseConstants.settingRecordingsPath] = recordingsPath;
    }

    return await _databaseService.update(
      DatabaseConstants.settingsTable,
      data,
      where: 'id = ?',
      whereArgs: [settingId],
    );
  }

  Future<int> deleteSettings(int settingId) async {
    return await _databaseService.delete(
      DatabaseConstants.settingsTable,
      where: 'id = ?',
      whereArgs: [settingId],
    );
  }

  // ===================== UTILITY OPERATIONS =====================

  Future<void> clearDatabase() async {
    await _databaseService.clearAllTables();
  }

  Future<void> closeDatabase() async {
    await _databaseService.close();
  }
}
