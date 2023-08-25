import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/program_enrolment_session_outcome_dto.dart';
import '../../../../model/pcm/programs_enrolled_dto.dart';
import '../../../../model/pcm/query/homebased_diversion_query_dto.dart';
import '../../../../navigation_drawer/go_to_home_based_diversion_drawer.dart';
import '../../../../service/pcm/diversion_service.dart';
import '../../../../service/pcm/program_enrolment_session_outcome_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../home_based_diversion.dart';

class DiversionProgrammeSession extends StatefulWidget {
  const DiversionProgrammeSession({Key? key}) : super(key: key);

  @override
  State<DiversionProgrammeSession> createState() =>
      _DiversionProgrammeSessionState();
}

class _DiversionProgrammeSessionState extends State<DiversionProgrammeSession> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final ProgramEnrollmentSessionOutcomeService
      programEnrollmentSessionOutcomeService =
      ProgramEnrollmentSessionOutcomeService();
  late HomebasedDiversionQueryDto homebasedDiversionQueryDto =
      HomebasedDiversionQueryDto();
  late ProgramEnrolmentSessionOutcomeDto programEnrolmentSessionOutcomeDto =
      ProgramEnrolmentSessionOutcomeDto();
  final _randomGenerator = RandomGenerator();
  final _diversionServiceClient = DiversionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<ProgramEnrolmentSessionOutcomeDto> programsEnrolledDto = [];
  //late ProgramsEnrolledDto programsEnrolled = ProgramsEnrolledDto();

  ExpandableController captureProgrammeEnrolledSessionController =
      ExpandableController();
  ExpandableController viewProgrammeEnrolledSessionPanelController =
      ExpandableController();
  final TextEditingController sessionOutcomeController =
      TextEditingController();
  final TextEditingController dateCapturedSessionController =
      TextEditingController();
  int? sessionId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureProgrammeEnrolledSessionController =
        ExpandableController(initialExpanded: false);
    viewProgrammeEnrolledSessionPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Programm Session';
    sessionId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          programEnrolmentSessionOutcomeDto = ModalRoute.of(context)!
              .settings
              .arguments as ProgramEnrolmentSessionOutcomeDto;

          loadProgrammEnrollement(
              programEnrolmentSessionOutcomeDto.enrolmentID);
        });
      });
    });
  }

  loadProgrammEnrollement(int? $enrollmentID) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await programEnrollmentSessionOutcomeService
        .getProgramEnrollmentSessionOutcome($enrollmentID);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programsEnrolledDto =
            (apiResponse.Data as List<ProgramEnrolmentSessionOutcomeDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  addUpdateProgrammeSession() async {
    ProgramEnrolmentSessionOutcomeDto captureProgramEnrolmentSessionOutcomeDto =
        ProgramEnrolmentSessionOutcomeDto(
      sessionId: programEnrolmentSessionOutcomeDto.sessionId,
      enrolmentID: programEnrolmentSessionOutcomeDto.enrolmentID,
      programModuleId: programEnrolmentSessionOutcomeDto.programModuleId,
      sessionOutCome: sessionOutcomeController.text,
      sessionDate: dateCapturedSessionController.text,
      createdBy: preferences!.getInt('userId')!,
      modifiedBy: preferences!.getInt('userId')!,
      programModuleSessionsId:
          programEnrolmentSessionOutcomeDto.programModuleSessionsId,
      dateCreated: _randomGenerator.getCurrentDateGenerated(),
    );

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _diversionServiceClient
        .addSessionOutcome(captureProgramEnrolmentSessionOutcomeDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage("Successfull $labelButtonAddUpdate");
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const HomeBasedDiversionPage(),
            settings: RouteSettings(
              arguments: homebasedDiversionQueryDto,
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

  newFamilyInformation() {
    setState(() {
      labelButtonAddUpdate = 'Add Session';
      sessionOutcomeController.clear();
      sessionId = null;
    });
  }

  @override
  void dispose() {
    sessionOutcomeController.dispose();
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
              title: const Text("Programme Session"),
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
                  tooltip: 'Home Based Diversion',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeBasedDiversionPage()),
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
                                const HomeBasedDiversionPage(),
                            settings: RouteSettings(
                              arguments: homebasedDiversionQueryDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                ],
              ),
            ),
            drawer: GoToHomeBasedDiversionDrawer(
                homebasedDiversionQueryDto: homebasedDiversionQueryDto),
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
                                        captureProgrammeEnrolledSessionController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Programme Session",
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
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize: const Size
                                                            .fromHeight(10),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                244,
                                                                248,
                                                                246),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        newFamilyInformation();
                                                      },
                                                      child: const Text('New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
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
                                                      dateCapturedSessionController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Session Date',
                                                  ),
                                                  readOnly:
                                                      true, // when true user cannot edit text
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime
                                                                .now(), //get today's date
                                                            firstDate: DateTime(
                                                                1800), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2101));

                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      dateCapturedSessionController
                                                          .text = formattedDate;
                                                      //You can format date as per your need
                                                    }
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
                                                      sessionOutcomeController,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Session Outcome',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Session Outcome Required';
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
                                                          addUpdateProgrammeSession();
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
