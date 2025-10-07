import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/report_type.dart';
import 'package:straysave/models/user.dart';
import 'package:straysave/screens/report/make_report.dart';
import 'package:straysave/services/database.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockUploadImage extends Mock {
  Future<String?> call(File? img) async => 'fake_url';
}

final mockDb = MockDatabaseService();
final mockUpload = MockUploadImage();

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

  group('Make Report Screen Test', () {
    testWidgets('renders all main input fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(MakeReport(), user: FakeUser()),
      );

      expect(find.text('New Report'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      ); // title, location, description
      expect(find.byType(DropdownButtonFormField<ReportType>), findsOneWidget);
      expect(find.text('Add Image'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Submit'), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(MakeReport(), user: FakeUser()),
      );

      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Enter a title'), findsOneWidget);
      expect(find.text('Pick a type :('), findsOneWidget);
      expect(find.text('Enter your location :('), findsOneWidget);
      expect(find.text('Enter a description'), findsOneWidget);
    });

    testWidgets('all field can be filled', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MakeReport(
            databaseService: mockDb,
            uploadImageFn: (img) async => 'fake_url',
            deleteImageFn: (url) async {},
          ),
          user: FakeUser(),
        ),
      );

      final titleField = find.byType(TextFormField).at(0);
      await tester.enterText(titleField, 'Test Title');
      expect(find.text('Test Title'), findsOneWidget);

      // Dropdown (set selectedType manually for simplicity)
      final dropdown = find.byType(DropdownButtonFormField<ReportType>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dangerous').last);
      await tester.pumpAndSettle();

      expect(find.text('Dangerous'), findsOneWidget);

      // Location field
      final locationField = find.byType(TextFormField).at(1);
      await tester.enterText(locationField, 'Test Location');
      expect(find.text('Test Location'), findsOneWidget);

      // Description field
      final descField = find.byType(TextFormField).at(2);
      await tester.enterText(descField, 'Test Description');
      expect(find.text('Test Description'), findsOneWidget);

      // Image field (we can just check the placeholder text)
      expect(find.text('Add Image'), findsOneWidget);
    });

    testWidgets('submits successfully when all fields are valid', (
      tester,
    ) async {
      final mockDb = MockDatabaseService();

      when(
        () => mockDb.createReportData(any(), any(), any(), any()),
      ).thenAnswer((_) async {
        return 'fakeDoc123';
      });

      await tester.pumpWidget(
        makeTestableWidget(
          MakeReport(
            databaseService: mockDb,
            uploadImageFn: (img) async => 'fake_url',
            deleteImageFn: (url) async {},
          ),
          user: FakeUser(),
        ),
      );

      final titleField = find.byType(TextFormField).at(0);
      await tester.enterText(titleField, 'Test Title');
      expect(find.text('Test Title'), findsOneWidget);

      // Dropdown (set selectedType manually for simplicity)
      final dropdown = find.byType(DropdownButtonFormField<ReportType>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dangerous').last);
      await tester.pumpAndSettle();

      expect(find.text('Dangerous'), findsOneWidget);

      // Location field
      final locationField = find.byType(TextFormField).at(1);
      await tester.enterText(locationField, 'Test Location');
      expect(find.text('Test Location'), findsOneWidget);

      // Description field
      final descField = find.byType(TextFormField).at(2);
      await tester.enterText(descField, 'Test Description');
      expect(find.text('Test Description'), findsOneWidget);

      // Tap submit
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      verify(
        () => mockDb.createReportData(
          any(), // title
          any(), // type
          any(), // description
          any(), // userId
          img: any(named: 'img'),
          location: any(named: 'location'),
        ),
      ).called(1);
    });

    testWidgets('calls onClose after submission if provided', (
      WidgetTester tester,
    ) async {
      bool closed = false;
      await tester.pumpWidget(
        makeTestableWidget(
          MakeReport(
            databaseService: mockDb,
            uploadImageFn: (img) async => 'fake_url',
            deleteImageFn: (url) async {},
            onClose: () => closed = true,
          ),
          user: FakeUser(),
        ),
      );

      final titleField = find.byType(TextFormField).at(0);
      await tester.enterText(titleField, 'Test Title');
      expect(find.text('Test Title'), findsOneWidget);

      // Dropdown (set selectedType manually for simplicity)
      final dropdown = find.byType(DropdownButtonFormField<ReportType>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Dangerous').last);
      await tester.pumpAndSettle();

      expect(find.text('Dangerous'), findsOneWidget);

      // Location field
      final locationField = find.byType(TextFormField).at(1);
      await tester.enterText(locationField, 'Test Location');
      expect(find.text('Test Location'), findsOneWidget);

      // Description field
      final descField = find.byType(TextFormField).at(2);
      await tester.enterText(descField, 'Test Description');
      expect(find.text('Test Description'), findsOneWidget);

      // Tap submit
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });

    testWidgets('populates initial values if provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(
          MakeReport(
            initialTitle: 'Lost Cat',
            initialDesc: 'Orange cat missing near dorm.',
            databaseService: mockDb,
          ),
          user: FakeUser(),
        ),
      );

      expect(find.text('Lost Cat'), findsOneWidget);
      expect(find.text('Orange cat missing near dorm.'), findsOneWidget);
    });
  });
}
