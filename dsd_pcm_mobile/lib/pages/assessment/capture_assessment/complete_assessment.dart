import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../background_job/background_job_offline.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/query/assessment_count_query_dto.dart';
import '../../../model/pcm/request/request_complete_assessment.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/assessment_service.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../widgets/list_tile_widget.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'child_detail/update_child_detail.dart';
import 'health_detail.dart';

class CompleteAssessmentPage extends StatefulWidget {
  const CompleteAssessmentPage({Key? key}) : super(key: key);

  @override
  State<CompleteAssessmentPage> createState() => _CompleteAssessmentPageState();
}

class _CompleteAssessmentPageState extends State<CompleteAssessmentPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _worklistServiceClient = WorklistService();
  final _backgroundJobOffline = BackgroundJobOffline();
  final _assessmentService = AssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  int? intakeAssessmentId = 0;
  int? childDetails = 0;
  int? assesmentDetails = 0;
  int? medicalInformation = 0;
  int? educationInformation = 0;
  int? careGiverDetail = 0;
  int? familyMember = 0;
  int? familyInformation = 0;
  int? socioEconomicDetails = 0;
  int? offenceDetails = 0;
  int? victimDetails = 0;
  int? victimOrganizationDetails = 0;
  int? developmentAssessment = 0;
  int? recommendation = 0;
  int? generalDetails = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          syncToCompleteAssessment(acceptedWorklistDto);
          //loadAssessmentStatus(acceptedWorklistDto.intakeAssessmentId,
          //   acceptedWorklistDto.personId);
        });
      });
    });
  }

  syncToCompleteAssessment(AcceptedWorklistDto acceptedWorklist) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    try {
      await _backgroundJobOffline.syncAcceptedWorklist(
          acceptedWorklist, preferences!.getInt('userId')!);
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage("Synced successfully");
    } on SocketException {
      overlay.hide();
      showDialogMessage('Unable to sync offline data.');
    }

    loadAssessmentStatus(
        acceptedWorklistDto.intakeAssessmentId, acceptedWorklistDto.personId);
  }

  loadAssessmentStatus(int? intakeAssessmentId, int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _assessmentService.getAssessmentCountById(
        intakeAssessmentId, personId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        if (apiResponse.Data != null) {
          AssessmentCountQueryDto responseAssessmentCountQueryDto =
              (apiResponse.Data as AssessmentCountQueryDto);
          childDetails = responseAssessmentCountQueryDto.childDetails;
        }
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError).error);
    }
  }

  completeWorklist() async {
    RequestToCompleteAssessmentDto requestToCompleteAssessmentDto =
        RequestToCompleteAssessmentDto(
            assessmentRegisterId: acceptedWorklistDto.assessmentRegisterId,
            caseId: acceptedWorklistDto.caseId,
            worklistId: acceptedWorklistDto.worklistId,
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            personId: acceptedWorklistDto.personId,
            clientId: acceptedWorklistDto.clientId,
            emailAddess: 'eric',
            createdBy: preferences!.getInt('userId')!);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _worklistServiceClient
        .completeWorklist(requestToCompleteAssessmentDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Assessment Successfully Completed.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const AcceptedWorklistPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError).error);
    }
  }

  showDialogMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.red),
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
            title: const Text("Complete Assessment"),
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
          body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
              child: Form(
                  key: _loginFormKey,
                  child: ListView(children: [
                    Row(children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                      //sddfffdffdf
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Text(
                                            'Assessment Detail',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w200,
                                                fontSize: 21),
                                          ),
                                        ),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Child Details',
                                            status: childDetails == 0
                                                ? false
                                                : true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Assessment Details',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Medical Information',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Educational Information',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Family Member',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Family Information',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Child Details',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Child Details',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Child Details',
                                            status: true),
                                        listTileWidget(
                                            icon: Icons.arrow_right,
                                            text: 'Child Details',
                                            status: true),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 10, 2),
                                            )),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                23,
                                                                22,
                                                                22),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        if (_loginFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          completeWorklist();
                                                        }
                                                      },
                                                      child: const Text(
                                                          'Complete Assessment'),
                                                    ))),
                                          ],
                                        ),
                                      ])
                                  //card inf
                                  )))
                    ]),
                  ]))),
        ));
  }
}
