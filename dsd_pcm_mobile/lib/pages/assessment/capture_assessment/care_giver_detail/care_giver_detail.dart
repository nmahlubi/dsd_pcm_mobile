import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/care_giver_details_dto.dart';
import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/intake/care_giver_detail_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../family/family.dart';
import '../health_detail/health_detail.dart';
import 'capture_care_giver_detail.dart';
import 'view_care_giver_detail.dart';

class CareGiverDetailPage extends StatefulWidget {
  const CareGiverDetailPage({Key? key}) : super(key: key);

  @override
  State<CareGiverDetailPage> createState() => _CareGiverDetailPageState();
}

class _CareGiverDetailPageState extends State<CareGiverDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  void initState() {
    super.initState();
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
      showSuccessMessage('Care Giver Detail Is Successfully Created.');
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
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
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
                          builder: (context) => const FamilyPage(),
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
              CaptureCareGiverDetailPage(
                  gendersDto: gendersDto,
                  relationshipTypesDto: relationshipTypesDto,
                  addNewCareGiverDetail: captureCareGiverDetail),
              ViewCareGiverDetailPage(careGiverDetailsDto: careGiverDetailsDto)
            ],
          ),
        ));
  }
}
