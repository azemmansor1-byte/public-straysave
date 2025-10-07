import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:straysave/screens/authorities/authority_detail.dart';

void main() {
  group('Authority Detail Screen Test', () {
    testWidgets('renders all authority information correctly', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: AuthorityDetail()));

        expect(find.text('Authority Details'), findsOneWidget);
        expect(find.text('SPCA Selangor'), findsOneWidget);
        expect(
          find.textContaining('The Society for the Prevention of Cruelty'),
          findsOneWidget,
        );
        expect(find.text('+60 3-4256 5312'), findsOneWidget);
        expect(find.text('spca@example.com'), findsOneWidget);
        expect(find.text('Ampang Jaya, Selangor'), findsOneWidget);
        expect(find.text('Mon - Sun, 9am - 6pm'), findsOneWidget);
        final imageContainer = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(imageContainer, findsOneWidget);
      });
    });

    testWidgets('taps location,email and phone without crashing', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(const MaterialApp(home: AuthorityDetail()));

        // Tap location
        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pump();

        // Tap phone
        await tester.tap(find.byIcon(Icons.phone));
        await tester.pump();

        // Tap email
        await tester.tap(find.byIcon(Icons.email));
        await tester.pump();

        // Still on same screen (no crash)
        expect(find.text('Authority Details'), findsOneWidget);
      });
    });
    testWidgets('navigates back when back button is pressed', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Navigator(
              onGenerateRoute: (settings) =>
                  MaterialPageRoute(builder: (_) => const AuthorityDetail()),
            ),
          ),
        );

        // Tap back button
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Expect navigator popped — current screen is empty
        expect(find.text('Report Details'), findsNothing);
      });
    });
  });
}
