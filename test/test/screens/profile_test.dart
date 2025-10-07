import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:straysave/screens/home/profile.dart';
import 'package:straysave/services/auth.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuth;

  setUp(() {
    mockAuth = MockAuthService();
    when(() => mockAuth.signOut()).thenAnswer((_) async {});
  });

  group('Profile Screen', () {
    testWidgets('renders profile information correctly', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Profile(auth: mockAuth)));

        expect(find.text('John Flutter'), findsOneWidget);
        expect(find.text('john.flutter@example.com'), findsOneWidget);
        expect(find.text('+60 12-345 6789'), findsOneWidget);
        expect(find.text('Reports'), findsOneWidget);
        expect(find.text('Member Since'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
        expect(find.text('March 2024'), findsOneWidget);
      });
    });

    testWidgets('opens and closes edit dialog', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Profile(auth: mockAuth)));

        final editButton = find.text('Edit Profile / Change Password');
        expect(editButton, findsOneWidget, reason: 'Edit button not found');

        await tester.tap(editButton);
        await tester.pumpAndSettle();

        expect(find.text('Edit Profile'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Edit Profile'), findsNothing);
      });
    });

    testWidgets('shows logout confirmation dialog', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Profile(auth: mockAuth)));

        final editButton = find.byIcon(Icons.logout);
        expect(editButton, findsOneWidget, reason: 'Log Out button not found');

        await tester.tap(editButton);
        await tester.pumpAndSettle();

        expect(find.text('Log out of your account?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Logout'), findsOneWidget);

        await tester.tap(find.text('Logout'));
        await tester.pumpAndSettle();

        verify(() => mockAuth.signOut()).called(1);
      });
    });

    testWidgets('activates fake admin mode', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(MaterialApp(home: Profile(auth: mockAuth)));

        final button = find.text('Administrator Mode (Fake)');
        expect(button, findsOneWidget, reason: 'Admin button not found');

        await tester.tap(button);
        await tester.pump();

        expect(find.text('Admin Mode activated (fake)'), findsOneWidget);
      });
    });
  });
}
