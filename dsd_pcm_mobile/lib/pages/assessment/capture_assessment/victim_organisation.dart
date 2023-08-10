import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/victim_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'development_assessment.dart';
import 'victim_detail.dart';

class VictimOrganisationPage extends StatefulWidget {
  const VictimOrganisationPage({Key? key}) : super(key: key);

  @override
  State<VictimOrganisationPage> createState() => _VictimOrganisationPageState();
}

class _VictimOrganisationPageState extends State<VictimOrganisationPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _randomGenerator = RandomGenerator();
  final _victimServiceClient = VictimService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<VictimOrganisationDetailDto> victimOrganisationDetailsDto = [];

  ExpandableController captureVictimOrganisationPanelController =
      ExpandableController();
  ExpandableController viewVictimOrganisationPanelController =
      ExpandableController();
  final TextEditingController organisationNameController =
      TextEditingController();
  final TextEditingController contactPersonFirstNameController =
      TextEditingController();
  final TextEditingController contactPersonLastNameController =
      TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController cellNoController = TextEditingController();
  final TextEditingController interventionserviceReferralsController =
      TextEditingController();
  final TextEditingController otherContactsController = TextEditingController();
  final TextEditingController contactPersonOccupationController =
      TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  int? victimOrganisationId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureVictimOrganisationPanelController =
        ExpandableController(initialExpanded: false);
    viewVictimOrganisationPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Organisation';
    victimOrganisationId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadVictimOrganisationDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadVictimOrganisationDetailsByIntakeAssessmentId(
      int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _victimServiceClient
        .getVictimOrganisationDetailByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        victimOrganisationDetailsDto =
            (apiResponse.Data as List<VictimOrganisationDetailDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateVictimOrganisation() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    VictimOrganisationDetailDto requestVictimOrganisationDetailDto =
        VictimOrganisationDetailDto(
            victimOrganisationId: victimOrganisationId ??
                _randomGenerator.getRandomGeneratedNumber(),
            dateCreated: _randomGenerator.getCurrentDateGenerated(),
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            organisationName: organisationNameController.text,
            contactPersonFirstName: contactPersonFirstNameController.text,
            contactPersonLastName: contactPersonLastNameController.text,
            telephone: telephoneController.text,
            cellNo: cellNoController.text,
            interventionserviceReferrals:
                interventionserviceReferralsController.text,
            otherContacts: otherContactsController.text,
            contactPersonOccupation: contactPersonOccupationController.text,
            addressLine1: addressLine1Controller.text,
            addressLine2: addressLine2Controller.text,
            postalCode: postalCodeController.text,
            createdBy: preferences!.getInt('userId')!);

    apiResponse = await _victimServiceClient
        .addUpdateVictimOrganisation(requestVictimOrganisationDetailDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const VictimOrganisationPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  newVictimOrganisation() {
    setState(() {
      labelButtonAddUpdate = 'Add Organisation';
      organisationNameController.clear();
      contactPersonFirstNameController.clear();
      contactPersonLastNameController.clear();
      telephoneController.clear();
      cellNoController.clear();
      interventionserviceReferralsController.clear();
      otherContactsController.clear();
      contactPersonOccupationController.clear();
      addressLine1Controller.clear();
      addressLine2Controller.clear();
      postalCodeController.clear();
      victimOrganisationId = null;
    });
  }

  populateVictimOrganisationForm(
      VictimOrganisationDetailDto victimOrganisationDetailDto) {
    setState(() {
      victimOrganisationId = victimOrganisationDetailDto.victimOrganisationId;
      captureVictimOrganisationPanelController =
          ExpandableController(initialExpanded: true);
      viewVictimOrganisationPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Organisation';
      organisationNameController.text =
          victimOrganisationDetailDto.organisationName!;
      contactPersonFirstNameController.text =
          victimOrganisationDetailDto.contactPersonFirstName!;
      contactPersonLastNameController.text =
          victimOrganisationDetailDto.contactPersonLastName!;
      telephoneController.text = victimOrganisationDetailDto.telephone!;
      cellNoController.text = victimOrganisationDetailDto.cellNo!;
      interventionserviceReferralsController.text =
          victimOrganisationDetailDto.interventionserviceReferrals!;
      otherContactsController.text = victimOrganisationDetailDto.otherContacts!;
      contactPersonOccupationController.text =
          victimOrganisationDetailDto.contactPersonOccupation!;
      addressLine1Controller.text = victimOrganisationDetailDto.addressLine1!;
      addressLine2Controller.text = victimOrganisationDetailDto.addressLine2!;
      postalCodeController.text = victimOrganisationDetailDto.postalCode!;
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
    organisationNameController.dispose();
    contactPersonFirstNameController.dispose();
    contactPersonLastNameController.dispose();
    telephoneController.dispose();
    cellNoController.dispose();
    interventionserviceReferralsController.dispose();
    otherContactsController.dispose();
    contactPersonOccupationController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    postalCodeController.dispose();
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
              title: const Text("Victim Organisation"),
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
                                        captureVictimOrganisationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Victim Organisation",
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
                                                        newVictimOrganisation();
                                                      },
                                                      child: const Text('New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller:
                                                organisationNameController,
                                            maxLines: 1,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Organisation Name',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Organisation Name Required';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Text(
                                            'Contact Person',
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
                                                      contactPersonFirstNameController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'First Name',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'FirstName Required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      contactPersonLastNameController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Last Name',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'LastName Required';
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
                                                      contactPersonOccupationController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Occupation',
                                                  ),
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
                                                      telephoneController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Tel Number',
                                                  ),
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
                                                  controller: cellNoController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Cell Number',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Cell Number Required';
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
                                                      otherContactsController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Other Number',
                                                  ),
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
                                                      addressLine1Controller,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Address Line 1',
                                                  ),
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
                                                      addressLine2Controller,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Address Line 2',
                                                  ),
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
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      postalCodeController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Postal Code',
                                                  ),
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
                                                          addUpdateVictimOrganisation();
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
                                    controller:
                                        viewVictimOrganisationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Victim Organisation",
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
                                        if (victimOrganisationDetailsDto
                                            .isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      victimOrganisationDetailsDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (victimOrganisationDetailsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No victim organisation Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Name : ${victimOrganisationDetailsDto[index].organisationName}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Contact Person : ${victimOrganisationDetailsDto[index].contactPersonFirstName ?? ''} ${victimOrganisationDetailsDto[index].contactPersonLastName ?? ''}.'
                                                          'Address : ${victimOrganisationDetailsDto[index].addressLine1 ?? ''} ${victimOrganisationDetailsDto[index].addressLine2 ?? ''} ${victimOrganisationDetailsDto[index].postalCode ?? ''}',
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
                                                                populateVictimOrganisationForm(
                                                                    victimOrganisationDetailsDto[
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
