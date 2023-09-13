import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsd_pcm_mobile/connectivity_check/network_controller.dart';
import 'package:flutter/material.dart';

import '../../navigation_drawer/navigation_drawer_menu.dart';
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
  bool hasInternet = false;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const ProfilePage(),
    const SettingPage(),
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
        //check the network status and update
        actions: [
          StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NetworkStatus(snapshot.data as ConnectivityResult);
              } else {
                return SizedBox(); // Return an empty SizedBox if no data
              }
            },
          ),
        ],
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
