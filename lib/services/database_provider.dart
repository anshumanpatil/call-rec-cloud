import 'database_service.dart';

class DatabaseProvider {
  final DatabaseService _databaseService = DatabaseService();

  // ===================== SETTINGS OPERATIONS =====================

  Future<int> createSettings({
    bool isPathAvailable = false,
    String? recordingsPath,
  }) async {
    return await _databaseService.insert('settings', {
      'isPathAvailable': isPathAvailable ? 1 : 0,
      'recordings_path': recordingsPath,
    });
  }

  Future<Map<String, dynamic>?> getSettingsById(int settingId) async {
    return await _databaseService.queryOne(
      'settings',
      where: 'id = ?',
      whereArgs: [settingId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllSettings() async {
    return await _databaseService.query('settings');
  }

  Future<int> updateSettings({
    required int settingId,
    bool? isPathAvailable,
    String? recordingsPath,
  }) async {
    final data = <String, dynamic>{};
    if (isPathAvailable != null) {
      data['isPathAvailable'] = isPathAvailable ? 1 : 0;
    }
    if (recordingsPath != null) {
      data['recordings_path'] = recordingsPath;
    }

    return await _databaseService.update(
      'settings',
      data,
      where: 'id = ?',
      whereArgs: [settingId],
    );
  }

  Future<int> deleteSettings(int settingId) async {
    return await _databaseService.delete(
      'settings',
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
