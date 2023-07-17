import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/form_of_notification_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/assesment_register_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/assessment_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../child_detail/update_child_detail.dart';
import '../health_detail.dart';

class AssessmentDetailPage extends StatefulWidget {
  const AssessmentDetailPage({Key? key}) : super(key: key);

  @override
  State<AssessmentDetailPage> createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _randomGenerator = RandomGenerator();
  final _assessmentServiceClient = AssessmentService();
  final _lookupTransform = LookupTransform();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late AssesmentRegisterDto assesmentRegisterDto = AssesmentRegisterDto();
  late List<FormOfNotificationDto> formOfNotificationsDto = [];

  TextEditingController assessmentDateController = TextEditingController();
  TextEditingController assessmentTimeController = TextEditingController();
  int? formOfNotificationDropdownButtonFormField;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadAssesmentRegister(acceptedWorklistDto.intakeAssessmentId,
              acceptedWorklistDto.caseId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    formOfNotificationsDto =
        await _lookupTransform.transformFormOfNotificationDto();
    overlay.hide();
  }

  loadAssesmentRegister(int? intakeAssessmentId, int? caseId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _assessmentServiceClient
        .getAssesmentRegisterByAssessmentId(intakeAssessmentId, caseId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        if (apiResponse.Data != null) {
          assesmentRegisterDto = (apiResponse.Data as AssesmentRegisterDto);
          assessmentDateController.text =
              assesmentRegisterDto.assessmentDate.toString();
          assessmentTimeController.text =
              assesmentRegisterDto.assessmentTime.toString();
          formOfNotificationDropdownButtonFormField =
              assesmentRegisterDto.formOfNotificationId;
        }
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureAssesmentRegister() async {
    AssesmentRegisterDto requestAssesmentRegisterDto = AssesmentRegisterDto(
        assesmentRegisterId: assesmentRegisterDto.assesmentRegisterId ??
            _randomGenerator.getRandomGeneratedNumber(),
        pcmCaseId: acceptedWorklistDto.caseId,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        probationOfficerId: preferences!.getInt('userId')!,
        assessedBy: preferences!.getInt('userId')!,
        assessmentDate: assessmentDateController.text,
        assessmentTime: assessmentTimeController.text,
        createdBy: preferences!.getInt('userId')!,
        townId: null,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        formOfNotificationId: formOfNotificationDropdownButtonFormField,
        formOfNotificationDto: formOfNotificationDropdownButtonFormField != null
            ? formOfNotificationsDto
                .where((i) =>
                    i.formOfNotificationId ==
                    formOfNotificationDropdownButtonFormField)
                .single
            : null);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _assessmentServiceClient
        .addUpdateAssesmentRegister(requestAssesmentRegisterDto);
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      assessmentTimeController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Assessment Time',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Assessment Time Required';
                                                    }
                                                    return null;
                                                  },
                                                  readOnly:
                                                      true, // when true user cannot edit text
                                                  onTap: () async {
                                                    TimeOfDay? pickedTime =
                                                        await showTimePicker(
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      context: context,
                                                    );

                                                    if (pickedTime != null) {
                                                      assessmentTimeController
                                                              .text =
                                                          "${pickedTime.hour}:${pickedTime.minute}";
                                                      /*DateTime parsedTime =
                                                          DateFormat.jm().parse(
                                                              pickedTime
                                                                  .format(
                                                                      context)
                                                                  .toString());*/
                                                      //String formattedTime = DateFormat('HH:mm:ss').format(pickedTime);

                                                      /*String formattedDate =
                                                          DateFormat(
                                                                  'HH:mm:ss')
                                                              .format(
                                                                  pickedTime); */ // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      /*assessmentDateController
                                                              .text =
                                                          parsedTime.toString();*/
                                                      //You can format date as per your need

                                                    }

                                                    /*DateTime? pickedDate =
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
                                                      assessmentDateController
                                                          .text = formattedDate;
                                                      //You can format date as per your need

                                                    }
                                                    */
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
                                                      assessmentDateController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Assessment Date',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Assessment Date Required';
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
                                                      assessmentDateController
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
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        formOfNotificationDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Form Notification',
                                                      labelText:
                                                          'Form Notification',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: formOfNotificationsDto
                                                        .map(
                                                            (formNotification) {
                                                      return DropdownMenuItem(
                                                          value: formNotification
                                                              .formOfNotificationId,
                                                          child: Text(
                                                              formNotification
                                                                  .description
                                                                  .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      setState(() {
                                                        formOfNotificationDropdownButtonFormField =
                                                            selectedValue;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Form Notification required';
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
                                                          captureAssesmentRegister();
                                                        }
                                                      },
                                                      child: const Text(
                                                          'Register Assessment'),
                                                    ))),
                                          ],
                                        ),
                                      ])
                                  //card inf
                                  )))
                    ]),

                    /*

 Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                */
                  ]))),
        ));
  }
}
