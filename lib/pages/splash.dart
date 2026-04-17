import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/recordings_repository.dart';
import 'package:cll_upld/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DownloadsRepository _repository = DownloadsRepository();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _ensurePermissionAndLoadDownloads() async {
    if (Platform.isAndroid &&
        !await _repository.hasManageExternalStoragePermission()) {
      final granted = await _repository
          .requestManageExternalStoragePermission();
      if (!granted) {
        throw Exception(
          RecordingsRepositoryConstants.manageExternalStoragePermissionError,
        );
      }
    }

    await _repository.fetchDownloads();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    try {
      await _ensurePermissionAndLoadDownloads();
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = error.toString().replaceFirst('Exception: ', '');
      if (message == RecordingsRepositoryConstants.noPathSettingsFound) {
        Navigator.pushReplacementNamed(context, AppRoutes.settings);
        return;
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppStrings.splashBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: primaryColor.withValues(alpha: 0.75),
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: fixPadding * 4.0),
            children: [
              Center(
                child: Image.asset(
                  AppStrings.appLogoImage,
                  height: size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
