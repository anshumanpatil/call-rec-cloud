import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:docman/docman.dart';
import 'package:flutter/material.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/repositories/recordings_repository.dart';
import 'package:cll_upld/services/file_upload_service.dart';
import 'package:cll_upld/theme/theme.dart';
import 'package:cll_upld/widgets/downloads_drawer.dart';
import 'package:cll_upld/widgets/recordings_list.dart';

class RecordingsPage extends StatefulWidget {
  const RecordingsPage({super.key, required this.title});

  final String title;

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  static const String _apiBaseUrl = 'http://localhost:5656';
  static const String _defaultUploadFolder = 'mobile-recordings';

  final DownloadsRepository _repository = DownloadsRepository();
  final FileUploadService _uploadService = FileUploadService(
    baseUrl: _apiBaseUrl,
  );

  List<DocumentFile> recordings = [];
  List<bool> selectedItems = [];
  String? errorMessage;
  bool _isUploading = false;

  bool get allSelected =>
      selectedItems.isNotEmpty && selectedItems.every((element) => element);

  @override
  void initState() {
    super.initState();
    log('RecordingsPage initialized, fetching downloads...');
    _fetchAndSetDownloads();
  }

  void _showNoPathSettingsDialog() {
    if (!mounted) {
      return;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Path Settings Missing',
      desc:
          'No path settings found. Please open Settings and choose the recordings folder.',
      btnCancelText: 'Later',
      btnCancelOnPress: () {},
      btnOkText: 'Open Settings',
      btnOkOnPress: () {
        Navigator.pushNamed(context, AppRoutes.settings);
      },
    ).show();
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
      final message = error.toString().replaceFirst('Exception: ', '');

      setState(() {
        recordings = [];
        selectedItems = [];
        errorMessage = message;
      });

      if (message == RecordingsRepositoryConstants.noPathSettingsFound) {
        _showNoPathSettingsDialog();
      }
    }
  }

  void _toggleSelectAll() {
    setState(() {
      final selectAll = !allSelected;
      selectedItems = List.generate(recordings.length, (_) => selectAll);
    });
  }

  Future<void> _uploadSelectedRecordings() async {
    final selected = <DocumentFile>[];
    for (var i = 0; i < recordings.length; i++) {
      if (selectedItems[i] && !recordings[i].isDirectory) {
        selected.add(recordings[i]);
      }
    }

    if (selected.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one file to upload.'),
        ),
      );
      return;
    }

    var uploadedCount = 0;
    var skippedCount = 0;
    var deletedCount = 0;
    var deleteFailedCount = 0;

    setState(() {
      _isUploading = true;
    });

    try {
      for (final document in selected) {
        final bytes = await document.read();
        if (bytes == null || bytes.isEmpty) {
          skippedCount++;
          continue;
        }

        await _uploadService.uploadBytes(
          folderName: _defaultUploadFolder,
          fileName: document.name,
          bytes: bytes,
        );
        uploadedCount++;

        final deleted = await document.delete();
        if (deleted) {
          deletedCount++;
        } else {
          deleteFailedCount++;
        }
      }

      if (!mounted) {
        return;
      }

      if (uploadedCount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Selected items are not accessible as readable files for upload.',
            ),
          ),
        );
        return;
      }

      final summary = skippedCount > 0
          ? 'Uploaded $uploadedCount file(s), deleted $deletedCount file(s), skipped $skippedCount unreadable item(s).'
          : 'Uploaded $uploadedCount file(s), deleted $deletedCount file(s).';

      final summaryWithDeleteInfo = deleteFailedCount > 0
          ? '$summary Could not delete $deleteFailedCount uploaded file(s).'
          : summary;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(summaryWithDeleteInfo)));

      await _fetchAndSetDownloads();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightPurpleColor,
        title: Text(widget.title),
      ),
      drawer: DownloadsDrawer(
        applicationName: widget.title,
        onRefresh: _fetchAndSetDownloads,
        onAbout: () {
          Navigator.pushNamed(context, AppRoutes.about);
        },
        onSettings: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _isUploading ? null : _uploadSelectedRecordings,
                child: Text(
                  _isUploading ? 'Uploading...' : AppStrings.uploadButton,
                ),
              ),
            ),
          ),
          Expanded(
            child: errorMessage != null
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAndSetDownloads,
        tooltip: AppStrings.refreshTooltip,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
