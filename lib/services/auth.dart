import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:rxdart/rxdart.dart';
import 'package:straysave/models/user.dart' as model;
import 'package:straysave/services/database.dart';

class AuthService {
  final fb.FirebaseAuth _auth;
  final DatabaseService Function(String uid)? databaseServiceBuilder;

  AuthService({fb.FirebaseAuth? firebaseAuth, this.databaseServiceBuilder})
    : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  //create user obj based on firebase user
  // Real-time user stream
  Stream<model.User?> get user {
    return _auth.authStateChanges().switchMap((fb.User? fbUser) {
      if (fbUser == null) return Stream.value(null); // logout => emit null

      final db =
          databaseServiceBuilder?.call(fbUser.uid) ??
          DatabaseService(uid: fbUser.uid);

      return db.userData.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return null;

        return model.User(
          uid: fbUser.uid,
          username: data['username'],
          email: data['email'],
          phoneNo: data['phoneNo'],
          role: data['role'],
          alertPreference:
              (data['alertPreference'] as Map?)?.cast<String, bool>() ?? {},
          reportsCount: data['reportsCount'],
          profileImageUrl: data['profileImageUrl'],
          isActive: data['isActive'],
          lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
        );
      });
    });
  }

  Future<model.User?> _fetchUserData(fb.User? user) async {
    if (user == null) return null;

    final db =
        databaseServiceBuilder?.call(user.uid) ??
        DatabaseService(uid: user.uid);

    final doc = await db.userCollection.doc(user.uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    return model.User(
      uid: user.uid,
      username: data['username'],
      email: data['email'],
      phoneNo: data['phoneNo'],
      role: data['role'],
      alertPreference: (data['alertPreference'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as bool),
      ),
      reportsCount: data['reportsCount'],
      profileImageUrl: data['profileImageUrl'],
      isActive: data['isActive'],
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  //Sign in anon
  Future<model.User?> signInAnon() async {
    try {
      fb.UserCredential result = await _auth.signInAnonymously();
      fb.User? user = result.user;

      return _fetchUserData(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<model.User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      fb.User? user = result.user;

      if (user != null) {
        // Update lastLogin in Firestore
        final db = DatabaseService(uid: user.uid);
        await db.updateLastLogin(DateTime.now());
      }

      return _fetchUserData(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<model.User?> registerWithEmailAndPassword(
    String username,
    String email,
    String password,
    String phoneNo,
  ) async {
    try {
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      fb.User? user = result.user;

      if (user == null) return null;

      final db =
          databaseServiceBuilder?.call(user.uid) ??
          DatabaseService(uid: user.uid);
      await db.createUserData(username, email, phoneNo);

      return _fetchUserData(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get current user
  fb.User? getCurrentUser() {
    return _auth.currentUser;
  }
}
