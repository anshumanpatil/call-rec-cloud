import 'package:cll_upld/services/database_provider.dart';
import 'dart:developer';

void databaseServiceUsageExample() async {
  // Initialize the database provider
  final dbProvider = DatabaseProvider();

  // ===================== SETTINGS OPERATIONS EXAMPLE =====================

  // Create a new settings record
  final settingId = await dbProvider.createSettings(
    isPathAvailable: false,
    recordingsPath: '/storage/emulated/0/Documents/Recordings',
  );
  log('Created settings with ID: $settingId');

  // Get settings by ID
  final settings = await dbProvider.getSettingsById(settingId);
  log('Settings data: $settings');

  // Get all settings records
  final allSettings = await dbProvider.getAllSettings();
  log('All settings: $allSettings');

  // Update settings
  await dbProvider.updateSettings(
    settingId: settingId,
    isPathAvailable: true,
    recordingsPath: '/storage/emulated/0/Downloads/Recordings',
  );
  log('Updated settings');

  // Delete settings
  await dbProvider.deleteSettings(settingId);
  log('Deleted settings');

  // ===================== CLEANUP =====================

  // Close database
  await dbProvider.closeDatabase();
  log('Database closed');
}
