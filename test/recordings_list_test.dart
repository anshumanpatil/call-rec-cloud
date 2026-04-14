import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cll_upld/widgets/recordings_list.dart';

void main() {
  group('RecordingsListView Tests', () {
    testWidgets('RecordingsListView renders with minimal parameters',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(RecordingsListView), findsOneWidget);
    });

    testWidgets('RecordingsListView displays as ListView',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('RecordingsListView displays Select All checkbox',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select All'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsWidgets);
    });

    testWidgets('RecordingsListView displays file items',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('test.txt'), findsOneWidget);
    });

    testWidgets('RecordingsListView shows file icon for files',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
    });

    testWidgets('RecordingsListView shows folder icon for directories',
        (WidgetTester tester) async {
      // Create a mock directory
      final mockDir = Directory('/test_dir');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockDir],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('RecordingsListView calls onToggleSelectAll when clicking Select All',
        (WidgetTester tester) async {
      int toggleSelectAllCount = 0;
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () => toggleSelectAllCount++,
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      // Find and tap the Select All checkbox
      final checkboxes = find.byType(CheckboxListTile);
      await tester.tap(checkboxes.first);
      await tester.pumpAndSettle();

      expect(toggleSelectAllCount, 1);
    });

    testWidgets('RecordingsListView calls onSelectedChanged when selecting file',
        (WidgetTester tester) async {
      int selectedFileIndex = -1;
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (index) => selectedFileIndex = index,
            ),
          ),
        ),
      );

      // Find and tap the file checkbox
      final checkboxes = find.byType(CheckboxListTile);
      await tester.tap(checkboxes.at(1)); // Second checkbox is the file
      await tester.pumpAndSettle();

      expect(selectedFileIndex, 0);
    });

    testWidgets('RecordingsListView Select All checkbox state reflects allSelected',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [true],
              allSelected: true,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      // The Select All checkbox should be checked
      final checkboxes = find.byType(CheckboxListTile);
      final selectAllCheckbox =
          tester.widget<CheckboxListTile>(checkboxes.first);
      expect(selectAllCheckbox.value, isTrue);
    });

    testWidgets('RecordingsListView file checkbox reflects selectedItems',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [true],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      // The file checkbox should be checked
      final checkboxes = find.byType(CheckboxListTile);
      final fileCheckbox = tester.widget<CheckboxListTile>(checkboxes.at(1));
      expect(fileCheckbox.value, isTrue);
    });

    testWidgets('RecordingsListView handles multiple files',
        (WidgetTester tester) async {
      final file1 = File('/file1.txt');
      final file2 = File('/file2.txt');
      final file3 = File('/file3.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [file1, file2, file3],
              selectedItems: [false, true, false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('file1.txt'), findsOneWidget);
      expect(find.text('file2.txt'), findsOneWidget);
      expect(find.text('file3.txt'), findsOneWidget);

      final checkboxes = find.byType(CheckboxListTile);
      // +1 because first one is Select All
      expect(checkboxes, findsWidgets);
    });

    testWidgets('RecordingsListView extracts filename correctly from path',
        (WidgetTester tester) async {
      final mockFile = File('/path/to/nested/file.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [mockFile],
              selectedItems: [false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('file.txt'), findsOneWidget);
    });

    testWidgets('RecordingsListView with empty list shows Select All only',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [],
              selectedItems: [],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select All'), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file), findsNothing);
      expect(find.byIcon(Icons.folder), findsNothing);
    });

    testWidgets('RecordingsListView checkbox callbacks work correctly',
        (WidgetTester tester) async {
      int fileSelectedCount = 0;
      final file1 = File('/file1.txt');
      final file2 = File('/file2.txt');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingsListView(
              recordings: [file1, file2],
              selectedItems: [false, false],
              allSelected: false,
              onToggleSelectAll: () {},
              onSelectedChanged: (index) => fileSelectedCount++,
            ),
          ),
        ),
      );

      final checkboxes = find.byType(CheckboxListTile);

      // Click first file
      await tester.tap(checkboxes.at(1));
      await tester.pumpAndSettle();

      // Click second file
      await tester.tap(checkboxes.at(2));
      await tester.pumpAndSettle();

      expect(fileSelectedCount, 2);
    });

    testWidgets('RecordingsListView is a StatelessWidget',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');
      final widget = RecordingsListView(
        recordings: [mockFile],
        selectedItems: [false],
        allSelected: false,
        onToggleSelectAll: () {},
        onSelectedChanged: (_) {},
      );

      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('RecordingsListView has required parameters',
        (WidgetTester tester) async {
      final mockFile = File('/test.txt');

      // Verify that creating the widget with all required parameters works
      final widget = RecordingsListView(
        recordings: [mockFile],
        selectedItems: [false],
        allSelected: false,
        onToggleSelectAll: () {},
        onSelectedChanged: (_) {},
      );

      expect(widget.recordings, isNotNull);
      expect(widget.selectedItems, isNotNull);
      expect(widget.allSelected, isNotNull);
      expect(widget.onToggleSelectAll, isNotNull);
      expect(widget.onSelectedChanged, isNotNull);
    });
  });
}
