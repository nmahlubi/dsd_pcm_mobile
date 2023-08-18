import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/care_giver_details_dto.dart';
import '../../../model/intake/gender_dto.dart';
import '../../../model/intake/person_dto.dart';
import '../../../model/intake/relationship_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/intake/care_giver_detail_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'family/family.dart';
import 'family_member.dart';
import 'health_detail.dart';

class CareGiverDetailPage extends StatefulWidget {
  const CareGiverDetailPage({Key? key}) : super(key: key);

  @override
  State<CareGiverDetailPage> createState() => _CareGiverDetailPageState();
}

class _CareGiverDetailPageState extends State<CareGiverDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _careGiverDetailServiceClient = CareGiverDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<GenderDto> gendersDto = [];
  late List<CareGiverDetailsDto> careGiverDetailsDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];

  ExpandableController captureCareGiverPanelController = ExpandableController();
  ExpandableController viewCareGiverPanelController = ExpandableController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  int? genderDropdownButtonFormField;
  int? relationshipTypeDropdownButtonFormField;
  int? careGiverId;
  int? personId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureCareGiverPanelController =
        ExpandableController(initialExpanded: false);
    viewCareGiverPanelController = ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Care Giver';
    careGiverId = null;
    personId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadCareGiverDetailsByClientId(acceptedWorklistDto.clientId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    gendersDto = await _lookupTransform.transformGendersDto();
    relationshipTypesDto =
        await _lookupTransform.transformRelationshipTypeDto();
    overlay.hide();
  }

  loadCareGiverDetailsByClientId(int? clientId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _careGiverDetailServiceClient
        .getCareGiverDetailsByClientId(clientId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        careGiverDetailsDto = (apiResponse.Data as List<CareGiverDetailsDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateCareGiverClient() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    int? localPersonId =
        personId ?? _randomGenerator.getRandomGeneratedNumber();
    CareGiverDetailsDto requestCareGiverDetailsDto = CareGiverDetailsDto(
        clientCaregiverId:
            careGiverId ?? _randomGenerator.getRandomGeneratedNumber(),
        clientId: acceptedWorklistDto.clientId,
        personId: localPersonId,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        personDto: PersonDto(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          dateOfBirth: dateOfBirthController.text,
          age: int.parse(ageController.text),
          personId: localPersonId,
          genderId: genderDropdownButtonFormField,
          isEstimatedAge: true,
          dateCreated: _randomGenerator.getCurrentDateGenerated(),
          isActive: true,
          isDeleted: false,
          isPivaValidated: true,
          createdBy: preferences!.getString('username'),
          genderDto: genderDropdownButtonFormField != null
              ? gendersDto
                  .where((i) => i.genderId == genderDropdownButtonFormField)
                  .single
              : null,
        ),
        relationshipTypeId: relationshipTypeDropdownButtonFormField,
        relationshipTypeDto: relationshipTypeDropdownButtonFormField != null
            ? relationshipTypesDto
                .where((i) =>
                    i.relationshipTypeId ==
                    relationshipTypeDropdownButtonFormField)
                .single
            : null,
        createdBy: preferences!.getString('username')!);
    overlay.show();
    apiResponse = await _careGiverDetailServiceClient
        .addUpdateCareGiverDetail(requestCareGiverDetailsDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const CareGiverDetailPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureCareGiverDetail(String? name, String? surname, String? dateOfBirth,
      int? age, int? genderId, int? relationshipTypeId) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    int? localPersonId = _randomGenerator.getRandomGeneratedNumber();
    CareGiverDetailsDto requestCareGiverDetailsDto = CareGiverDetailsDto(
        clientCaregiverId: _randomGenerator.getRandomGeneratedNumber(),
        clientId: acceptedWorklistDto.clientId,
        personId: localPersonId,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        personDto: PersonDto(
          firstName: name,
          lastName: surname,
          dateOfBirth: dateOfBirth,
          age: age,
          personId: localPersonId,
          genderId: genderId,
          isEstimatedAge: true,
          dateCreated: _randomGenerator.getCurrentDateGenerated(),
          isActive: true,
          isDeleted: false,
          isPivaValidated: true,
          createdBy: preferences!.getString('username'),
          genderDto: genderId != null
              ? gendersDto.where((i) => i.genderId == genderId).single
              : null,
        ),
        relationshipTypeId: relationshipTypeId,
        relationshipTypeDto: relationshipTypeId != null
            ? relationshipTypesDto
                .where((i) => i.relationshipTypeId == relationshipTypeId)
                .single
            : null,
        createdBy: preferences!.getString('username')!);
    overlay.show();
    apiResponse = await _careGiverDetailServiceClient
        .addCareGiverDetail(requestCareGiverDetailsDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const CareGiverDetailPage(),
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

  newCareGiver() {
    setState(() {
      labelButtonAddUpdate = 'Add Care Giver';
      firstNameController.clear();
      lastNameController.clear();
      dateOfBirthController.clear();
      ageController.clear();
      genderDropdownButtonFormField = null;
      relationshipTypeDropdownButtonFormField = null;
      personId = null;
      careGiverId = null;
    });
  }

  populateCareGiverForm(CareGiverDetailsDto careGiverDetailsDto) {
    setState(() {
      careGiverId = careGiverDetailsDto.clientCaregiverId;
      personId = careGiverDetailsDto.personDto!.personId;
      captureCareGiverPanelController =
          ExpandableController(initialExpanded: true);
      viewCareGiverPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Care Giver';
      firstNameController.text =
          careGiverDetailsDto.personDto!.firstName.toString();
      lastNameController.text =
          careGiverDetailsDto.personDto!.lastName.toString();
      dateOfBirthController.text =
          careGiverDetailsDto.personDto!.dateOfBirth.toString();
      ageController.text = careGiverDetailsDto.personDto!.age.toString();
      genderDropdownButtonFormField = careGiverDetailsDto.personDto!.genderId;
      relationshipTypeDropdownButtonFormField =
          careGiverDetailsDto.relationshipTypeId;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
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
              title: const Text("Care Giver Details"),
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
                            builder: (context) => const FamilyMemberPage(),
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
                                    controller: captureCareGiverPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Care Giver Details",
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
                                                        newCareGiver();
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          relationshipTypeDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Relationship Type',
                                                        labelText:
                                                            'Relationship Type',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: relationshipTypesDto
                                                          .map((relationship) {
                                                        return DropdownMenuItem(
                                                            value: relationship
                                                                .relationshipTypeId,
                                                            child: Text(
                                                                relationship
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        relationshipTypeDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Relationship Type is required';
                                                        }
                                                      },
                                                    ))),
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
                                                          genderDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Gender',
                                                        labelText: 'Gender',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: gendersDto
                                                          .map((gender) {
                                                        return DropdownMenuItem(
                                                            value:
                                                                gender.genderId,
                                                            child: Text(gender
                                                                .description
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        genderDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Gender required';
                                                        }
                                                        return null;
                                                      },
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
                                                      firstNameController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Firstname',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Firstname Required';
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
                                                      lastNameController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Lastname',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Lastname Required';
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
                                                      dateOfBirthController,

                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Date Of Birth',
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
                                                      dateOfBirthController
                                                          .text = formattedDate;
                                                      String formattedYear =
                                                          DateFormat('yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      DateTime now =
                                                          DateTime.now();
                                                      Duration age =
                                                          now.difference(
                                                              pickedDate);
                                                      int years =
                                                          age.inDays ~/ 365;
                                                      ageController.text =
                                                          (years).toString();

                                                      //You can format date as per your need
                                                    }
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Date Of Birth Required';
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
                                                  controller: ageController,
                                                  maxLines: 1,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Age',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Age Required';
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
                                                          addUpdateCareGiverClient();
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
                                    controller: viewCareGiverPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Care Giver Details",
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
                                        if (careGiverDetailsDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: careGiverDetailsDto
                                                      .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (careGiverDetailsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No Accused Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Relationship : ${careGiverDetailsDto[index].relationshipTypeDto!.description ?? ''} ',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Name : ${careGiverDetailsDto[index].personDto!.firstName ?? ''} '
                                                          ' ${careGiverDetailsDto[index].personDto!.lastName ?? ''}',
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
                                                                populateCareGiverForm(
                                                                    careGiverDetailsDto[
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
