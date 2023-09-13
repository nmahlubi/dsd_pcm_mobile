import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/previous_involvement_detail.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/development_assessment_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/development_assessment_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'recommendation.dart';
import 'victim_organisation.dart';

class DevelopmentAssessmentPage extends StatefulWidget {
  const DevelopmentAssessmentPage({Key? key}) : super(key: key);

  @override
  State<DevelopmentAssessmentPage> createState() =>
      _DevelopmentAssessmentPagetate();
}

class _DevelopmentAssessmentPagetate extends State<DevelopmentAssessmentPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _developmentAssessmentServiceClient = DevelopmentAssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  ExpandableController captureDevelopmentAssessmentPanelController =
      ExpandableController();
  final TextEditingController belongingController = TextEditingController();
  final TextEditingController masteryController = TextEditingController();
  final TextEditingController independenceController = TextEditingController();
  final TextEditingController generosityController = TextEditingController();
  final TextEditingController evaluationController = TextEditingController();
  int? developmentAssessmentId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureDevelopmentAssessmentPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Assessment';
    developmentAssessmentId = null;
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
        .getDevelopmentAssessmentByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        if (apiResponse.Data != null) {
          DevelopmentAssessmentDto developmentAssessmentDto =
              (apiResponse.Data as DevelopmentAssessmentDto);
          labelButtonAddUpdate = 'Update Assessment';
          developmentAssessmentId = developmentAssessmentDto.developmentId;
          belongingController.text = developmentAssessmentDto.belonging!;
          masteryController.text = developmentAssessmentDto.mastery!;
          independenceController.text = developmentAssessmentDto.independence!;
          generosityController.text = developmentAssessmentDto.generosity!;
          evaluationController.text = developmentAssessmentDto.evaluation!;
        }
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  addUpdateDevelopmentAssessment() async {
    DevelopmentAssessmentDto addDevelopmentAssessment =
        DevelopmentAssessmentDto(
            developmentId: developmentAssessmentId ??
                _randomGenerator.getRandomGeneratedNumber(),
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            createdBy: preferences!.getInt('userId')!,
            belonging: belongingController.text,
            dateCreated: _randomGenerator.getCurrentDateGenerated(),
            mastery: masteryController.text,
            independence: independenceController.text,
            generosity: generosityController.text,
            evaluation: evaluationController.text);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _developmentAssessmentServiceClient
        .addUpdateDevelopmentAssessment(addDevelopmentAssessment);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const DevelopmentAssessmentPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
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

  showSuccessMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    belongingController.dispose();
    masteryController.dispose();
    independenceController.dispose();
    generosityController.dispose();
    evaluationController.dispose();
    super.dispose();
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
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PreviousInvolvementDetailPage(),
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
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        captureDevelopmentAssessmentPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Development Assessment",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      belongingController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Belonging',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Belonging';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller: masteryController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Mastery',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Mastery';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      independenceController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Independence',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Independence';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      generosityController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Generosity',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Generosity';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      evaluationController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Evaluation',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter Evaluation';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
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
                                                          addUpdateDevelopmentAssessment();
                                                        }
                                                      },
                                                      child: Text(
                                                          labelButtonAddUpdate!),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                      ]),
                    ],
                  ),
                ))));
  }
}
