import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:straysave/screens/authenticate/sign_in.dart';
import 'package:straysave/models/user.dart' as suser;
import '../mocks.dart';

// ----- FAKE USER -----
class FakeUser extends suser.User {
  FakeUser() : super(uid: '123');
}

void main() {
  late MockAuthService mockAuth;

  setUp(() {
    mockAuth = MockAuthService();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(home: child);
  }

  testWidgets('Renders all Sign In UI elements', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SignIn(authService: mockAuth, toggleView: () {})),
    );

    expect(find.byType(TextFormField), findsNWidgets(2)); // email + password
    expect(
      find.byKey(Key('passwordToggle')),
      findsOneWidget,
    ); // password toggle
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget); // toggle to register
  });

  testWidgets('Password visibility toggle works', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        SignIn(toggleView: () {}, authService: MockAuthService()),
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

  testWidgets('Shows validation errors for empty fields', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(SignIn(authService: mockAuth, toggleView: () {})),
    );

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter an email'), findsOneWidget);
    expect(find.text('Enter a password'), findsOneWidget);
  });

  testWidgets('Calls AuthService.signInWithEmailAndPassword on valid input', (tester) async {
    when(
      () => mockAuth.signInWithEmailAndPassword(any(), any()),
    ).thenAnswer((_) async => FakeUser());

    await tester.pumpWidget(
      makeTestableWidget(SignIn(authService: mockAuth, toggleView: () {})),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), '1234');
    await tester.tap(find.text('Log in'));
    await tester.pump();

    verify(
      () => mockAuth.signInWithEmailAndPassword('test@email.com', '1234'),
    ).called(1);
  });

  testWidgets('Displays error if sign in fails', (tester) async {
    when(
      () => mockAuth.signInWithEmailAndPassword(any(), any()),
    ).thenAnswer((_) async => null);

    await tester.pumpWidget(
      makeTestableWidget(SignIn(authService: mockAuth, toggleView: () {})),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), '1234');
    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(
      find.text('Could not sign in with those credentials'),
      findsOneWidget,
    );
  });

  testWidgets('Calls toggleView when Register button is tapped', (tester) async {
    bool toggled = false;

    await tester.pumpWidget(
      makeTestableWidget(
        SignIn(
          authService: mockAuth,
          toggleView: () {
            toggled = true;
          },
        ),
      ),
    );

    await tester.tap(find.text('Sign Up'));
    expect(toggled, isTrue);
  });
}
