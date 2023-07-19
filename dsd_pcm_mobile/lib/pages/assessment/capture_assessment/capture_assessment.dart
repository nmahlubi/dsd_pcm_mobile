import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../navigation_drawer/navigation_drawer.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../model/pcm/query/assessment_count_query_dto.dart';
import '../../../service/pcm/assessment_service.dart';
import 'care_giver_detail.dart';
import 'child_detail/update_child_detail.dart';
import 'complete_assessment.dart';
import 'development_assessment.dart';
import 'family/family.dart';
import 'general_detail.dart';
import 'health_detail.dart';
import 'offence_detail.dart';
import 'recommendation.dart';
import 'socio_economic.dart';
import 'victim_detail.dart';

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
    //await loadAssessmentCountByIntakeAssessmentId(
    //   acceptedWorklistDto.intakeAssessmentId, acceptedWorklistDto.personId);
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
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Capture Assessment'),
          ),
          drawer: const NavigationDrawerMenu(),
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
              /*ListTile(
            title: const Text('Assessment Details'),
            trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          const Divider(thickness: 1),*/
              ListTile(
                  title: const Text('Medical Information'),
                  trailing: const Icon(Icons.check, color: Colors.green),
                  /*trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
                */
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
              /*ListTile(
            title: const Text('Education Information'),
            trailing: assessmentCountQueryDto.educationInformation == 0 ||
                    assessmentCountQueryDto.educationInformation == null
                ? const Icon(Icons.question_mark, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
            onTap: () {},
          ),
          const Divider(thickness: 1),*/
              ListTile(
                  title: const Text('Family'),
                  trailing: const Icon(Icons.check, color: Colors.green),
                  /*trailing: assessmentCountQueryDto.socioEconomicDetails == 0 ||
                    assessmentCountQueryDto.socioEconomicDetails == null
                ? const Icon(Icons.close, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
                */
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
                trailing: const Icon(Icons.check, color: Colors.green),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CareGiverDetailPage(),
                      settings: RouteSettings(
                        arguments: acceptedWorklistDto,
                      ),
                    ),
                  );
                },
              ),
              const Divider(thickness: 1),
              ListTile(
                title: const Text('Socio-Economic Details'),
                trailing: const Icon(Icons.check, color: Colors.green),
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
                  trailing: const Icon(Icons.check, color: Colors.green),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OffenceDetailPage(),
                        settings: RouteSettings(
                          arguments: acceptedWorklistDto,
                        ),
                      ),
                    );
                  }),
              const Divider(thickness: 1),
              ListTile(
                  title: const Text('Victim Details'),
                  trailing: const Icon(Icons.check, color: Colors.green),
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
                  trailing: const Icon(Icons.check, color: Colors.green),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DevelopmentAssessmentPage(),
                        settings: RouteSettings(
                          arguments: acceptedWorklistDto,
                        ),
                      ),
                    );
                  }),
              const Divider(thickness: 1),
              ListTile(
                  title: const Text('Recommandation'),
                  trailing: const Icon(Icons.check, color: Colors.green),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecommandationPage(),
                        settings: RouteSettings(
                          arguments: acceptedWorklistDto,
                        ),
                      ),
                    );
                  }),
              const Divider(thickness: 1),
              ListTile(
                  title: const Text('General Details'),
                  trailing: const Icon(Icons.check, color: Colors.green),
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
            label: const Text("Complete"),
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompleteAssessmentPage(),
                  settings: RouteSettings(
                    arguments: acceptedWorklistDto,
                  ),
                ),
              );
            },
          ),
        ));
  }
}
