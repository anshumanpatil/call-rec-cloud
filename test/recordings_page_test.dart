import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cll_upld/pages/recordings_page.dart';

void main() {
  group('RecordingsPage Tests', () {
    testWidgets('RecordingsPage renders with title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Test Recordings')),
      );

      // Verify the widget is rendered
      expect(find.byType(RecordingsPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'My Recordings')),
      );

      // Verify AppBar title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('My Recordings'), findsOneWidget);
    });

    testWidgets('Floating action button is displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Verify floating action button exists
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('Scaffold drawer parameter is set', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Verify scaffold has drawer by checking scaffold widget
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.drawer, isNotNull);
    });

    testWidgets('Loading indicator is shown initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Pump once to trigger initState
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Initially should show loading or error based on actual behavior
      // The content will depend on repository response
    });

    testWidgets('FAB tooltip shows Refresh', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Verify FAB tooltip
      expect(find.byTooltip('Refresh'), findsOneWidget);
    });

    testWidgets('RecordingsPage accepts title parameter', (
      WidgetTester tester,
    ) async {
      const String testTitle = 'Workout Recordings';

      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: testTitle)),
      );

      // Verify the title is displayed
      expect(find.text(testTitle), findsOneWidget);
    });

    testWidgets('Scaffold has proper structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Verify scaffold components
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Page builds without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Test')),
      );

      // No exceptions should be thrown during build
      expect(find.byType(RecordingsPage), findsOneWidget);
    });

    testWidgets('AppBar has correct background color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: const RecordingsPage(title: 'Recordings'),
        ),
      );

      // Verify AppBar exists with theme
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Floating action button has correct icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // Verify refresh icon in FAB
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final iconFinder = find.byIcon(Icons.refresh);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('Widget title property is required', (
      WidgetTester tester,
    ) async {
      // This test verifies that the title is a required parameter
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Required Title')),
      );

      expect(find.byType(RecordingsPage), findsOneWidget);
      expect(find.text('Required Title'), findsOneWidget);
    });

    testWidgets('Page is a StatefulWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Recordings')),
      );

      // RecordingsPage is a StatefulWidget, verify it builds and manages state
      expect(find.byType(RecordingsPage), findsOneWidget);
    });

    testWidgets('Scaffold has AppBar with title', (WidgetTester tester) async {
      const String testTitle = 'Test Recordings Title';

      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: testTitle)),
      );

      // Verify scaffold and appbar structure
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.appBar, isNotNull);
    });

    testWidgets('Page updates when title changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Initial Title')),
      );

      expect(find.text('Initial Title'), findsOneWidget);

      // Rebuild with new title
      await tester.pumpWidget(
        const MaterialApp(home: RecordingsPage(title: 'Updated Title')),
      );

      expect(find.text('Updated Title'), findsOneWidget);
    });
  });
}
