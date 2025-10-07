import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:straysave/screens/authenticate/register.dart';
import 'package:straysave/models/user.dart' as suser;
import 'test_helpers.dart';
import '../mocks.dart';

class FakeUser extends suser.User {
  FakeUser() : super(uid: '123');
}

void main() {
  setUpAll(() {
    registerFallbackValue(''); // required by mocktail any<String>()
  });

  group('Register Widget', () {
    testWidgets('Empty username shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Enter a username'), findsOneWidget);
    });

    testWidgets('Empty email shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Enter an email'), findsOneWidget);
    });

    testWidgets('Invalid email shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(find.byType(TextFormField).at(1), 'abc@xyz');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Email not valid'), findsOneWidget);
    });

    testWidgets('Empty phone shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Enter a phone number'), findsOneWidget);
    });

    testWidgets('Invalid phone shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '1234');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Phone number not valid'), findsOneWidget);
    });

    testWidgets('Empty password shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '+60123456789');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Enter a password'), findsOneWidget);
    });

    testWidgets('Password too short shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '+60123456789');
      await tester.enterText(find.byType(TextFormField).at(3), '123');
      await tester.enterText(find.byType(TextFormField).at(4), '123');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    });

    testWidgets('Empty confirm password shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '+60123456789');
      await tester.enterText(find.byType(TextFormField).at(3), '1234');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Confirm your password'), findsOneWidget);
    });

    testWidgets('Confirm password mismatch shows error', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '+60123456789');
      await tester.enterText(find.byType(TextFormField).at(3), '1234');
      await tester.enterText(find.byType(TextFormField).at(4), 'abcd');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );

      final passwordToggle = find.byKey(Key('passwordToggle'));

      // Initially, password should be obscured → icon should be "visibility"
      expect(
        find.descendant(
          of: passwordToggle,
          matching: find.byIcon(Icons.visibility),
        ),
        findsOneWidget,
      );

      // Tap to show password → icon should change to "visibility_off"
      await tester.tap(passwordToggle);
      await tester.pump();

      expect(
        find.descendant(
          of: passwordToggle,
          matching: find.byIcon(Icons.visibility_off),
        ),
        findsOneWidget,
      );

      // Tap again to obscure password → icon should revert to "visibility"
      await tester.tap(passwordToggle);
      await tester.pump();

      expect(
        find.descendant(
          of: passwordToggle,
          matching: find.byIcon(Icons.visibility),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Confirm password visibility toggle works', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Register(toggleView: () {}, authService: MockAuthService()),
        ),
      );

      final confirmToggle = find.byKey(Key('conPasswordToggle'));

      // Initially, confirm password should be obscured
      expect(
        find.descendant(
          of: confirmToggle,
          matching: find.byIcon(Icons.visibility),
        ),
        findsOneWidget,
      );

      // Tap to show confirm password
      await tester.tap(confirmToggle);
      await tester.pump();

      expect(
        find.descendant(
          of: confirmToggle,
          matching: find.byIcon(Icons.visibility_off),
        ),
        findsOneWidget,
      );

      // Tap again to obscure confirm password
      await tester.tap(confirmToggle);
      await tester.pump();

      expect(
        find.descendant(
          of: confirmToggle,
          matching: find.byIcon(Icons.visibility),
        ),
        findsOneWidget,
      );
    });

    testWidgets('toggleView is called when Log in tapped', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(
        makeTestableWidget(
          Register(
            toggleView: () {
              toggled = true;
            },
            authService: MockAuthService(),
          ),
        ),
      );
      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(toggled, isTrue);
    });

    testWidgets('Pressing Register calls AuthService.registerWithEmailAndPassword',(tester) async {
        final mockAuth = MockAuthService();
        when(
          () => mockAuth.registerWithEmailAndPassword(any(), any()),
        ).thenAnswer((_) async => FakeUser());

        await tester.pumpWidget(
          makeTestableWidget(
            Register(toggleView: () {}, authService: mockAuth),
          ),
        );
        await tester.enterText(find.byType(TextFormField).at(0), 'username');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'test@email.com',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          '+60123456789',
        );
        await tester.enterText(find.byType(TextFormField).at(3), 'abcd1234');
        await tester.enterText(find.byType(TextFormField).at(4), 'abcd1234');
        await tester.tap(find.text('Register'));
        await tester.pump();
        verify(
          () => mockAuth.registerWithEmailAndPassword('test@email.com', 'abcd1234'),
        ).called(1);
      },
    );

    testWidgets('Error is displayed if register returns null', (tester) async {
      final mockAuth = MockAuthService();
      when(
        () => mockAuth.registerWithEmailAndPassword(any(), any()),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(
        makeTestableWidget(Register(toggleView: () {}, authService: mockAuth)),
      );
      await tester.enterText(find.byType(TextFormField).at(0), 'username');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '+60123456789');
      await tester.enterText(find.byType(TextFormField).at(3), 'abcd1234');
      await tester.enterText(find.byType(TextFormField).at(4), 'abcd1234');
      await tester.tap(find.text('Register'));
      await tester.pump();
      expect(
        find.text('Could not register with those credentials'),
        findsOneWidget,
      );
    });
  });
}
