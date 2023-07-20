import 'package:flutter/material.dart';

import '../../navigation_drawer/navigationDrawerMenu.dart';
import '../../sessions/session.dart';
import 'dasboard_pages/home_page.dart';
import 'dasboard_pages/profile_page.dart';
import 'dasboard_pages/settings_page.dart';

class DashboardPage extends StatefulWidget {
  Session session;
  DashboardPage({Key? key, required this.session, required String title})
      : super(key: key);
  @override
  State<DashboardPage> createState() => _DashboardPageWidgetState();
}

class _DashboardPageWidgetState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const ProfilePage(),
    const SettingPage()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
