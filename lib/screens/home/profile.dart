import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/user.dart' as model;
import 'package:straysave/services/auth.dart';
import 'package:straysave/shared/loading.dart';

class Profile extends StatefulWidget {
  final AuthService? auth;
  const Profile({super.key, this.auth});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthService _auth;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _auth = widget.auth ?? AuthService();
  }

  void _logout() async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('Log out of your account?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await _auth.signOut();
    }
  }

  void _showEditDialog() {}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<model.User?>(context);

    if (loading) return const Loading();
    if (user == null) return const Center(child: Text("No user data"));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user.profileImageUrl ?? 'https://i.pravatar.cc/150',
              ),
            ),
            const SizedBox(height: 15),
            Text(
              user.username ?? 'No Name',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user.email ?? 'No Email',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 5),
            Text(
              user.phoneNo ?? 'No Phone',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // Profile stats
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.pets, color: Colors.orange),
                        const SizedBox(height: 5),
                        Text(
                          "${user.reportsCount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Text("Reports"),
                      ],
                    ),
                    Container(width: 1, height: 40, color: Colors.grey[300]),
                    Column(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(height: 5),
                        Text(
                          user.createdAt != null
                              ? "${user.createdAt!.year}-${user.createdAt!.month}-${user.createdAt!.day}"
                              : "N/A",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Text("Member Since"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: _showEditDialog,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile / Change Password"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Admin Mode activated (fake)"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Administrator Mode (Fake)"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
