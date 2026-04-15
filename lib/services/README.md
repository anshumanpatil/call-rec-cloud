# Database Service Documentation

This database service provides a lightweight solution for local data storage in the CLL Upload app using SQLite.

## Overview

The database service consists of three main components:

1. **DatabaseService** - Low-level SQLite operations
2. **DatabaseProvider** - High-level API for settings management
3. **DatabaseConstants** - Database schema constants

## Installation

The project uses SQLite with the `sqflite` package. Dependencies are already added to `pubspec.yaml`:

```yaml
sqflite: ^2.3.0
sqlite3: ^3.0.0
```

## Quick Start

### Initialize the Database

```dart
import 'package:cll_upld/services/database_provider.dart';

final dbProvider = DatabaseProvider();
```

The database is automatically initialized on first access and uses a singleton pattern.

## Usage Examples

### Settings Management

```dart
// Create a settings record
final settingId = await dbProvider.createSettings(
  isPathAvailable: false,
  recordingsPath: '/storage/emulated/0/Documents/Recordings',
);

// Get settings by ID
final settings = await dbProvider.getSettingsById(settingId);

// Get all settings records
final allSettings = await dbProvider.getAllSettings();

// Update settings
await dbProvider.updateSettings(
  settingId: settingId,
  isPathAvailable: true,
  recordingsPath: '/storage/emulated/0/Downloads/Recordings',
);

// Delete settings
await dbProvider.deleteSettings(settingId);
```

## Database Schema

### Settings Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| isPathAvailable | INTEGER | Path availability flag (0/1) |
| recordings_path | TEXT | Path to recordings directory |

## Advanced Usage

### Direct Database Access

For complex queries, you can access the DatabaseService directly:

```dart
import 'package:cll_upld/services/database_service.dart';

final dbService = DatabaseService();

// Raw SQL queries
final results = await dbService.rawQuery(
  'SELECT * FROM settings WHERE isPathAvailable = ?',
  [1]
);

// Custom queries with parameters
final settings = await dbService.query(
  'settings',
  where: 'isPathAvailable = ?',
  whereArgs: [1],
  limit: 10,
);
```

### Cleanup Operations

```dart
// Clear all tables
await dbProvider.clearDatabase();

// Close database connection
await dbProvider.closeDatabase();
```

## Performance Tips

1. **Use Indexed Lookups**: The database auto-increments IDs and uses them for lookups
2. **Proper Error Handling**: Always wrap database operations in try-catch blocks
3. **Close Connection**: Call `closeDatabase()` when the app exits to prevent file locks

## Integration with Existing Code

The database service integrates seamlessly with the existing repository pattern:

```dart
// In your repository
class SettingsRepository {
  final _dbProvider = DatabaseProvider();

  Future<Settings> fetchSettings() async {
    final data = await _dbProvider.getAllSettings();
    return data.isNotEmpty ? Settings.fromJson(data.first) : Settings.defaultSettings();
  }

  Future<void> saveSettings(Settings settings) async {
    await _dbProvider.updateSettings(
      settingId: settings.id,
      isPathAvailable: settings.isPathAvailable,
      recordingsPath: settings.recordingsPath,
    );
  }
}
```

## Troubleshooting

### Database Not Persisting
- Ensure proper app lifecycle management
- Call `closeDatabase()` when the app exits
- Check file permissions on target platform

### Query Returns No Results
- Verify data exists using the database tools
- Check the exact column names against `DatabaseConstants`
- Ensure proper parameter binding in WHERE clauses

### Performance Issues
- Add database indexes for frequently queried columns
- Profile with the Flutter DevTools

## Files

- `lib/services/database_service.dart` - Main database service
- `lib/services/database_provider.dart` - High-level API
- `lib/services/database_constants.dart` - Constants and schema definitions
- `lib/services/database_usage_example.dart` - Usage examples

```yaml
sqflite: ^2.3.0
sqlite3: ^3.0.0
```

## Quick Start

### Initialize the Database

```dart
import 'package:cll_upld/services/database_provider.dart';

final dbProvider = DatabaseProvider();
```

The database is automatically initialized on first access and uses a singleton pattern.

## Usage Examples

### User Management

```dart
// Create a user
final userId = await dbProvider.createUser(
  name: 'John Doe',
  email: 'john@example.com',
  imageUrl: 'assets/images/users/john.png',
);

// Get user by ID
final user = await dbProvider.getUserById(userId);

// Get user by email
final user = await dbProvider.getUserByEmail('john@example.com');

// Get all users
final users = await dbProvider.getAllUsers();

// Update user
await dbProvider.updateUser(
  userId: userId,
  name: 'Jane Doe',
);

// Delete user
await dbProvider.deleteUser(userId);
```

### Recording Management

```dart
// Create a recording
final recordingId = await dbProvider.createRecording(
  userId: userId,
  title: 'Workout Session 1',
  filePath: '/path/to/recording.mp4',
  durationSeconds: 3600,
  fileSizeBytes: 500000000,
);

// Get recording by ID
final recording = await dbProvider.getRecordingById(recordingId);

// Get all recordings for a user
final recordings = await dbProvider.getRecordingsByUserId(userId);

// Get all recordings
final allRecordings = await dbProvider.getAllRecordings();

// Update recording
await dbProvider.updateRecording(
  recordingId: recordingId,
  title: 'Updated Session',
  durationSeconds: 3700,
);

// Delete recording
await dbProvider.deleteRecording(recordingId);
```

### Workout Management

```dart
// Create a workout
final workoutId = await dbProvider.createWorkout(
  userId: userId,
  title: 'Full Body Workout',
  description: 'A comprehensive full body workout',
  durationMinutes: 60,
  category: 'strength',
);

// Get workout by ID
final workout = await dbProvider.getWorkoutById(workoutId);

// Get workouts for a user
final workouts = await dbProvider.getWorkoutsByUserId(userId);

// Get all workouts
final allWorkouts = await dbProvider.getAllWorkouts();

// Update workout
await dbProvider.updateWorkout(
  workoutId: workoutId,
  title: 'Advanced Workout',
  durationMinutes: 75,
);

// Delete workout
await dbProvider.deleteWorkout(workoutId);
```

### Settings Management

```dart
// Create settings
await dbProvider.createSettings(
  userId: userId,
  theme: 'dark',
  notificationsEnabled: true,
  language: 'en',
);

// Get settings for a user
final settings = await dbProvider.getSettingsByUserId(userId);

// Update settings
await dbProvider.updateSettings(
  userId: userId,
  theme: 'light',
  language: 'es',
);

// Delete settings
await dbProvider.deleteSettings(userId);
```

## Database Schema

### Users Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| name | TEXT | User's name |
| email | TEXT | User's email (unique) |
| image_url | TEXT | Profile image URL |
| created_at | TEXT | Creation timestamp |
| updated_at | TEXT | Last update timestamp |

### Recordings Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| user_id | INTEGER | Foreign key to users |
| title | TEXT | Recording title |
| file_path | TEXT | Path to recording file |
| duration_seconds | INTEGER | Duration in seconds |
| file_size_bytes | INTEGER | File size in bytes |
| created_at | TEXT | Creation timestamp |
| updated_at | TEXT | Last update timestamp |

### Workouts Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| user_id | INTEGER | Foreign key to users |
| title | TEXT | Workout title |
| description | TEXT | Workout description |
| duration_minutes | INTEGER | Duration in minutes |
| category | TEXT | Workout category |
| created_at | TEXT | Creation timestamp |
| updated_at | TEXT | Last update timestamp |

### Settings Table

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key (auto-increment) |
| user_id | INTEGER | Foreign key to users |
| theme | TEXT | Theme preference (light/dark) |
| notifications_enabled | INTEGER | Notifications enabled (0/1) |
| language | TEXT | Language preference |
| updated_at | TEXT | Last update timestamp |

## Advanced Usage

### Direct Database Access

For complex queries, you can access the DatabaseService directly:

```dart
import 'package:cll_upld/services/database_service.dart';

final dbService = DatabaseService();

// Raw SQL queries
final results = await dbService.rawQuery(
  'SELECT * FROM recordings WHERE duration_seconds > ?',
  [3600]
);

// Custom queries with parameters
final recordings = await dbService.query(
  'recordings',
  where: 'duration_seconds > ? AND user_id = ?',
  whereArgs: [3600, userId],
  orderBy: 'created_at DESC',
  limit: 10,
);
```

### Cleanup Operations

```dart
// Clear all tables
await dbProvider.clearDatabase();

// Close database connection
await dbProvider.closeDatabase();
```

## Performance Tips

1. **Use Indexed Lookups**: The database auto-increments IDs and uses them for lookups
2. **Batch Operations**: For multiple inserts/updates, consider using transactions
3. **Query Limits**: Use `limit` parameter for large result sets
4. **Proper Error Handling**: Always wrap database operations in try-catch blocks

## Integration with Existing Code

The database service integrates seamlessly with the existing repository pattern:

```dart
// In your repository
class RecordingsRepository {
  final _dbProvider = DatabaseProvider();

  Future<List<Recording>> fetchRecordings(int userId) async {
    final data = await _dbProvider.getRecordingsByUserId(userId);
    return data.map((item) => Recording.fromJson(item)).toList();
  }

  Future<void> saveRecording(Recording recording) async {
    await _dbProvider.createRecording(
      userId: recording.userId,
      title: recording.title,
      filePath: recording.filePath,
      durationSeconds: recording.durationSeconds,
      fileSizeBytes: recording.fileSizeBytes,
    );
  }
}
```

## Troubleshooting

### Database Not Persisting
- Ensure proper app lifecycle management
- Call `closeDatabase()` when the app exits
- Check file permissions on target platform

### Query Returns No Results
- Verify data exists using the database tools
- Check the exact column names against `DatabaseConstants`
- Ensure proper parameter binding in WHERE clauses

### Performance Issues
- Add database indexes for frequently queried columns
- Use pagination with `limit` and `offset`
- Profile with the Flutter DevTools

## Files

- `lib/services/database_service.dart` - Main database service
- `lib/services/database_provider.dart` - High-level API
- `lib/services/database_constants.dart` - Constants and schema definitions
- `lib/services/database_usage_example.dart` - Usage examples
