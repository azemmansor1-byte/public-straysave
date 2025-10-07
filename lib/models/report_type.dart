import 'package:flutter/material.dart';

class ReportType {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  const ReportType(this.id, this.name, this.icon, this.color);
}

final List<ReportType> reportTypes = [
  ReportType(0, "Stray", Icons.pets, Colors.green),
  ReportType(1, "Lost", Icons.search, Colors.orange),
  ReportType(2, "Dangerous", Icons.warning, Colors.red),
];

ReportType? selectedType;

ReportType getReportTypeFromId(int id) {
  return reportTypes.firstWhere(
    (type) => type.id == id,
    orElse: () => ReportType(-1, 'Unknown', Icons.help, Colors.grey),
  );
}
