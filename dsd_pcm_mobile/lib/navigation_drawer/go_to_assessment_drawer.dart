import 'package:dsd_pcm_mobile/navigation_drawer/create_drawer_body_item.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/previous_involvement_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pcm/accepted_worklist_dto.dart';
import '../pages/assessment/capture_assessment/assessment_detail.dart';
import '../pages/assessment/capture_assessment/care_giver_detail.dart';
import '../pages/assessment/capture_assessment/child_detail/update_child_detail.dart';
import '../pages/assessment/capture_assessment/complete_assessment.dart';
import '../pages/assessment/capture_assessment/development_assessment.dart';
import '../pages/assessment/capture_assessment/education.dart';
import '../pages/assessment/capture_assessment/family/family.dart';
import '../pages/assessment/capture_assessment/family_information.dart';
import '../pages/assessment/capture_assessment/family_member.dart';
import '../pages/assessment/capture_assessment/general_detail.dart';
import '../pages/assessment/capture_assessment/health_detail.dart';
import '../pages/assessment/capture_assessment/offence_detail.dart';
import '../pages/assessment/capture_assessment/recommendation.dart';
import '../pages/assessment/capture_assessment/socio_economic.dart';
import '../pages/assessment/capture_assessment/victim_detail.dart';
import '../pages/assessment/capture_assessment/victim_organisation.dart';
import 'create_drawer_body_item_trail.dart';

// ignore: use_key_in_widget_constructors
class GoToAssessmentDrawer extends StatefulWidget {
  final AcceptedWorklistDto acceptedWorklistDto;
  final bool isCompleted;
  const GoToAssessmentDrawer(
      {Key? key,
      serverIP,
      required this.acceptedWorklistDto,
      required this.isCompleted})
      : super(key: key);

  @override
  State<GoToAssessmentDrawer> createState() =>
      _GoToAssessmentDrawerPageWidgetState();
}

class _GoToAssessmentDrawerPageWidgetState extends State<GoToAssessmentDrawer> {
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
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Child Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdateChildDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Assessment Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssessmentDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Medical Information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HealthDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Educational Information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EducationPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Care-Giver Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CareGiverDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Family Member',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyMemberPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Family Information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyInformationPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Socio-Economic Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocioEconomicPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Offence Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OffenceDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Victim',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictimDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Victim Organisation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictimOrganisationPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Previous Involvement detail',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreviousInvolvementDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Development Assessment',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevelopmentAssessmentPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Recommendation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecommandationPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'General Details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneralDetailPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted),
          createDrawerBodyItemTrail(
              icon: Icons.arrow_right,
              text: 'Complete Assessment',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompleteAssessmentPage(),
                    settings: RouteSettings(
                      arguments: widget.acceptedWorklistDto,
                    ),
                  ),
                );
              },
              status: widget.isCompleted)
        ],
      ),
    );
  }
}
