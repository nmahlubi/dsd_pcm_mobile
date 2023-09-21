import 'package:dsd_pcm_mobile/model/pcm/recommendations_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/create_drawer_body_item.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/order_detail.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home_based_diversion/home_based_diversion_detail/home_based_supervision_detail.dart';

// ignore: use_key_in_widget_constructors
class GoToRecommendationDrawer extends StatefulWidget {
  final RecommendationDto recommendationDto;
  const GoToRecommendationDrawer({Key? key, serverIP, required this.recommendationDto}) : super(key: key);

  @override
  State<GoToRecommendationDrawer> createState() =>
      _GoToRecommendationDrawerPageWidgetState();
}

class _GoToRecommendationDrawerPageWidgetState
    extends State<GoToRecommendationDrawer> {
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
            text: 'Orders',
            onTap: () =>
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.recommendationDto,
                    ),
                  ),
                ),
          ),
           createDrawerBodyItem(
            icon: Icons.inbox,
            text: 'Service Provider',
            onTap: () =>
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServiceProviderPage(),
                    settings: RouteSettings(
                      arguments: widget.recommendationDto,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
