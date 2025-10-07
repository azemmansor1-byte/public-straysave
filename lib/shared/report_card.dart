import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:straysave/models/report_type.dart';
import 'package:straysave/shared/cached_image.dart';

//that cards in reports and my reports
class ReportCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    final title = data['title'] ?? 'No title';
    final type = data['type'] ?? 'Unknown';
    final status = data['status'] ?? 'Open';
    final timestamp = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : null;
    final imgUrl = data['imgUrl'] as String?;
    final location = data['location'] ?? '';

    // Build subtitle: type • time ago • location
    String subtitleText = getReportTypeFromId(type).name;
    if (timestamp != null) {
      subtitleText += " • ${timeAgo(timestamp)}";
    }
    if (location.isNotEmpty) {
      subtitleText += " • $location";
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      shape: BeveledRectangleBorder(side: BorderSide(style: BorderStyle.none)),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: _buildThumbnail(imgUrl),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: statusBadge(status),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    const double size = 40;
    return CachedImage(
      imgUrl: url,
      width: size,
      height: size,
      placeholderSize: size,
      borderRadius: 6,
    );
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget statusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'open':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'closed':
        color = Colors.grey;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
