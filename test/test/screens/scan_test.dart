import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/user.dart';
import 'package:straysave/screens/home/scan.dart';
import 'package:straysave/screens/report/make_report.dart';
import 'package:straysave/services/database.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

final mockDb = MockDatabaseService();

class FakeUser extends User {
  FakeUser() : super(uid: '123');
}

void main() {
  Widget makeTestableWidget(Widget child, {User? user}) {
    return Provider<User?>.value(
      value: user,
      child: MaterialApp(home: child),
    );
  }

  testWidgets('renders Scan screen and opens MakeReport on Report tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(Scan(), user: FakeUser()));

    // Verify UI
    expect(find.text('Scan Animal'), findsOneWidget);
    expect(find.text('Add Image'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);

    // Tap Report button
    await tester.ensureVisible(find.text('Report'));
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();

    // Verify MakeReport screen appears
    expect(find.byType(MakeReport), findsOneWidget);
  });
}
