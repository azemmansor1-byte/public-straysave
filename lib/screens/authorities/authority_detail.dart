import 'package:flutter/material.dart';
import 'package:straysave/shared/loading.dart';

class AuthorityDetail extends StatefulWidget {
  const AuthorityDetail({super.key});

  @override
  State<AuthorityDetail> createState() => _AuthorityDetailState();
}

class _AuthorityDetailState extends State<AuthorityDetail> {
  bool loading = false;

  // Fake Authority Data
  final String name = "SPCA Selangor";
  final String description =
      "The Society for the Prevention of Cruelty to Animals (SPCA) "
      "is dedicated to animal welfare, rescues, and rehoming.";
  final String location = "Ampang Jaya, Selangor";
  final String phone = "+60 3-4256 5312";
  final String email = "spca@example.com";
  final String operationTime = "Mon - Sun, 9am - 6pm";
  final String createdAt = "2025-10-03";
  final String type = "Animal Welfare";
  final ImageProvider? image = NetworkImage('https://i.pravatar.cc/500');

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
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
                'Authority Details',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Authority Image
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: image!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Authority Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  // Contact No
                  InkWell(
                    onTap: () {
                      debugPrint("Phone tapped");
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Email
                  InkWell(
                    onTap: () {
                      debugPrint("Email tapped");
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.email, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Location
                  InkWell(
                    onTap: () {
                      debugPrint("Location tapped");
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Ampang Jaya, Selangor",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Operation Time
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text(
                        operationTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
