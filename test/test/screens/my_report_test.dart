import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/user.dart';
import 'package:straysave/screens/home/my_reports.dart';
import 'package:straysave/screens/report/make_report.dart';
import 'package:straysave/services/database.dart';

class FakeUser extends User {
  FakeUser() : super(uid: '123');
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late DatabaseService dbService;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();

    // Populate fake Firestore with test reports
    await fakeFirestore.collection('reports').add({
      'title': 'Lost Dog near UNITEN Gate',
      'type': 0,
      'desc': 'Brown dog lost near gate',
      'createdAt': DateTime.now(),
      'userId': '123',
    });
    await fakeFirestore.collection('reports').add({
      'title': 'Aggressive Cat at Cafeteria',
      'type': 1,
      'desc': 'Cat attacked someone',
      'createdAt': DateTime.now(),
      'userId': '123',
    });
    await fakeFirestore.collection('reports').add({
      'title': 'Snake spotted near Lab 3',
      'type': 2,
      'desc': 'Snake found in lab',
      'createdAt': DateTime.now(),
      'userId': '456',
    });

    // Inject FakeFirestore into DatabaseService
    dbService = DatabaseService(firestore: fakeFirestore, uid: FakeUser().uid);
  });

  Widget makeTestableWidget(Widget child, {User? user}) {
    return Provider<User?>.value(
      value: user,
      child: MaterialApp(home: child),
    );
  }

  group('My Reports Screen Tests', () {
    testWidgets('shows initial report list and app bar', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          makeTestableWidget(
            MyReports(databaseService: dbService),
            user: FakeUser(),
          ),
        );
        await tester.pumpAndSettle();

        // App bar
        expect(find.text('My Reports'), findsOneWidget);

        // Reports from fake Firestore
        expect(find.text('Lost Dog near UNITEN Gate'), findsWidgets);
        expect(find.text('Aggressive Cat at Cafeteria'), findsWidgets);
        expect(find.text('Snake spotted near Lab 3'), findsNothing);
      });
    });

    testWidgets('filters reports based on search query', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MyReports(databaseService: dbService),
          user: FakeUser(),
        ),
      );

      // Enter search query
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'Lost');
      await tester.pumpAndSettle();

      expect(find.textContaining('Lost'), findsWidgets);
      expect(find.text('Aggressive Cat at Cafeteria'), findsNothing);
    });

    testWidgets('shows MakeReport when add button pressed', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MyReports(databaseService: dbService),
          user: FakeUser(),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(MakeReport), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
    });
  });
}
