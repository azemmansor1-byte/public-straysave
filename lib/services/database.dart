import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:straysave/services/upload_image.dart';

// TODO: Replace String? location with Geopoint? better location accuracy

class DatabaseService {
  final String? uid;
  final String? reportId;
  final FirebaseFirestore firestore;

  DatabaseService({this.uid, this.reportId, FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get reportCollection => firestore.collection('reports');
  CollectionReference get userCollection => firestore.collection('users');

  //create user data in firestore database
  Future createUserData(String username, String email, String phoneNo) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
      'phoneNo': phoneNo,
      'role': 'resident',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isActive': true,
      'profileImageUrl': null,
      'lastLogin': FieldValue.serverTimestamp(),
      'reportsCount': 0,
      'alertPreference': {'stray': true, 'lost': true, 'dangerous': true},
    });
  }

  //update user data in firestore database
  Future<void> updateUserData({
    String? username,
    String? email,
    String? phoneNo,
    String? role,
    bool? isActive,
    String? profileImageUrl,
    int? reportsCount,
    Map<String, bool>? alertPreference,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    };
    if (username != null) updates['username'] = username;
    if (email != null) updates['email'] = email;
    if (phoneNo != null) updates['phoneNo'] = phoneNo;
    if (role != null) updates['role'] = role;
    if (isActive != null) updates['isActive'] = isActive;
    if (profileImageUrl != null) {
      //TODO: implement delete old image from storage when updating to new profile pic
      updates['profileImageUrl'] = profileImageUrl;
    }
    if (reportsCount != null) updates['reportsCount'] = reportsCount;
    if (alertPreference != null) updates['alertPreference'] = alertPreference;
    await userCollection.doc(uid).update(updates);
  }

  //update user lastlogin everytime user sign in
  Future<void> updateLastLogin(DateTime time) async {
    if (uid == null) return;
    await userCollection.doc(uid).update({
      'lastLogin': Timestamp.fromDate(time),
    });
  }

  //create new report data
  Future<String> createReportData(
    String title,
    int type,
    String desc,
    String userId, {
    File? img,
    String? location,
  }) async {
    String? imgUrl = img != null ? await uploadImage(img) : null;
    final docRef = reportCollection.doc();
    await docRef.set({
      'reportId': docRef.id,
      'title': title,
      'type': type,
      'description': desc,
      'imgUrl': imgUrl,
      'location': location,
      'status': 'open',
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  //update existing report data
  Future<void> updateReportData(
    String reportId,
    String title,
    int type,
    String desc,
    String status, {
    File? img,
    String? location,
  }) async {
    String? imgUrl = img != null ? await uploadImage(img) : null;

    final docRef = reportCollection.doc(reportId);
    final updateData = {
      'title': title,
      'type': type,
      'description': desc,
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (location != null) updateData['location'] = location;
    if (imgUrl != null) {
      updateData['imgUrl'] = imgUrl;
    }
    await docRef.update(updateData);
  }

  //return current user doc stream
  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }

  //return reports stream
  Stream<QuerySnapshot> get reports {
    return reportCollection.orderBy('createdAt', descending: true).snapshots();
  }

  //return reports streams linked with current user
  Stream<QuerySnapshot> get myReports {
    return reportCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //return specific report doc stream
  Stream<DocumentSnapshot> get reportData {
    return reportCollection.doc(reportId).snapshots();
  }
}
