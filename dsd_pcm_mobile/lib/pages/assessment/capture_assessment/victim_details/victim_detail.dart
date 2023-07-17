import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/victim_detail_dto.dart';
import '../../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/victim_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../development_assessment.dart';
import '../offence_details/offence_detail.dart';
import 'capture_victim_detail.dart';
import 'capture_victim_organisation_detail.dart';
import 'view_victim_detail.dart';
import 'view_victim_organisation_detail.dart';

class VictimDetailPage extends StatefulWidget {
  const VictimDetailPage({Key? key}) : super(key: key);

  @override
  State<VictimDetailPage> createState() => _VictimDetailPageState();
}

class _VictimDetailPageState extends State<VictimDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final _lookupTransform = LookupTransform();
  final _victimServiceClient = VictimService();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late VictimOrganisationDetailDto victimOrganisationDetailDto =
      VictimOrganisationDetailDto();
  late List<VictimDetailDto> victimDetailsDto = [];
  late List<VictimOrganisationDetailDto> victimOrganisationDetailsDto = [];
  late List<GenderDto> gendersDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadVictimDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
          loadVictimOrganisationDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    gendersDto = await _lookupTransform.transformGendersDto();
    overlay.hide();
  }

  loadVictimDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _victimServiceClient
        .getVictimDetailByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        victimDetailsDto = (apiResponse.Data as List<VictimDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
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
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureVictimIndividual(
      String? name,
      String? surname,
      String? dateOfBirth,
      int? age,
      int? genderId,
      String? victimOccupation,
      String? isVictimIndividual,
      String? victimCareGiverNames,
      String? addressLine1,
      String? addressLine2,
      String? postalCode) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    int? localPersonId = _randomGenerator.getRandomGeneratedNumber();
    VictimDetailDto requestVictimDetailDto = VictimDetailDto(
        victimId: _randomGenerator.getRandomGeneratedNumber(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        isVictimIndividual: isVictimIndividual,
        personId: localPersonId,
        victimOccupation: victimOccupation,
        victimCareGiverNames: victimCareGiverNames,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        postalCode: postalCode,
        createdBy: preferences!.getInt('userId')!,
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
        ));
    overlay.show();
    apiResponse =
        await _victimServiceClient.addVictimDetail(requestVictimDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Victim Detail Successfully Created');

      navigator.push(
        MaterialPageRoute(
            builder: (context) => const VictimDetailPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureVictimOrganisation(
      String? organisationName,
      String? contactPersonFirstName,
      String? contactPersonLastName,
      String? telephone,
      String? cellNo,
      String? interventionserviceReferrals,
      String? otherContacts,
      String? contactPersonOccupation,
      String? addressLine1,
      String? addressLine2,
      String? postalCode) async {
    VictimOrganisationDetailDto victimOrganisationDetailDto =
        VictimOrganisationDetailDto(
            victimOrganisationId: _randomGenerator.getRandomGeneratedNumber(),
            dateCreated: _randomGenerator.getCurrentDateGenerated(),
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            organisationName: organisationName,
            contactPersonFirstName: contactPersonFirstName,
            contactPersonLastName: contactPersonLastName,
            telephone: telephone,
            cellNo: cellNo,
            interventionserviceReferrals: interventionserviceReferrals,
            otherContacts: otherContacts,
            contactPersonOccupation: contactPersonOccupation,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            postalCode: postalCode,
            createdBy: preferences!.getInt('userId')!);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await _victimServiceClient
        .addVictimOrganisation(victimOrganisationDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Organization Successfully Created.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const VictimDetailPage(),
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
            title: const Text("Victim"),
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
                          builder: (context) => const OffenceDetailPage(),
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
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            children: [
              CaptureVictimDetailPage(
                  gendersDto: gendersDto,
                  captureVictimIndividual: captureVictimIndividual),
              ViewVictimDetailPage(victimDetailsDto: victimDetailsDto),
              CaptureVictimOrganisationDetailPage(
                  addNewVictimOrganisation: captureVictimOrganisation),
              ViewVictimOrganisationDetailPage(
                  victimOrganisationDetailsDto: victimOrganisationDetailsDto),
            ],
          ),
        ));
  }
}
