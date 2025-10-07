import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:straysave/services/auth.dart';
import 'package:straysave/models/user.dart' as suser;

import 'screens/scan_test.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class MockUser extends Mock implements fb.User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(firebaseAuth: mockFirebaseAuth);
  });

  group('AuthService', () {
    test('signinAnon returns a user on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();

      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('1234');
      when(
        () => mockFirebaseAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.signInAnon();
      expect(result, isA<suser.User>());
      expect(result?.uid, '1234');
    });

    test('signInWithEmailAndPassword returns a user on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();

      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('abc123');
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await authService.signInWithEmailAndPassword(
        'test@test.com',
        'password',
      );
      expect(result, isA<suser.User>());
      expect(result?.uid, 'abc123');
    });

    test('registerWithEmailAndPassword returns a user on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      final mockDb = MockDatabaseService();

      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('newuser123');
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockCredential);

      when(
        () => mockDb.createUserData(any(), any(), any()),
      ).thenAnswer((_) async => Future.value());

      final authService = AuthService(
        firebaseAuth: mockFirebaseAuth,
        databaseServiceBuilder: (_) => mockDb,
      );

      final result = await authService.registerWithEmailAndPassword(
        'Azem',
        'test@test.com',
        '123456',
        '0123456789',
      );
      expect(result, isA<suser.User>());
      expect(result?.uid, 'newuser123');
      verify(
        () => mockDb.createUserData('Azem', 'test@test.com', '0123456789'),
      ).called(1);
    });

    test('signOut completes successfully', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async => {});
      await authService.signOut();
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('getCurrentUser returns firebase current user', () {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      expect(authService.getCurrentUser(), equals(mockUser));
    });
  });
}
