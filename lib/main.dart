import 'package:cll_upld/widgets/splash.dart';
import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/pages/about_us_page.dart';
import 'package:cll_upld/pages/recordings_page.dart';
import 'package:cll_upld/pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp widget...');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) =>
            const RecordingsPage(title: RecordingsRepositoryConstants.homeTitle  ),
        AppRoutes.about: (context) => const AboutUsPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
      },
    );
  }
}
