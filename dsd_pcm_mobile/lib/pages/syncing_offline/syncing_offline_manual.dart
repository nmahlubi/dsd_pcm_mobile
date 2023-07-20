import 'package:flutter/material.dart';

import '../../navigation_drawer/navigationDrawerMenu.dart';
import 'sync_offline_pages/lookup_sync_offline_manual.dart';
import 'sync_offline_pages/worklist_sync_offline_manual.dart';

class SyncingOfflineManualPage extends StatefulWidget {
  const SyncingOfflineManualPage({Key? key}) : super(key: key);

  @override
  State<SyncingOfflineManualPage> createState() =>
      _SyncingOfflineManualPageWidgetState();
}

class _SyncingOfflineManualPageWidgetState
    extends State<SyncingOfflineManualPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const LookupSyncOfflineManualPage(),
    const WorklistSyncOfflineManualPage(),
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
        title: const Text('Syncing Offline'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Look Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_off_sharp),
            label: 'Worklist',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
