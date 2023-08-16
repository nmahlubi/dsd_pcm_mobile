import 'package:dsd_pcm_mobile/model/pcm/query/homebased_diversion_query_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/create_drawer_body_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/home_based_diversion/home_based_diversion_detail/diversion/diversion_programs_enrolled.dart';
import '../pages/home_based_diversion/home_based_diversion_detail/home_based_supervision_detail.dart';

// ignore: use_key_in_widget_constructors
class GoToHomeBasedDiversionDrawer extends StatefulWidget {
   final HomebasedDiversionQueryDto homebasedDiversionQueryDto;
  const GoToHomeBasedDiversionDrawer({Key? key, serverIP, required this.homebasedDiversionQueryDto}) : super(key: key);

  @override
  State<GoToHomeBasedDiversionDrawer> createState() =>
      _GoToHomeBasedDiversionDrawerPageWidgetState();
}

class _GoToHomeBasedDiversionDrawerPageWidgetState
    extends State<GoToHomeBasedDiversionDrawer> {
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
            padding: const EdgeInsets.all(4),
            child: const Text(
              'GO TO',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),
          const Divider(),
          createDrawerBodyItem(
            icon: Icons.inbox,
            text: 'Diversion',
            onTap: () =>
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgrammesEnrolledDetailsPage(),
                    settings: RouteSettings(
                      arguments: widget.homebasedDiversionQueryDto,
                    ),
                  ),
                ),
          ),
      
          createDrawerBodyItem(
            icon: Icons.inbox,
            text: 'HomeBased',
            onTap: () =>
               // Navigator.pushReplacementNamed(context, '/home-based'),
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeBasedSupervisionDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.homebasedDiversionQueryDto,
                    ),
                  ),
                ),
          ),
          
        ],
      ),
    );
  }
}
