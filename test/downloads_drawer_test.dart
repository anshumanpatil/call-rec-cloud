import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cll_upld/widgets/downloads_drawer.dart';

void main() {
  group('DownloadsDrawer Tests', () {
    testWidgets('DownloadsDrawer is a StatelessWidget', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      expect(drawer, isA<StatelessWidget>());
    });

    testWidgets('DownloadsDrawer can be instantiated', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      expect(drawer, isNotNull);
    });

    testWidgets('DownloadsDrawer widget structure is correct', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      // Build the drawer directly to inspect its structure
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      // Open the drawer
      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();

      await tester.pumpAndSettle();

      // Now check for drawer contents
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('DownloadsDrawer displays menu items when opened', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      // Open drawer
      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      // Check drawer header and items
      expect(find.text('Downloads Menu'), findsOneWidget);
      expect(find.text('Refresh Downloads'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('DownloadsDrawer has proper icons', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('DownloadsDrawer onRefresh callback works', (
      WidgetTester tester,
    ) async {
      bool refreshCalled = false;

      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () => refreshCalled = true,
        onAbout: () {},
        onSettings: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Refresh Downloads'));
      await tester.pumpAndSettle();

      expect(refreshCalled, isTrue);
    });

    testWidgets('DownloadsDrawer onAbout callback works', (
      WidgetTester tester,
    ) async {
      bool aboutCalled = false;

      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () => aboutCalled = true,
        onSettings: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(aboutCalled, isTrue);
    });

    testWidgets('DownloadsDrawer onSettings callback works', (
      WidgetTester tester,
    ) async {
      bool settingsCalled = false;

      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () => settingsCalled = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(settingsCalled, isTrue);
    });

    testWidgets('DownloadsDrawer drawer closes after menu tap', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Test App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(drawer: drawer, body: Container()),
        ),
      );

      ScaffoldState state = tester.state(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();

      // Tap a menu item (which calls Navigator.pop)
      await tester.tap(find.text('Refresh Downloads'));
      await tester.pumpAndSettle();

      // Drawer should be closed
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('DownloadsDrawer required parameters', (
      WidgetTester tester,
    ) async {
      // Verify all parameters are required
      expect(
        () => DownloadsDrawer(
          applicationName: 'Test App',
          onRefresh: () {},
          onAbout: () {},
          onSettings: () {},
        ),
        returnsNormally,
      );
    });

    testWidgets('DownloadsDrawer with different applicationName', (
      WidgetTester tester,
    ) async {
      final drawer = DownloadsDrawer(
        applicationName: 'Custom App',
        onRefresh: () {},
        onAbout: () {},
        onSettings: () {},
      );

      expect(drawer.applicationName, 'Custom App');
    });
  });
}
