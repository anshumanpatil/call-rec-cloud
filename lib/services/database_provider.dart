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

  // ===================== NOTIFICATION DETAILS OPERATIONS =====================

  Future<int> createNotificationDetails({
    required String title,
    required String body,
    String repeatInterval = DatabaseConstants.repeatIntervalDaily,
  }) async {
    return await _databaseService
        .insert(DatabaseConstants.notificationDetailsTable, {
          DatabaseConstants.notificationTitle: title,
          DatabaseConstants.notificationBody: body,
          DatabaseConstants.notificationRepeatInterval: repeatInterval,
        });
  }

  Future<Map<String, dynamic>?> getNotificationDetailsById(
    int notificationId,
  ) async {
    return await _databaseService.queryOne(
      DatabaseConstants.notificationDetailsTable,
      where: '${DatabaseConstants.notificationId} = ?',
      whereArgs: [notificationId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotificationDetails() async {
    return await _databaseService.query(
      DatabaseConstants.notificationDetailsTable,
      orderBy: '${DatabaseConstants.notificationId} ASC',
    );
  }

  Future<int> updateNotificationDetails({
    required int notificationId,
    String? title,
    String? body,
    String? repeatInterval,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) {
      data[DatabaseConstants.notificationTitle] = title;
    }
    if (body != null) {
      data[DatabaseConstants.notificationBody] = body;
    }
    if (repeatInterval != null) {
      data[DatabaseConstants.notificationRepeatInterval] = repeatInterval;
    }

    if (data.isEmpty) {
      return 0;
    }

    return await _databaseService.update(
      DatabaseConstants.notificationDetailsTable,
      data,
      where: '${DatabaseConstants.notificationId} = ?',
      whereArgs: [notificationId],
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
