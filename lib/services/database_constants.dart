class DatabaseConstants {
  // Database name
  static const String databaseName = 'cll_upld.db';
  static const int databaseVersion = 3;

  // Table names
  static const String settingsTable = 'settings';
  static const String notificationDetailsTable = 'notificationDetails';

  // Settings table columns
  static const String settingId = 'id';
  static const String settingIsPathAvailable = 'isPathAvailable';
  static const String settingRecordingsPath = 'recordings_path';

  // Notification details table columns
  static const String notificationId = 'id';
  static const String notificationTitle = 'title';
  static const String notificationBody = 'body';
  static const String notificationRepeatInterval = 'repeat_interval';

  // Notification repeat interval values
  static const String repeatIntervalHourly = 'hourly';
  static const String repeatIntervalDaily = 'daily';
  static const String repeatIntervalWeekly = 'weekly';
}
