import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/general_detail_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/general_detail_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../child_detail/update_child_detail.dart';
import '../development_assessment/development_assessment.dart';
import '../health_detail/health_detail.dart';

class AssessmentDetailPage extends StatefulWidget {
  const AssessmentDetailPage({Key? key}) : super(key: key);

  @override
  State<AssessmentDetailPage> createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _randomGenerator = RandomGenerator();
  final _generalDetailServiceClient = GeneralDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<GeneralDetailDto> generalDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadGeneralDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadGeneralDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _generalDetailServiceClient
        .getGeneralDetailByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        generalDetailsDto = (apiResponse.Data as List<GeneralDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureGeneralDetail(String? consultedSources, String? traceEfforts,
      String? commentsBySupervisor, String? additionalInfo) async {
    GeneralDetailDto generalDetailDto = GeneralDetailDto(
        generalDetailsId: _randomGenerator.getRandomGeneratedNumber(),
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        consultedSources: consultedSources,
        traceEfforts: traceEfforts,
        commentsBySupervisor: commentsBySupervisor,
        additionalInfo: additionalInfo);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await _generalDetailServiceClient.addGeneralDetail(generalDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Assessment Details Successfully Created.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const AssessmentDetailPage(),
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
            title: const Text("Assessment Details"),
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
                          builder: (context) => const UpdateChildDetailPage(),
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
                          builder: (context) => const HealthDetailPage(),
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
              /*CaptureGeneralDetailPage(
                  addNewGeneralDetail: captureGeneralDetail),
              ViewGeneralDetailPage(generalDetailsDto: generalDetailsDto)*/
            ],
          ),
        ));
  }
}
