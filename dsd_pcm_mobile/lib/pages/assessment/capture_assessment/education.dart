import 'package:dsd_pcm_mobile/model/intake/person_education_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/grade_dto.dart';
import '../../../model/intake/school_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/intake/person_education_service.dart';
import '../../../transform_dynamic/tranform_school.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'care_giver_detail.dart';
import 'health_detail.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPagePageState();
}

class _EducationPagePageState extends State<EducationPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _schoolTransform = SchoolTransform();
  final _randomGenerator = RandomGenerator();
  final _personEducationServiceClient = PersonEducationService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<GradeDto> gradesDto = [];
  late List<SchoolTypeDto> schoolTypesDto = [];
  late List<PersonEducationDto> personEducationsDto = [];

  ExpandableController captureEducationPanelController = ExpandableController();
  ExpandableController viewEducationPanelController = ExpandableController();
  TextEditingController yearCompletedController = TextEditingController();
  TextEditingController dateLastAttendedController = TextEditingController();
  TextEditingController additionalInformationController =
      TextEditingController();
  TextEditingController schoolNameController = TextEditingController();
  int? gradeDropdownButtonFormField;
  int? schoolTypeDropdownButtonFormField;
  int? qualificationId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureEducationPanelController =
        ExpandableController(initialExpanded: false);
    viewEducationPanelController = ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Qualification';
    qualificationId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadSchoolTransformer();
          loadPersonEducationsByPersonId(acceptedWorklistDto.personId);
        });
      });
    });
  }

  loadSchoolTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    gradesDto = await _schoolTransform.transformGradesDto();
    schoolTypesDto = await _schoolTransform.transformSchoolTypesDto();
    overlay.hide();
  }

  loadPersonEducationsByPersonId(int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _personEducationServiceClient
        .getPersonEducationByPersonId(personId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personEducationsDto = (apiResponse.Data as List<PersonEducationDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdatePersonEducation() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    PersonEducationDto requestPersonEducationDto = PersonEducationDto(
        personEducationId:
            qualificationId ?? _randomGenerator.getRandomGeneratedNumber(),
        personId: acceptedWorklistDto.personId,
        schoolName: schoolNameController.text,
        schoolId: _randomGenerator.getRandomGeneratedNumber(),
        /*schoolId: schoolDropdownButtonFormField,ss
        schoolDto: schoolDropdownButtonFormField != null
            ? schoolsDto
                .where((i) => i.schoolId == schoolDropdownButtonFormField)
                .single
            : null,*/
        gradeId: gradeDropdownButtonFormField,
        gradeDto: gradeDropdownButtonFormField != null
            ? gradesDto
                .where((i) => i.gradeId == gradeDropdownButtonFormField)
                .single
            : null,
        yearCompleted: yearCompletedController.text,
        dateLastAttended: dateLastAttendedController.text,
        additionalInformation: additionalInformationController.text,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        createdBy: preferences!.getString('username'),
        isActive: true,
        isDeleted: false);

    apiResponse = await _personEducationServiceClient
        .addUdatePersonEducation(requestPersonEducationDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const EducationPage(),
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

  newQualification() {
    setState(() {
      labelButtonAddUpdate = 'Add Qualification';
      schoolNameController.clear();
      yearCompletedController.clear();
      dateLastAttendedController.clear();
      additionalInformationController.clear();
      qualificationId = null;
      schoolTypeDropdownButtonFormField = null;
      gradeDropdownButtonFormField = null;
    });
  }

  populateFamilyMemberForm(PersonEducationDto personEducationDto) {
    setState(() {
      qualificationId = personEducationDto.personEducationId;
      captureEducationPanelController =
          ExpandableController(initialExpanded: true);
      viewEducationPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Qualification';
      schoolNameController.text = (personEducationDto.schoolId == null
          ? personEducationDto.schoolName!
          : personEducationDto.schoolDto?.schoolName)!;
      yearCompletedController.text = personEducationDto.yearCompleted!;
      dateLastAttendedController.text = personEducationDto.dateLastAttended!;
      additionalInformationController.text =
          personEducationDto.additionalInformation!;
      gradeDropdownButtonFormField = personEducationDto.gradeId;
      schoolTypeDropdownButtonFormField =
          personEducationDto.schoolDto!.schoolTypeId;
    });
  }

  @override
  void dispose() {
    yearCompletedController.dispose();
    dateLastAttendedController.dispose();
    yearCompletedController.dispose();
    additionalInformationController.dispose();
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
              title: const Text("Education Information"),
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
                            builder: (context) => const HealthDetailPage(),
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
                            builder: (context) => const CareGiverDetailPage(),
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
                                    controller: captureEducationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Education Qualification",
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
                                                        newQualification();
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
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        schoolTypeDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'School Type',
                                                      labelText: 'School Type',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: schoolTypesDto
                                                        .map((schoolType) {
                                                      return DropdownMenuItem(
                                                          value: schoolType
                                                              .schoolTypeId,
                                                          child: Text(schoolType
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      setState(() {
                                                        schoolTypeDropdownButtonFormField =
                                                            selectedValue;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'School Type required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
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
                                                      schoolNameController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'School Name',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'School Name Required';
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
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        gradeDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Grade',
                                                      labelText: 'Grade',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items:
                                                        gradesDto.map((grade) {
                                                      return DropdownMenuItem(
                                                          value: grade.gradeId,
                                                          child: Text(grade
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      gradeDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Grade Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
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
                                                      yearCompletedController,

                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Year Completed',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Year Completed Required';
                                                    }
                                                    return null;
                                                  },
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
                                                          DateFormat('yyyy').format(
                                                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      yearCompletedController
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
                                                      dateLastAttendedController,

                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Last Attended Date',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Last Attended Date Required';
                                                    }
                                                    return null;
                                                  },
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
                                                      dateLastAttendedController
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
                                                      additionalInformationController,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Additional Information',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Additional Information Required';
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
                                                          addUpdatePersonEducation();
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
                                    controller: viewEducationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Educations",
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
                                        if (personEducationsDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: personEducationsDto
                                                      .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (personEducationsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No person education Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'School : ${personEducationsDto[index].schoolName ?? personEducationsDto[index].schoolDto?.schoolName ?? ''} ',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Year : ${personEducationsDto[index].yearCompleted ?? ''} '
                                                          'Grade :${personEducationsDto[index].gradeDto!.description ?? ''}',
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
                                                                populateFamilyMemberForm(
                                                                    personEducationsDto[
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
