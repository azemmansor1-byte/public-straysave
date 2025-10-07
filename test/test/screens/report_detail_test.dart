import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:straysave/screens/report/report_detail.dart';
import 'package:straysave/services/database.dart';
import 'package:mocktail/mocktail.dart';

// Mock DatabaseService
class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late DatabaseService mockDb;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();

    // Populate fake Firestore with test reports
    await fakeFirestore.collection('reports').doc('testReport').set({
      'title': 'Aggressive Dog near Cafeteria',
      'description': 'A large black dog has been wandering near',
      'location': 'UNITEN Cafeteria, Jalan IKRAM-UNITEN',
      'phone': '+60 12-345 6789',
      'status': 'Open',
      'type': 2,
      'createdAt': Timestamp.fromDate(DateTime(2025, 10, 3)),
      'img_url': null,
    });

    // Inject FakeFirestore into DatabaseService
    mockDb = DatabaseService(firestore: fakeFirestore, reportId: 'testReport');
  });

  group('ReportDetail Screen', () {
    testWidgets('renders all report information correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportDetail(reportId: 'testReport', databaseService: mockDb),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Aggressive Dog near Cafeteria'), findsOneWidget);
        expect(
          find.textContaining('A large black dog has been wandering near'),
          findsOneWidget,
        );
        expect(
          find.text('UNITEN Cafeteria, Jalan IKRAM-UNITEN'),
          findsOneWidget,
        );
        expect(find.text('+60 12-345 6789'), findsOneWidget);
        expect(find.text('Created'), findsOneWidget);
        expect(find.text('2025-10-03'), findsOneWidget);
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('Open'), findsOneWidget);
        expect(find.text('Type'), findsOneWidget);
        expect(find.text('Dangerous'), findsOneWidget);
      });
    });

    testWidgets('taps location and phone without crashing', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ReportDetail(reportId: 'testReport', databaseService: mockDb),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.location_on));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.phone));
        await tester.pump();

        expect(find.text('Report Details'), findsOneWidget);
      });
    });

    testWidgets('navigates back when back button is pressed', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (_) => ReportDetail(
                  reportId: 'testReport',
                  databaseService: mockDb,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        expect(find.text('Report Details'), findsNothing);
      });
    });
  });
}
