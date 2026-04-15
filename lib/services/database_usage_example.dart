import 'package:cll_upld/services/database_provider.dart';

/// Example usage of DatabaseService and DatabaseProvider
///
/// This file demonstrates how to use the database service to perform
/// CRUD operations for settings (isPathAvailable, recordings_path)

void databaseServiceUsageExample() async {
  // Initialize the database provider
  final dbProvider = DatabaseProvider();

  // ===================== SETTINGS OPERATIONS EXAMPLE =====================

  // Create a new settings record
  final settingId = await dbProvider.createSettings(
    isPathAvailable: false,
    recordingsPath: '/storage/emulated/0/Documents/Recordings',
  );
  print('Created settings with ID: $settingId');

  // Get settings by ID
  final settings = await dbProvider.getSettingsById(settingId);
  print('Settings data: $settings');

  // Get all settings records
  final allSettings = await dbProvider.getAllSettings();
  print('All settings: $allSettings');

  // Update settings
  await dbProvider.updateSettings(
    settingId: settingId,
    isPathAvailable: true,
    recordingsPath: '/storage/emulated/0/Downloads/Recordings',
  );
  print('Updated settings');

  // Delete settings
  await dbProvider.deleteSettings(settingId);
  print('Deleted settings');

  // ===================== CLEANUP =====================

  // Close database
  await dbProvider.closeDatabase();
  print('Database closed');
}
