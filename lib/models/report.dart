import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String title;
  final int type;
  final String desc;
  final String? imgUrl;
  final GeoPoint? location;
  final String status;
  final Timestamp createdAt;
  final String residentId;

  Report({
    required this.title,
    required this.type,
    required this.desc,
    this.imgUrl,
    this.location,
    this.status = "open",
    required this.createdAt,
    required this.residentId,
  });
}
