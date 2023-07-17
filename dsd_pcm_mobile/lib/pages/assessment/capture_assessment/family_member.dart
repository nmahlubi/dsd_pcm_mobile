import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/socio_economic.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/gender_dto.dart';
import '../../../model/intake/person_dto.dart';
import '../../../model/intake/relationship_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/family_member_dto.dart';
import '../../../model/pcm/medical_health_detail_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/family_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'assessment_details/assessment_detail.dart';
import 'care_giver_detail.dart';

class FamilyMemberPage extends StatefulWidget {
  const FamilyMemberPage({Key? key}) : super(key: key);

  @override
  State<FamilyMemberPage> createState() => _FamilyMemberPageState();
}

class _FamilyMemberPageState extends State<FamilyMemberPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final familyServiceClient = FamilyService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<GenderDto> gendersDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];
  late List<FamilyMemberDto> familyMembersDto = [];

  ExpandableController captureFamilyMemberPanelController =
      ExpandableController();
  ExpandableController viewFamilyMemberPanelController = ExpandableController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  int? genderDropdownButtonFormField;
  int? relationshipTypeDropdownButtonFormField;
  int? familyMemberId;
  int? personId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureFamilyMemberPanelController =
        ExpandableController(initialExpanded: false);
    viewFamilyMemberPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Member';
    familyMemberId = null;
    personId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadFamilyMembersByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
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

  loadFamilyMembersByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await familyServiceClient
        .getFamilyMembersByAssesmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        familyMembersDto = (apiResponse.Data as List<FamilyMemberDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  addUpdateFamilyMember() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    int? localPersonId =
        personId ?? _randomGenerator.getRandomGeneratedNumber();
    FamilyMemberDto requestFamilyMemberDto = FamilyMemberDto(
        familyMemberId:
            familyMemberId ?? _randomGenerator.getRandomGeneratedNumber(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        personId: localPersonId,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        personDto: PersonDto(
          firstName: nameController.text,
          lastName: surnameController.text,
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
        createdBy: preferences!.getInt('userId')!);
    overlay.show();
    apiResponse =
        await familyServiceClient.addFamilyMember(requestFamilyMemberDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage("Successfull $labelButtonAddUpdate");
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const FamilyMemberPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  newMember() {
    setState(() {
      labelButtonAddUpdate = 'Add Member';
      nameController.clear();
      surnameController.clear();
      ageController.clear();
      dateOfBirthController.clear();
      genderDropdownButtonFormField = null;
      relationshipTypeDropdownButtonFormField = null;
      familyMemberId = null;
      personId = null;
    });
  }

  populateFamilyMemberForm(FamilyMemberDto familyMemberDto) {
    setState(() {
      familyMemberId = familyMemberDto.familyMemberId;
      personId = familyMemberDto.personDto!.personId;
      captureFamilyMemberPanelController =
          ExpandableController(initialExpanded: true);
      viewFamilyMemberPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Member';
      nameController.text = familyMemberDto.personDto!.firstName!;
      surnameController.text = familyMemberDto.personDto!.lastName!;
      if (familyMemberDto.personDto!.age != null) {
        ageController.text = familyMemberDto.personDto!.age!.toString();
      }
      if (familyMemberDto.personDto!.dateOfBirth != null) {
        dateOfBirthController.text =
            familyMemberDto.personDto!.dateOfBirth.toString();
      }
      genderDropdownButtonFormField = familyMemberDto.personDto?.genderId;
      relationshipTypeDropdownButtonFormField =
          familyMemberDto.relationshipTypeId;
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
    nameController.dispose();
    surnameController.dispose();
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
              title: const Text("Medical Information"),
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
                            builder: (context) => const CareGiverDetailPage(),
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
                            builder: (context) => const SocioEconomicPage(),
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
                                        captureFamilyMemberPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Family Member",
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
                                                        newMember();
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
                                                  controller: nameController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Name',
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
                                                  controller: surnameController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Surname',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Surname Required';
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
                                                  enableInteractiveSelection:
                                                      false,
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
                                                                2000), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2101));

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
                                                      ageController
                                                          .text = (DateTime
                                                                      .now()
                                                                  .year -
                                                              int.parse(
                                                                  formattedYear))
                                                          .toString();
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
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller: ageController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLines: 1,
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
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
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
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
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
                                                    onChanged: (selectedValue) {
                                                      genderDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Gender Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Text(
                                            'Relationship',
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
                                                          return 'Relationship Type Required';
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
                                                          addUpdateFamilyMember();
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
                                    controller: viewFamilyMemberPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Family Member",
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
                                        if (familyMembersDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      familyMembersDto.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (familyMembersDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No family member Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Relationship : ${familyMembersDto[index].relationshipTypeDto?.description}.',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Name : ${familyMembersDto[index].personDto?.firstName ?? ''} ${familyMembersDto[index].personDto?.lastName ?? ''}',
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
                                                                    familyMembersDto[
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
