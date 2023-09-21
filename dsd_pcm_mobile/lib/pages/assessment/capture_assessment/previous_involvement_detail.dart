import 'package:dsd_pcm_mobile/model/intake/offence_category_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/accepted_worklist_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/previousInvolvement_detail_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/go_to_assessment_drawer.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/development_assessment.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/family_member.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/health_detail.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/victim_organisation.dart';
import 'package:dsd_pcm_mobile/pages/probation_officer/accepted_worklist.dart';
import 'package:dsd_pcm_mobile/service/pcm/previous_involvement_detail_service.dart';
import 'package:dsd_pcm_mobile/transform_dynamic/transform_offence.dart';
import 'package:dsd_pcm_mobile/util/shared/apierror.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresponse.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresults.dart';
import 'package:dsd_pcm_mobile/util/shared/loading_overlay.dart';
import 'package:dsd_pcm_mobile/util/shared/randon_generator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousInvolvementDetailPage extends StatefulWidget {
  const PreviousInvolvementDetailPage({Key? key}) : super(key: key);

  @override
  State<PreviousInvolvementDetailPage> createState() =>
      _PreviousInvolvementDetailPageState();
}

class _PreviousInvolvementDetailPageState
    extends State<PreviousInvolvementDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _previousInvolvementDetailClient = PreviousInvolvementDetailService();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _offenceTransform = OffenceTransform();
  final _randomGenerator = RandomGenerator();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<OffenceCategoryDto> offenceCategoryDto = [];
  late List<PreviousInvolvementDetailDto> previousInvolvementDetailDto = [];

  ExpandableController capturePreviousInvolvementDetailPanelController =
      ExpandableController();
  ExpandableController viewPreviousInvolvementDetailPanelPanelController =
      ExpandableController();
  final TextEditingController isArrestController = TextEditingController();

  final TextEditingController ispreviousInvolvedController =
      TextEditingController();
  final TextEditingController previousArrestDateController =
      TextEditingController();
  final TextEditingController sentenceOutcomesController =
      TextEditingController();
  final TextEditingController isConvictedController = TextEditingController();
  final TextEditingController convictionDateController =
      TextEditingController();
  final TextEditingController isEscapeController = TextEditingController();
  final TextEditingController escapesDateController = TextEditingController();
  final TextEditingController escapeTimeController = TextEditingController();
  final TextEditingController placeOfEscapeController = TextEditingController();

  int? natureOfOffenceDropdownButtonFormField;
  int? involvementId;
  String? labelButtonAddUpdate = '';
  // radio button
  String? previousInvolved = 'No';
  String? wasPreviousArrest = 'No';
  String? wasChildConvictedPreviously = 'No';
  String? anyPreviousEscape = 'No';

  @override
  void initState() {
    super.initState();
    capturePreviousInvolvementDetailPanelController =
        ExpandableController(initialExpanded: false);
    viewPreviousInvolvementDetailPanelPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Previous Involvement Crime';
    involvementId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadPreviousInvolvementDetailByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    offenceCategoryDto = await _offenceTransform.transformOffenceCategoryDto();
    overlay.hide();
  }

  loadPreviousInvolvementDetailByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _previousInvolvementDetailClient
        .getPreviousInvolvementDetailByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        previousInvolvementDetailDto =
            (apiResponse.Data as List<PreviousInvolvementDetailDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addupdatePreviousInvolvementDetailClient() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    PreviousInvolvementDetailDto requestPreviousInvolvementDetailDto =
        PreviousInvolvementDetailDto(
      involvementId:
          involvementId ?? _randomGenerator.getRandomGeneratedNumber(),
      intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
      previousInvolved: previousInvolved,
      isArrest: wasPreviousArrest,
      arrestDate: previousArrestDateController.text == ""
          ? null
          : previousArrestDateController.text,
      offenceCategoryId: natureOfOffenceDropdownButtonFormField,
      sentenceOutcomes: sentenceOutcomesController.text,
      isConvicted: wasChildConvictedPreviously,
      convictionDate: convictionDateController.text == ""
          ? null
          : convictionDateController.text,
      isEscape: anyPreviousEscape,
      escapesDate:
          escapesDateController.text == "" ? null : escapesDateController.text,
      escapeTime:
          escapeTimeController.text == "" ? null : escapeTimeController.text,
      whenEscapedId: 0,
      placeOfEscape: placeOfEscapeController.text == ""
          ? null
          : placeOfEscapeController.text,
      createdBy: preferences!.getInt('userId'),
      dateCreated: _randomGenerator.getCurrentDateGenerated(),
      modifiedBy: preferences!.getInt('userId'),
      dateModified: _randomGenerator.getCurrentDateGenerated(),
      offenceCategoryDto: natureOfOffenceDropdownButtonFormField != null
          ? offenceCategoryDto
              .where((i) =>
                  i.offenceCategoryId == natureOfOffenceDropdownButtonFormField)
              .single
          : null,
    );
    overlay.show();

    apiResponse = await _previousInvolvementDetailClient
        .addUpdatePreviousInvolvementDetail(
            requestPreviousInvolvementDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const PreviousInvolvementDetailPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  newPreviousInvolvementDetail() {
    setState(() {
      labelButtonAddUpdate = 'Add Previous Involvement Crime';
      previousArrestDateController.clear();
      convictionDateController.clear();
      previousInvolved = "No";
      anyPreviousEscape = "No";
      wasChildConvictedPreviously = "No";
      wasPreviousArrest = "No";
      sentenceOutcomesController.clear();
      escapesDateController.clear();
      escapeTimeController.clear();
      placeOfEscapeController.clear();
      natureOfOffenceDropdownButtonFormField = null;
      involvementId = null;
    });
  }

  populatePreviousInvolvementDetailForm(
      PreviousInvolvementDetailDto previousInvolvementDetailDto) {
    setState(() {
      involvementId = previousInvolvementDetailDto.involvementId;
      capturePreviousInvolvementDetailPanelController =
          ExpandableController(initialExpanded: true);
      viewPreviousInvolvementDetailPanelPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Previous Involvement';
      previousInvolved = previousInvolvementDetailDto.previousInvolved;
      wasPreviousArrest = previousInvolvementDetailDto.isArrest;
      previousArrestDateController.text =
          previousInvolvementDetailDto.arrestDate.toString();
      wasChildConvictedPreviously = previousInvolvementDetailDto.isConvicted;
      anyPreviousEscape = previousInvolvementDetailDto.isEscape;
      convictionDateController.text =
          previousInvolvementDetailDto.convictionDate.toString();
      escapesDateController.text =
          previousInvolvementDetailDto.escapesDate.toString();

      escapeTimeController.text =
          previousInvolvementDetailDto.escapeTime.toString();
      sentenceOutcomesController.text =
          previousInvolvementDetailDto.sentenceOutcomes.toString();
      natureOfOffenceDropdownButtonFormField =
          previousInvolvementDetailDto.offenceCategoryDto?.offenceCategoryId;
      placeOfEscapeController.text =
          previousInvolvementDetailDto.placeOfEscape.toString();
    });
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
    convictionDateController.clear();
    sentenceOutcomesController.clear();
    escapesDateController.clear();
    escapeTimeController.clear();
    placeOfEscapeController.clear();
    placeOfEscapeController.clear();
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
              title: const Text("Previous Involvement Crime Details"),
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
                                const VictimOrganisationPage(),
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
                            builder: (context) =>
                                const DevelopmentAssessmentPage(),
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
                      //capture data
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
                                        capturePreviousInvolvementDetailPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Previous Involvement Crime Details",
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
                                                        newPreviousInvolvementDetail();
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Previous Involved?',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: 'Yes',
                                                          groupValue:
                                                              previousInvolved,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              previousInvolved =
                                                                  'Yes';
                                                            });
                                                          },
                                                        ),
                                                        Text('Yes'),
                                                        Radio(
                                                          value: 'No',
                                                          groupValue:
                                                              previousInvolved,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              previousInvolved =
                                                                  'No';
                                                            });
                                                          },
                                                        ),
                                                        Text('No'),
                                                      ],
                                                    ),
                                                  ],
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Was Previously Arrested?*',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: 'Yes',
                                                          groupValue:
                                                              wasPreviousArrest,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              wasPreviousArrest =
                                                                  'Yes';
                                                            });
                                                          },
                                                        ),
                                                        Text('Yes'),
                                                        Radio(
                                                          value: 'No',
                                                          groupValue:
                                                              wasPreviousArrest,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              wasPreviousArrest =
                                                                  'No';
                                                            });
                                                          },
                                                        ),
                                                        Text('No'),
                                                      ],
                                                    ),
                                                  ],
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
                                                      previousArrestDateController,
                                                  enabled: wasPreviousArrest ==
                                                      "Yes",
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Previous Arrest Date?',
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
                                                                1900), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(3000));

                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      previousArrestDateController
                                                          .text = formattedDate;
                                                      String formattedYear =
                                                          DateFormat('yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      DateTime now =
                                                          DateTime.now();
                                                      //You can format date as per your need
                                                    }
                                                  },
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     return 'Escape Date? Required';
                                                  //   }
                                                  //   return null;
                                                  // },
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          natureOfOffenceDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Select Offence Category ',
                                                        labelText:
                                                            'Select Nature of offence',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: offenceCategoryDto
                                                          .where((offenceCategory) =>
                                                              previousInvolved ==
                                                                  "Yes" ||
                                                              wasPreviousArrest ==
                                                                  "Yes")
                                                          .map(
                                                              (offenceCategory) {
                                                        return DropdownMenuItem(
                                                            value: offenceCategory
                                                                .offenceCategoryId,
                                                            child: Text(
                                                                offenceCategory
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        natureOfOffenceDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Select Offence Category is required';
                                                        }
                                                        return null;
                                                      },
                                                    ))),
                                          ],
                                        ),
                                        Row(children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Was child convicted Previously?',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        value: 'Yes',
                                                        groupValue:
                                                            wasChildConvictedPreviously,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wasChildConvictedPreviously =
                                                                'Yes';
                                                          });
                                                        },
                                                      ),
                                                      Text('Yes'),
                                                      Radio(
                                                        value: 'No',
                                                        groupValue:
                                                            wasChildConvictedPreviously,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            wasChildConvictedPreviously =
                                                                'No';
                                                          });
                                                        },
                                                      ),
                                                      Text('No'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      convictionDateController,
                                                  enabled: (previousInvolved ==
                                                              "Yes" ||
                                                          wasPreviousArrest ==
                                                              "Yes") &&
                                                      wasChildConvictedPreviously ==
                                                          "Yes",

                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Conviction Date?',
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
                                                                1900), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(3000));

                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      convictionDateController
                                                          .text = formattedDate;
                                                      String formattedYear =
                                                          DateFormat('yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      DateTime now =
                                                          DateTime.now();
                                                      //You can format date as per your need
                                                    }
                                                  },
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     return 'Conviction Date Required';
                                                  //   }
                                                  //   return null;
                                                  // },
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
                                                      sentenceOutcomesController,
                                                  enabled: (previousInvolved ==
                                                          "Yes" ||
                                                      wasPreviousArrest ==
                                                          "Yes"),
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Sentenece outcome',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Sentenece outcome Required';
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Any Previous escape?',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          value: 'Yes',
                                                          groupValue:
                                                              anyPreviousEscape,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              anyPreviousEscape =
                                                                  'Yes';
                                                            });
                                                          },
                                                        ),
                                                        Text('Yes'),
                                                        Radio(
                                                          value: 'No',
                                                          groupValue:
                                                              anyPreviousEscape,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              anyPreviousEscape =
                                                                  'No';
                                                            });
                                                          },
                                                        ),
                                                        Text('No'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller:
                                                    escapesDateController,
                                                enabled: (previousInvolved ==
                                                            "Yes" ||
                                                        wasPreviousArrest ==
                                                            "Yes") &&
                                                    anyPreviousEscape == "Yes",

                                                maxLines: 1,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Escape Date?',
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
                                                              1900), //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(3000));

                                                  if (pickedDate != null) {
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                    escapesDateController.text =
                                                        formattedDate;
                                                    String formattedYear =
                                                        DateFormat('yyyy')
                                                            .format(pickedDate);
                                                    DateTime now =
                                                        DateTime.now();
                                                    //You can format date as per your need
                                                  }
                                                },
                                                // validator: (value) {
                                                //   if (value == null ||
                                                //       value.isEmpty) {
                                                //     return 'Escape Date? Required';
                                                //   }
                                                //   return null;
                                                // },
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      escapeTimeController,
                                                  enabled: (previousInvolved ==
                                                              "Yes" ||
                                                          wasPreviousArrest ==
                                                              "Yes") &&
                                                      anyPreviousEscape ==
                                                          "Yes",
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Escape Time',
                                                  ),
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     return 'Escape Time Required';
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  readOnly: true,
                                                  onTap: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      context: context,
                                                    );

                                                    if (pickedTime != null) {
                                                      // Create a DateTime object with the selected time
                                                      DateTime
                                                          selectedDateTime =
                                                          DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day,
                                                        pickedTime.hour,
                                                        pickedTime.minute,
                                                      );

                                                      // Format the DateTime as needed
                                                      String formattedTime =
                                                          selectedDateTime
                                                              .toUtc()
                                                              .toIso8601String();

                                                      setState(() {
                                                        escapeTimeController
                                                                .text =
                                                            formattedTime;
                                                      });
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
                                                      placeOfEscapeController,
                                                  enabled: (previousInvolved ==
                                                              "Yes" ||
                                                          wasPreviousArrest ==
                                                              "Yes") &&
                                                      anyPreviousEscape ==
                                                          "Yes",
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Place of escape',
                                                  ),
                                                  // validator: (value) {
                                                  //   if (value == null ||
                                                  //       value.isEmpty) {
                                                  //     return 'Place of escape Required';
                                                  //   }
                                                  //   return null;
                                                  // },
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
                                                          addupdatePreviousInvolvementDetailClient();
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

                      //view data
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        viewPreviousInvolvementDetailPanelPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Previous involvement Crime Details",
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
                                        if (previousInvolvementDetailDto
                                            .isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      previousInvolvementDetailDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (previousInvolvementDetailDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No Accused Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Previous Involved : ${previousInvolvementDetailDto[index].previousInvolved ?? ''} ',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Is Arrest:  ${previousInvolvementDetailDto[index].isArrest ?? ''} \n'
                                                          'Offence Category : ${previousInvolvementDetailDto[index].offenceCategoryDto?.description ?? ''} \n'
                                                          'Arrest Date : ${previousInvolvementDetailDto[index].arrestDate ?? ''} \n'
                                                          'Is Convicted : ${previousInvolvementDetailDto[index].isConvicted ?? ''} \n'
                                                          'Conviction Date : ${previousInvolvementDetailDto[index].convictionDate ?? ''} \n'
                                                          'Is Escape : ${previousInvolvementDetailDto[index].isEscape ?? ''} \n'
                                                          'Escapes Date : ${previousInvolvementDetailDto[index].escapesDate ?? ''} \n',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                                                          IconButton(
                                                              onPressed: () {
                                                                populatePreviousInvolvementDetailForm(
                                                                    previousInvolvementDetailDto[
                                                                        index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue)),
                                                          /*IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red)),*/
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                        thickness: 1);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
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
                        ))),
                      ]),
                    ],
                  ),
                ))));
  }
}
