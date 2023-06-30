import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/family_information_dto.dart';
import '../../../../model/pcm/family_member_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../service/pcm/family_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../care_giver_detail/care_giver_detail.dart';
import '../socio_economic/socio_economic.dart';
import 'capture_family_member.dart';
import 'capture_family_information.dart';
import 'view_family_member.dart';
import 'view_family_information.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({Key? key}) : super(key: key);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final FamilyService familyServiceClient = FamilyService();
  final PersonService personServiceClient = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<GenderDto> gendersDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];
  late List<FamilyMemberDto> familyMembersDto = [];
  late List<FamilyInformationDto> familyInformationsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadFamilyMembersByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
          loadFamilyInformationsByIntakeAssessmentId(
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

  loadFamilyInformationsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await familyServiceClient
        .getFamilyInformationByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        familyInformationsDto =
            (apiResponse.Data as List<FamilyInformationDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureFamilyMember(String? name, String? surname, String? dateOfBirth,
      int? age, int? genderId, int? relationshipTypeId) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    int? localPersonId = _randomGenerator.getRandomGeneratedNumber();
    FamilyMemberDto requestFamilyMemberDto = FamilyMemberDto(
        familyMemberId: _randomGenerator.getRandomGeneratedNumber(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
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
        createdBy: preferences!.getInt('userId')!);
    overlay.show();
    apiResponse =
        await familyServiceClient.addFamilyMember(requestFamilyMemberDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage("Family Member Successfull Added");
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const FamilyPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureFamilyInformation(String? familyBackground) async {
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);

    FamilyInformationDto familyInformationDto = FamilyInformationDto(
        familyInformationId: _randomGenerator.getRandomGeneratedNumber(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        familyBackground: familyBackground,
        dateCreated: date,
        createdBy: preferences!.getInt('userId')!);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await familyServiceClient.addFamilyInformation(familyInformationDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage("Family Information Successfull Added");
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const FamilyPage(),
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
            title: const Text("Family"),
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
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            children: [
              CaptureFamilyMemberPage(
                  gendersDto: gendersDto,
                  relationshipTypesDto: relationshipTypesDto,
                  addNewFamilyMember: captureFamilyMember),
              ViewFamilyMemberPage(familyMembersDto: familyMembersDto),
              CaptureFamilyInformationPage(
                  addNewFamilyInformation: captureFamilyInformation),
              ViewFamilyInformationPage(
                  familyInformationsDto: familyInformationsDto),
            ],
          ),
        ));
  }
}
