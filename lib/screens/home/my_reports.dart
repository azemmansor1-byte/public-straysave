import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/user.dart';
import 'package:straysave/screens/report/make_report.dart';
import 'package:straysave/screens/report/report_detail.dart';
import 'package:straysave/services/database.dart';
import 'package:straysave/shared/loading.dart';
import 'package:straysave/shared/report_card.dart';
import 'package:straysave/shared/search_bar.dart';

class MyReports extends StatefulWidget {
  final DatabaseService? databaseService;
  const MyReports({super.key, this.databaseService});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  bool loading = false;
  bool _showMakeReport = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  //Function that handle loading or when nothing to display
  Widget? handleSnapshotLoading(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Loading();
    }
    if (!snapshot.hasData) {
      return const Loading();
    }
    final reports = snapshot.data!.docs;
    if (reports.isEmpty) {
      return const Center(child: Text('No reports found'));
    }
    return null;
  }

  //Function to filter reports by query
  List<QueryDocumentSnapshot> filterReports(
    List<QueryDocumentSnapshot> reports,
    String query,
  ) {
    if (query.isEmpty) return reports;

    return reports.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = (data['title'] ?? '').toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
  }

  Widget buildReportList(
    BuildContext context,
    List<QueryDocumentSnapshot> filteredReports,
  ) {
    if (filteredReports.isEmpty) {
      return const Center(child: Text('No matching reports found'));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 80),
          itemCount: filteredReports.length,
          itemBuilder: (context, index) {
            return ReportCard(
              doc: filteredReports[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ReportDetail(reportId: filteredReports[index].id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final db = widget.databaseService ?? DatabaseService(uid: user.uid);

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            appBar: _showMakeReport
                ? null
                : AppBar(
                    backgroundColor: Color(0xFFF8F9FA),
                    elevation: 0,
                    title: Text(
                      'My Reports',
                      style: TextStyle(color: Colors.black),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _showMakeReport = true;
                          });
                        },
                      ),
                    ],
                  ),
            body: _showMakeReport
                ? MakeReport(
                    onClose: () {
                      setState(() {
                        _showMakeReport = false;
                      });
                    },
                  )
                : Stack(
                    children: [
                      //Report List
                      StreamBuilder<QuerySnapshot>(
                        stream: db.myReports,
                        builder: (context, snapshot) {
                          final isItLoading = handleSnapshotLoading(snapshot);
                          if (isItLoading != null) return isItLoading;

                          final reports = snapshot.data!.docs;

                          // filter reports
                          final filteredReports = filterReports(
                            reports,
                            _searchQuery,
                          );

                          return buildReportList(context, filteredReports);
                        },
                      ),

                      //Floating Search Bar
                      PosSearchBar(
                        controller: _searchController,
                        onChanged: (query) {
                          setState(() {
                            _searchQuery = query;
                          });
                        },
                      ),
                    ],
                  ),
          );
  }
}
