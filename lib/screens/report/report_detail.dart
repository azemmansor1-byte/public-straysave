import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:straysave/models/report_type.dart';
import 'package:straysave/services/database.dart';
import 'package:straysave/shared/cached_image.dart';
import 'package:straysave/shared/info_tile.dart';
import 'package:straysave/shared/loading.dart';

class ReportDetail extends StatefulWidget {
  final DatabaseService? databaseService;
  final String reportId; // Pass the report document ID

  const ReportDetail({super.key, required this.reportId, this.databaseService});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  bool loading = false;

  DatabaseService get db =>
      widget.databaseService ?? DatabaseService(reportId: widget.reportId);
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Report Details',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: StreamBuilder<DocumentSnapshot>(
              stream: db.reportData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Report not found"));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                final title = data['title'] ?? 'No title';
                final description =
                    data['description'] ?? 'no description data';
                final location = data['location'] ?? 'no location data';
                final phone = data['phone'] ?? '#ADD RESIDENT DATABASE';
                final createdAt = data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                          .split(' ')[0]
                    : '';
                final status = data['status'] ?? 'Open';
                final type = data['type'] ?? 'Unknown';
                final imgUrl = data['imgUrl'] as String?;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report Image
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CachedImage(imgUrl: imgUrl),
                      ),
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Location
                      InkWell(
                        onTap: () => debugPrint("Location tapped"),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                location,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Phone
                      InkWell(
                        onTap: () => debugPrint("Phone tapped"),
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(phone, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      // Side info row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoTile(
                              label: "Created",
                              value: createdAt,
                              icon: Icons.calendar_today,
                            ),
                            InfoTile(
                              label: "Status",
                              value: status,
                              icon: Icons.flag,
                              color: status.toLowerCase() == "open"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            InfoTile(
                              label: "Type",
                              value: getReportTypeFromId(type).name,
                              icon: Icons.category,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
