import 'package:flutter/material.dart';
import 'package:straysave/screens/authenticate/authenticate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showAuth = false;
  bool _startWithSignIn = true;

  @override
  Widget build(BuildContext context) {
    if (_showAuth) {
      return Authenticate(startWithSignIn: _startWithSignIn);
    }

    // normal splash view
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.pets, size: 100, color: Colors.blue),
                      const SizedBox(height: 30),
                      const Text(
                        'StraySave',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Community Animal Management System',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAuth = true;
                            _startWithSignIn = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Log In'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAuth = true;
                            _startWithSignIn = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    '© 2025 StraySave. All rights reserved.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}