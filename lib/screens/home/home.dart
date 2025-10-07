import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:straysave/screens/home/authorities.dart';
import 'package:straysave/screens/home/my_reports.dart';
import 'package:straysave/screens/home/profile.dart';
import 'package:straysave/screens/home/reports.dart';
import 'package:straysave/screens/home/scan.dart';
import 'package:straysave/screens/report/make_report.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _showMakeReport = false;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
      _showMakeReport = false;
    });
  }

  final List<Widget> _pages = [
    Reports(),
    Scan(),
    MyReports(),
    Authorities(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop =
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit the app?'),
                content: const Text('are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: _showMakeReport
            ? MakeReport(
                onClose: () {
                  setState(() {
                    _showMakeReport = false;
                  });
                },
              )
            : _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFF8F9FA),
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Scan'),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'My Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Authorities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_4),
              label: 'Profile',
            ),
          ],
          fixedColor: Colors.blue,
        ),
      ),
    );
  }
}
