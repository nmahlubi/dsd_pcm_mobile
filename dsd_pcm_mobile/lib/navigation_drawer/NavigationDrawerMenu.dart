import 'package:dsd_pcm_mobile/navigation_drawer/create_drawer_body_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: use_key_in_widget_constructors
class NavigationDrawerMenu extends StatefulWidget {
  const NavigationDrawerMenu({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerMenu> createState() =>
      _NavigationDrawerMenuWidgetState();
}

class _NavigationDrawerMenuWidgetState extends State<NavigationDrawerMenu> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Welcome ${preferences?.getString('firstname')}',
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),
          const Divider(),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Dashboard',
            onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
          ),
          if (preferences?.getBool('supervisor') == true)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'Inbox',
              onTap: () => Navigator.pushReplacementNamed(
                  context, '/notification-cases'),
            ),
          if (preferences?.getBool('supervisor') == true)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'Overdue Cases',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/overdue-cases'),
            ),
          if (preferences?.getBool('supervisor') == true)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'ReAllocate Case',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/re-assigned-cases'),
            ),
          if (preferences?.getBool('supervisor') == false)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'Incoming Cases',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/allocated-cases'),
            ),
          if (preferences?.getBool('supervisor') == false)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'My Worklist',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/accepted-worklist'),
            ),
          if (preferences?.getBool('supervisor') == false)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'Preliminary',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/preliminary'),
            ),
          if (preferences?.getBool('supervisor') == false)
            createDrawerBodyItem(
              icon: Icons.inbox,
              text: 'Diversion & HBS',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/home-based'),
            ),
          const Divider(),
          createDrawerBodyItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            title: const Text('App version 3.0.0.0',
                style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
