import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/development_assessment_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/development_assessment_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../recommendation/recommendation.dart';
import '../victim_details/victim_detail.dart';
import 'capture_development_assessment.dart';
import 'view_development_assessment.dart';

class DevelopmentAssessmentPage extends StatefulWidget {
  const DevelopmentAssessmentPage({Key? key}) : super(key: key);

  @override
  State<DevelopmentAssessmentPage> createState() =>
      _DevelopmentAssessmentPagetate();
}

class _DevelopmentAssessmentPagetate extends State<DevelopmentAssessmentPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _developmentAssessmentServiceClient = DevelopmentAssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<DevelopmentAssessmentDto> developmentAssessmentsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadDevelopmentAssessmentByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadDevelopmentAssessmentByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _developmentAssessmentServiceClient
        .getDevelopmentAssessmentsByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        developmentAssessmentsDto =
            (apiResponse.Data as List<DevelopmentAssessmentDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureDevelopmentAssessment(String? belonging, String? mastery,
      String? independence, String? generosity, String? evaluation) async {
    DevelopmentAssessmentDto addDevelopmentAssessment =
        DevelopmentAssessmentDto(
            developmentId: _randomGenerator.getRandomGeneratedNumber(),
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            createdBy: preferences!.getInt('userId')!,
            belonging: belonging,
            dateCreated: _randomGenerator.getCurrentDateGenerated(),
            mastery: mastery,
            independence: independence,
            generosity: generosity,
            evaluation: evaluation);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _developmentAssessmentServiceClient
        .addDevelopmentAssessment(addDevelopmentAssessment);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Development Assessment Successfully Created.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const DevelopmentAssessmentPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
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

  showSuccessMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text("Development Assessment"),
            leading: IconButton(
              icon: const Icon(Icons.offline_pin_rounded),
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Accepted Worklist',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AcceptedWorklistPage()),
                  );
                },
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VictimDetailPage(),
                          settings: RouteSettings(
                            arguments: acceptedWorklistDto,
                          ),
                        ),
                      );
                    },
                    heroTag: null,
                    child: const Icon(Icons.arrow_back)),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecommandationPage(),
                          settings: RouteSettings(
                            arguments: acceptedWorklistDto,
                          ),
                        ),
                      );
                    },
                    heroTag: null,
                    child: const Icon(Icons.arrow_forward)),
              ],
            ),
          ),
          drawer: GoToAssessmentDrawer(
              acceptedWorklistDto: acceptedWorklistDto, isCompleted: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            children: [
              CaptureDevelopmentAssessmentPage(
                  addDevelopmentAssessment: captureDevelopmentAssessment),
              ViewDevelopmentAssessmentPage(
                  developmentAssessmentsDto: developmentAssessmentsDto)
            ],
          ),
        ));
  }
}
