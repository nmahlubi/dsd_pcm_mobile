import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../navigation_drawer/navigation_drawer.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../model/pcm/query/assessment_count_query_dto.dart';
import '../../../service/pcm/assessment_service.dart';
import '../view_child_details.dart';
import 'capture_recommendation/capture_recommendation_detail.dart';
import 'child_detail/update_child_detail.dart';
import 'family/family.dart';
import 'general_details/general_detail.dart';
import 'health_detail/health_detail.dart';
import 'offence_details/capture_offence_detail.dart';
import 'socio_economic/socio_economic.dart';
import 'victim_details/victim_detail.dart';

class CaptureAssessmentPage extends StatefulWidget {
  const CaptureAssessmentPage({Key? key}) : super(key: key);

  @override
  State<CaptureAssessmentPage> createState() => _CaptureAssessmentPageState();
}

class _CaptureAssessmentPageState extends State<CaptureAssessmentPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final AssessmentService assessmentServiceClient = AssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  late AssessmentCountQueryDto assessmentCountQueryDto =
      AssessmentCountQueryDto();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          initializeControlValues(acceptedWorklistDto);
        });
      });
    });
  }

  initializeControlValues(AcceptedWorklistDto acceptedWorklistDto) async {
    await loadAssessmentCountByIntakeAssessmentId(
        acceptedWorklistDto.intakeAssessmentId, acceptedWorklistDto.personId);
  }

  loadAssessmentCountByIntakeAssessmentId(
      int? intakeAssessmentId, int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await assessmentServiceClient
        .getAssessmentCountByIntakeAssessmentId(intakeAssessmentId, personId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        assessmentCountQueryDto = (apiResponse.Data as AssessmentCountQueryDto);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Assessment'),
      ),
      drawer: const NavigationDrawer(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Child Details'),
            trailing: const Icon(Icons.check, color: Colors.green),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateChildDetailPage(),
                  settings: RouteSettings(
                    arguments: acceptedWorklistDto,
                  ),
                ),
              );
            },
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Assessment Details'),
            trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Medical Information'),
              trailing: assessmentCountQueryDto.familyMember == 0 ||
                      assessmentCountQueryDto.familyMember == null
                  ? const Icon(Icons.question_mark, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HealthDetailPage(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Education Information'),
            trailing: assessmentCountQueryDto.educationInformation == 0 ||
                    assessmentCountQueryDto.educationInformation == null
                ? const Icon(Icons.question_mark, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Family'),
              trailing: assessmentCountQueryDto.familyMember == 0 ||
                      assessmentCountQueryDto.familyMember == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyPage(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Care Given Details'),
            trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          const Divider(thickness: 1),
          ListTile(
            title: const Text('Socio-Economic Details'),
            trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SocioEconomicPage(),
                  settings: RouteSettings(
                    arguments: acceptedWorklistDto,
                  ),
                ),
              );
            },
          ),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Offence Details'),
              trailing: assessmentCountQueryDto.offenceDetails == 0 ||
                      assessmentCountQueryDto.offenceDetails == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CaptureOffenceDetailPage(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Victim Details'),
              trailing: assessmentCountQueryDto.victimDetails == 0 ||
                      assessmentCountQueryDto.victimDetails == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VictimDetailPage(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Development Assessment'),
              trailing: assessmentCountQueryDto.developmentAssessment == 0 ||
                      assessmentCountQueryDto.developmentAssessment == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {}),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('Recommandation'),
              trailing: assessmentCountQueryDto.recommendation == 0 ||
                      assessmentCountQueryDto.recommendation == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CaptureRecommendationDetail(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
          ListTile(
              title: const Text('General Details'),
              trailing: assessmentCountQueryDto.generalDetails == 0 ||
                      assessmentCountQueryDto.generalDetails == null
                  ? const Icon(Icons.close, color: Colors.red)
                  : const Icon(Icons.check, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneralDetailPage(),
                    settings: RouteSettings(
                      arguments: acceptedWorklistDto,
                    ),
                  ),
                );
              }),
          const Divider(thickness: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Back"),
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ViewChildDetailsPage(),
              settings: RouteSettings(
                arguments: acceptedWorklistDto,
              ),
            ),
          );
        },
      ),
    );
  }
}
