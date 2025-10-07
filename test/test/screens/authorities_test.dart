import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:straysave/screens/authorities/authority_detail.dart';
import 'package:straysave/screens/home/authorities.dart';

void main() {
  group('Authorities Screen Tests', () {
    testWidgets('shows initial authorities list and app bar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: Authorities()));

      // Verify app bar title
      expect(find.text('Authorities'), findsOneWidget);

      // Verify search bar is visible
      expect(find.byType(SearchBar), findsOneWidget);

      // Verify some mock reports appear
      expect(
        find.text('Persatuan Haiwan Terbiar Malaysia (SAFM)'),
        findsWidgets,
      );

      await tester.scrollUntilVisible(
        find.text('Malaysian Conservation Alliance for Tigers (MYCAT)'),
        200.0, // scroll distance per step
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );

      expect(
        find.text('Malaysian Conservation Alliance for Tigers (MYCAT)'),
        findsWidgets,
      );
    });

    testWidgets('filters authorities based on search query', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: Authorities()));

      // Enter text into search bar
      await tester.enterText(find.byType(SearchBar), 'CAT');
      await tester.pumpAndSettle();

      // Should only show reports containing "snake"
      expect(
        find.textContaining(
          'Malaysian Conservation Alliance for Tigers (MYCAT)',
          findRichText: true,
        ),
        findsWidgets,
      );
      expect(find.text('SPCA'), findsNothing);
    });

    testWidgets('navigates to AuthorityDetail on authority tap', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: Authorities()));

        // Tap on the first report item
        await tester.tap(
          find.text('Department of Veterinary Services (DVS)').first,
        );
        await tester.pumpAndSettle();

        // Verify ReportDetail screen appears
        expect(find.byType(AuthorityDetail), findsOneWidget);
      });
    });
  });
}
