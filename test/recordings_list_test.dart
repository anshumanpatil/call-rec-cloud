import 'package:docman/docman.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cll_upld/constants.dart';
import 'package:cll_upld/widgets/recordings_list.dart';

DocumentFile _file(String name) {
  return DocumentFile(
    uri: 'content://com.example.documents/$name',
    name: name,
    type: 'audio/mpeg',
    exists: true,
    canRead: true,
  );
}

DocumentFile _directory(String name) {
  return DocumentFile(
    uri: 'content://com.example.documents/$name',
    name: name,
    type: 'directory',
    exists: true,
    canRead: true,
  );
}

Widget _buildTestWidget({
  required List<DocumentFile> recordings,
  required List<bool> selectedItems,
  required bool allSelected,
  required VoidCallback onToggleSelectAll,
  required ValueChanged<int> onSelectedChanged,
}) {
  return MaterialApp(
    home: Scaffold(
      body: RecordingsListView(
        recordings: recordings,
        selectedItems: selectedItems,
        allSelected: allSelected,
        onToggleSelectAll: onToggleSelectAll,
        onSelectedChanged: onSelectedChanged,
      ),
    ),
  );
}

void main() {
  group('RecordingsListView', () {
    testWidgets('renders list and select all row', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          recordings: [_file('test.mp3')],
          selectedItems: const [false],
          allSelected: false,
          onToggleSelectAll: () {},
          onSelectedChanged: (_) {},
        ),
      );

      expect(find.byType(RecordingsListView), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text(AppStrings.selectAllLabel), findsOneWidget);
      expect(find.text('test.mp3'), findsOneWidget);
    });

    testWidgets('shows file and folder icons based on item type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(
          recordings: [_file('audio.mp3'), _directory('calls')],
          selectedItems: const [false, false],
          allSelected: false,
          onToggleSelectAll: () {},
          onSelectedChanged: (_) {},
        ),
      );

      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('calls onToggleSelectAll when tapping select all checkbox', (
      WidgetTester tester,
    ) async {
      var called = 0;

      await tester.pumpWidget(
        _buildTestWidget(
          recordings: [_file('test.mp3')],
          selectedItems: const [false],
          allSelected: false,
          onToggleSelectAll: () => called++,
          onSelectedChanged: (_) {},
        ),
      );

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();

      expect(called, 1);
    });

    testWidgets('calls onSelectedChanged with correct index', (
      WidgetTester tester,
    ) async {
      var selectedIndex = -1;

      await tester.pumpWidget(
        _buildTestWidget(
          recordings: [_file('one.mp3'), _file('two.mp3')],
          selectedItems: const [false, false],
          allSelected: false,
          onToggleSelectAll: () {},
          onSelectedChanged: (int index) {
            selectedIndex = index;
          },
        ),
      );

      await tester.tap(find.byType(CheckboxListTile).at(1));
      await tester.pumpAndSettle();

      expect(selectedIndex, 0);
    });

    testWidgets('checkbox state reflects allSelected and selectedItems', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(
          recordings: [_file('test.mp3')],
          selectedItems: const [true],
          allSelected: true,
          onToggleSelectAll: () {},
          onSelectedChanged: (_) {},
        ),
      );

      final tiles = find.byType(CheckboxListTile);
      final selectAllTile = tester.widget<CheckboxListTile>(tiles.first);
      final itemTile = tester.widget<CheckboxListTile>(tiles.at(1));

      expect(selectAllTile.value, isTrue);
      expect(itemTile.value, isTrue);
    });

    testWidgets('supports empty recordings list', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          recordings: const <DocumentFile>[],
          selectedItems: const <bool>[],
          allSelected: false,
          onToggleSelectAll: () {},
          onSelectedChanged: (_) {},
        ),
      );

      expect(find.text(AppStrings.selectAllLabel), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file), findsNothing);
      expect(find.byIcon(Icons.folder), findsNothing);
    });

    test('is a StatelessWidget with required props', () {
      final widget = RecordingsListView(
        recordings: [_file('test.mp3')],
        selectedItems: const [false],
        allSelected: false,
        onToggleSelectAll: () {},
        onSelectedChanged: (_) {},
      );

      expect(widget, isA<StatelessWidget>());
      expect(widget.recordings, isNotNull);
      expect(widget.selectedItems, isNotNull);
      expect(widget.onToggleSelectAll, isNotNull);
      expect(widget.onSelectedChanged, isNotNull);
    });
  });
}
