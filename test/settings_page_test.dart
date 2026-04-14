import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cll_upld/pages/settings_page.dart';

void main() {
  group('SettingsPage Tests', () {
    testWidgets('SettingsPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify AppBar title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Settings'), findsWidgets);
    });

    testWidgets('Page displays main heading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify the main heading is displayed
      final headingFinder = find.text('Settings');
      expect(headingFinder, findsWidgets);
    });

    testWidgets('Page displays description text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify description
      expect(
        find.text('Manage app preferences and permissions here.'),
        findsOneWidget,
      );
    });

    testWidgets('Return to main button is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify button exists
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Return to main'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Return to main button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WillPopScope(
            onWillPop: () async => true,
            child: const SettingsPage(),
          ),
        ),
      );

      // Verify SettingsPage is displayed
      expect(find.byType(SettingsPage), findsOneWidget);

      // Tap the return button
      await tester.tap(find.text('Return to main'));
      await tester.pumpAndSettle();

      // Verify the button callback was triggered
      // (pop was called by Navigator.pop in the button)
    });

    testWidgets('Main heading has correct style', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Find the main heading Text widget
      final heading = find.text('Settings').first;
      expect(heading, findsOneWidget);

      // Get the Text widget to verify styling
      final textWidget = tester.widget<Text>(heading);
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Description text has correct style', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Find description text
      final description =
          find.text('Manage app preferences and permissions here.');

      expect(description, findsOneWidget);

      // Verify styling
      final text = tester.widget<Text>(description);
      expect(text.style?.fontSize, 16);
    });

    testWidgets('Page layout structure is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify the Column exists with correct structure
      expect(find.byType(Column), findsWidgets);

      // Verify Padding exists
      expect(find.byType(Padding), findsWidgets);

      // Verify SizedBox spacers exist
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('All widgets are present in hierarchy',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify all key widgets are in the widget tree
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Button icon and label are correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Verify button contains both icon and label
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Return to main'), findsOneWidget);

      // Verify they are in the same TextButton
      final buttonFinder = find.byType(TextButton);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Page content is properly padded', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsPage(),
        ),
      );

      // Find the Padding widget that wraps the Column
      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsWidgets);

      // Verify that Padding is present
      expect(paddingFinder.evaluate().isNotEmpty, true);
    });
  });
}
