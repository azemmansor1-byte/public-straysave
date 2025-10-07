import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'as fb;
import 'package:straysave/models/user.dart' as suser;

class AuthService {
  final fb.FirebaseAuth _auth;

  AuthService({fb.FirebaseAuth? firebaseAuth})
  : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  //create user obj based on firebase user
  suser.User? _userFromFirebaseUser(fb.User? user) {
    return user != null ? suser.User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<suser.User?> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  //Sign in anon
  Future<suser.User?> signInAnon() async {
    try {
      fb.UserCredential result = await _auth.signInAnonymously();
      fb.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<suser.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      fb.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      fb.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<suser.User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      fb.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fb.User? user = result.user;
      return _userFromFirebaseUser(user);
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