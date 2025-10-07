import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String? username;
  final String? email;
  final String? phoneNo;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final String? profileImageUrl;
  final DateTime? lastLogin;
  final int reportsCount;
  final Map<String, bool>? alertPreference;

  User({
    required this.uid,
    this.username,
    this.email,
    this.phoneNo,
    this.role = 'resident',
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.profileImageUrl,
    this.lastLogin,
    this.reportsCount = 0,
    this.alertPreference,
  });

  /// Factory method to create User from Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      username: data['username'] as String?,
      email: data['email'] as String?,
      phoneNo: data['phoneNo'] as String?,
      role: data['role'] as String? ?? 'resident',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] as bool? ?? true,
      profileImageUrl: data['profileImageUrl'] as String?,
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      reportsCount: data['reportsCount'] as int? ?? 0,
      alertPreference: (data['alertPreference'] as Map?)?.map(
        (key, value) => MapEntry(key as String, value as bool),
      ),
    );
  }
}
