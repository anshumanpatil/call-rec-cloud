import 'package:flutter/material.dart';

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
              'Downloads Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('Refresh Downloads'),
            onTap: () {
              Navigator.pop(context);
              onRefresh();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              onAbout();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
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
