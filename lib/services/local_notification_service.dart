import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const int _uploadReminderId = 1001;
  static const int _testNotificationId = 1002;
  static const String _defaultNotificationTitle = 'Reminder';
  static const String _defaultNotificationBody = 'upload files to storage';
  static const String _defaultNotificationRepeatInterval = 'daily';
  static const String _channelId = 'upload_reminders_channel';
  static const String _channelName = 'Upload Reminders';
  static const String _channelDescription =
      'Periodic reminders to upload files to storage';

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

  static const DarwinNotificationDetails _darwinDetails =
      DarwinNotificationDetails();

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidDetails,
    iOS: _darwinDetails,
    macOS: _darwinDetails,
  );

  Future<bool> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings: initializationSettings);
    _isInitialized = true;
    return await _requestPermissions();
  }

  Future<bool> _requestPermissions() async {
    if (kIsWeb) {
      return false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return granted ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.macOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }

    return false;
  }

  Future<String> startUploadReminderEveryMinute() async {
    final log = StringBuffer('Periodic reminder diagnostic log:\n');

    if (!_isInitialized) {
      log.writeln('- Plugin not initialized. Initializing now...');
      final granted = await initialize();
      log.writeln('- Permission granted during init: $granted');
      if (!granted) {
        debugPrint(log.toString());
        return log.toString();
      }
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final enabled = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      log.writeln('- Android notifications enabled: ${enabled ?? false}');
      if (enabled == false) {
        debugPrint(log.toString());
        return log.toString();
      }
    }

    final content = await _getNotificationContent();
    log.writeln('- Reminder title: ${content.title}');
    log.writeln('- Reminder body: ${content.body}');
    log.writeln('- Reminder repeat interval: ${content.repeatInterval}');

    await _plugin.cancel(id: _uploadReminderId);
    log.writeln('- Cleared existing periodic reminder notification id.');

    await _plugin.periodicallyShow(
      id: _uploadReminderId,
      title: content.title,
      body: content.body,
      repeatInterval: _mapRepeatInterval(content.repeatInterval),
      notificationDetails: _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    final pendingCount = (await _plugin.pendingNotificationRequests()).length;
    log.writeln('- Periodic reminder scheduled successfully.');
    log.writeln('- Pending scheduled notifications: $pendingCount');

    debugPrint(log.toString());
    return log.toString();
  }

  Future<String> sendImmediateTestNotification() async {
    final log = StringBuffer('Notification diagnostic log:\n');

    if (!_isInitialized) {
      log.writeln('- Plugin not initialized. Initializing now...');
      final granted = await initialize();
      log.writeln('- Permission granted during init: $granted');
      if (!granted) {
        debugPrint(log.toString());
        return log.toString();
      }
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final enabled = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      log.writeln('- Android notifications enabled: ${enabled ?? false}');
      if (enabled == false) {
        debugPrint(log.toString());
        return log.toString();
      }
    }

    final content = await _getNotificationContent();
    log.writeln('- Test title: ${content.title}');
    log.writeln('- Test body: ${content.body}');

    await _plugin.cancel(id: _testNotificationId);
    await _plugin.show(
      id: _testNotificationId,
      title: content.title,
      body: content.body,
      notificationDetails: _notificationDetails,
    );

    final pendingCount = (await _plugin.pendingNotificationRequests()).length;
    log.writeln('- Immediate test notification posted successfully.');
    log.writeln('- Pending scheduled notifications: $pendingCount');

    debugPrint(log.toString());
    return log.toString();
  }

  Future<({String title, String body, String repeatInterval})>
  _getNotificationContent() async {
    return (
      title: _defaultNotificationTitle,
      body: _defaultNotificationBody,
      repeatInterval: _defaultNotificationRepeatInterval,
    );
  }

  RepeatInterval _mapRepeatInterval(String repeatInterval) {
    switch (repeatInterval) {
      case 'hourly':
        return RepeatInterval.hourly;
      case 'weekly':
        return RepeatInterval.weekly;
      case 'daily':
      default:
        return RepeatInterval.daily;
    }
  }
}
