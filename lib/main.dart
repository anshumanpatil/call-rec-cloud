import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FileSystemEntity> downloads = [];
  List<bool> selectedItems = [];
  String? errorMessage;

  bool get allSelected => selectedItems.isNotEmpty && selectedItems.every((element) => element);

  @override
  void initState() {
    super.initState();
    _ensurePermissionAndLoadDownloads();
  }

  Future<void> _ensurePermissionAndLoadDownloads() async {
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        final result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          setState(() {
            downloads = [];
            selectedItems = [];
            errorMessage =
                'Manage external storage permission is required to access Downloads.';
          });
          return;
        }
      }
    }

    await _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    try {
      Directory? downloadsDir;

      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        downloadsDir = await getDownloadsDirectory();
      } else if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          downloadsDir = Directory('${externalDir.path}${Platform.pathSeparator}Download');
        }
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Unable to determine downloads folder.');
      }

      if (!await downloadsDir.exists()) {
        throw Exception('Downloads folder not found: ${downloadsDir.path}');
      }

      final entities = downloadsDir.listSync();
      setState(() {
        downloads = entities;
        selectedItems = List.generate(entities.length, (_) => false);
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        downloads = [];
        selectedItems = [];
        errorMessage = error.toString();
      });
    }
  }

  void _toggleSelectAll() {
    setState(() {
      final selectAll = !allSelected;
      selectedItems = List.generate(downloads.length, (_) => selectAll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: errorMessage != null
          ? Center(child: Text(errorMessage!))
          : downloads.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: downloads.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CheckboxListTile(
                        title: const Text('Select All'),
                        value: allSelected,
                        onChanged: (bool? value) {
                          _toggleSelectAll();
                        },
                      );
                    }

                    final fileIndex = index - 1;
                    final file = downloads[fileIndex];
                    final fileName = file.path.split(Platform.pathSeparator).last;
                    final icon = file is Directory ? Icons.folder : Icons.insert_drive_file;

                    return CheckboxListTile(
                      title: Text(fileName),
                      secondary: Icon(icon),
                      value: selectedItems[fileIndex],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedItems[fileIndex] = value ?? false;
                        });
                      },
                    );
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
