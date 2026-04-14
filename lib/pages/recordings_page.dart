import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/recordings_repository.dart';
import 'package:cll_upld/widgets/downloads_drawer.dart';
import 'package:cll_upld/widgets/recordings_list.dart';

class RecordingsPage extends StatefulWidget {
  const RecordingsPage({super.key, required this.title});

  final String title;

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  final DownloadsRepository _repository = DownloadsRepository();
  List<FileSystemEntity> recordings = [];
  List<bool> selectedItems = [];
  String? errorMessage;

  bool get allSelected =>
      selectedItems.isNotEmpty && selectedItems.every((element) => element);

  @override
  void initState() {
    super.initState();
    print('Initializing app and checking permissions...');
    _ensurePermissionAndLoadDownloads();
  }

  Future<void> _ensurePermissionAndLoadDownloads() async {
    if (Platform.isAndroid &&
        !await _repository.hasManageExternalStoragePermission()) {
      final granted = await _repository
          .requestManageExternalStoragePermission();
      if (!granted) {
        _setPermissionError(
          RecordingsRepositoryConstants.manageExternalStoragePermissionError,
        );
        return;
      }
    }

    print('Permission granted, loading recordings...');
    await _fetchAndSetDownloads();
  }

  void _setPermissionError(String message) {
    setState(() {
      recordings = [];
      selectedItems = [];
      errorMessage = message;
    });
  }

  Future<void> _fetchAndSetDownloads() async {
    try {
      final entities = await _repository.fetchDownloads();
      setState(() {
        recordings = entities;
        selectedItems = List.generate(entities.length, (_) => false);
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        recordings = [];
        selectedItems = [];
        errorMessage = error.toString();
      });
    }
  }

  void _toggleSelectAll() {
    setState(() {
      final selectAll = !allSelected;
      selectedItems = List.generate(recordings.length, (_) => selectAll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: DownloadsDrawer(
        applicationName: widget.title,
        onRefresh: _ensurePermissionAndLoadDownloads,
        onAbout: () {
          Navigator.pushNamed(context, AppRoutes.about);
        },
        onSettings: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : recordings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RecordingsListView(
              recordings: recordings,
              selectedItems: selectedItems,
              allSelected: allSelected,
              onToggleSelectAll: _toggleSelectAll,
              onSelectedChanged: (fileIndex) {
                setState(() {
                  selectedItems[fileIndex] = !selectedItems[fileIndex];
                });
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ensurePermissionAndLoadDownloads,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
