import 'package:cll_upld/pages/splash.dart';
import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/pages/about_us_page.dart';
import 'package:cll_upld/pages/recordings_page.dart';
import 'package:cll_upld/pages/settings_page.dart';
import 'package:cll_upld/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(localNotificationService: LocalNotificationService()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.localNotificationService});

  final LocalNotificationService localNotificationService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final granted = await widget.localNotificationService.initialize();
      if (granted) {
        await widget.localNotificationService.startUploadReminderEveryMinute();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const RecordingsPage(
          title: RecordingsRepositoryConstants.homeTitle,
        ),
        AppRoutes.about: (context) => const AboutUsPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
      },
    );
  }
}
