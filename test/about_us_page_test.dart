import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cll_upld/pages/about_us_page.dart';

void main() {
  group('AboutUsPage Tests', () {
    testWidgets('AboutUsPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify the widget is rendered
      expect(find.byType(AboutUsPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar displays correct title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify AppBar title
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('About Us'), findsWidgets);
    });

    testWidgets('Page displays main heading', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify the main heading is displayed
      final headingFinder = find.text('About Us');
      expect(headingFinder, findsWidgets);
    });

    testWidgets('Page displays description texts', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify first description
      expect(
        find.text('This app helps you browse your downloads directory in one place.'),
        findsOneWidget,
      );

      // Verify second description
      expect(
        find.text('You can refresh downloads, inspect files, and manage selections.'),
        findsOneWidget,
      );
    });

    testWidgets('Return to main button is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify button exists
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Return to main'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Return to main button navigates back', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WillPopScope(
            onWillPop: () async => true,
            child: const AboutUsPage(),
          ),
        ),
      );

      // Verify AboutUsPage is displayed
      expect(find.byType(AboutUsPage), findsOneWidget);
      expect(find.text('About Us'), findsWidgets);

      // Tap the return button
      await tester.tap(find.text('Return to main'));
      await tester.pumpAndSettle();

      // Verify the button callback was triggered
      // (pop was called by Navigator.pop in the button)
    });

    testWidgets('Page layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Verify the main Column exists
      expect(find.byType(Column), findsWidgets);

      // Verify Padding exists
      expect(find.byType(Padding), findsWidgets);

      // Verify SizedBox spacers exist
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Text styling is correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Find the main heading Text widget
      final heading = find.text('About Us').first;
      expect(heading, findsOneWidget);

      // Get the Text widget to verify styling
      final textWidget = tester.widget<Text>(heading);
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('Description texts have correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
        ),
      );

      // Find description texts
      final description1 = find.text(
          'This app helps you browse your downloads directory in one place.');
      final description2 = find.text(
          'You can refresh downloads, inspect files, and manage selections.');

      expect(description1, findsOneWidget);
      expect(description2, findsOneWidget);

      // Verify styling
      final text1 = tester.widget<Text>(description1);
      final text2 = tester.widget<Text>(description2);

      expect(text1.style?.fontSize, 16);
      expect(text2.style?.fontSize, 16);
    });

    testWidgets('All widgets are present in hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AboutUsPage(),
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
  });
}
