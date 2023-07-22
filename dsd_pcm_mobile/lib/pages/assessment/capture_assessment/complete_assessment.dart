import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/request/request_complete_assessment.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
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
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
        });
      });
    });
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
