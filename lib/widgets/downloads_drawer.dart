import 'package:flutter/material.dart';
import 'package:cll_upld/constants.dart';

class DownloadsDrawer extends StatelessWidget {
  const DownloadsDrawer({
    super.key,
    required this.applicationName,
    required this.onRefresh,
    required this.onAbout,
    required this.onSettings,
  });

  final String applicationName;
  final VoidCallback onRefresh;
  final VoidCallback onAbout;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              AppStrings.downloadsMenuTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text(AppStrings.refreshDownloadsMenu),
            onTap: () {
              Navigator.pop(context);
              onRefresh();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.aboutMenu),
            onTap: () {
              Navigator.pop(context);
              onAbout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.settingsMenu),
            onTap: () {
              Navigator.pop(context);
              onSettings();
            },
          ),
        ],
      ),
    );
  }
}
