import 'dart:async';
import 'dart:io';

import 'package:docman/docman.dart';
import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/recordings_repository.dart';
import 'package:cll_upld/repositories/settings_repository.dart';
import 'package:cll_upld/pages/recordings_page.dart';
import 'package:cll_upld/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DownloadsRepository _repository = DownloadsRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<List<DocumentFile>> _ensurePermissionAndLoadDownloads() async {
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

    return await _repository.fetchDownloads();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    final savedPath = await _settingsRepository.getSavedRecordingsPath();
    if (!mounted) {
      return;
    }

    if (savedPath == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.settings);
      return;
    }

    try {
      final downloads = await _ensurePermissionAndLoadDownloads();
      final fileNames = downloads
          .where((document) => !document.isDirectory)
          .map((document) => document.name)
          .toList();

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RecordingsPage(
            title: RecordingsRepositoryConstants.homeTitle,
            initialFileNames: fileNames,
          ),
        ),
      );
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
