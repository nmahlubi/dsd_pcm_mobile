import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/victim_detail_dto.dart';
import '../../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../service/pcm/victim_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
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

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final VictimService victimServiceClient = VictimService();
  final LookUpService lookUpServiceClient = LookUpService();
  final PersonService personServiceClient = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<VictimDetailDto> victimDetailsDto = [];
  late VictimOrganisationDetailDto victimOrganisationDetailDto =
      VictimOrganisationDetailDto();
  late List<VictimOrganisationDetailDto> victimOrganisationDetailsDto = [];
  late List<GenderDto> gendersDto = [];
  late PersonDto personDtoResponse = PersonDto();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadVictimDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
          loadVictimOrganisationDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadGenders() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getGenders();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        gendersDto = (apiResponse.Data as List<GenderDto>);
      });
    }
    overlay.hide();
  }

  loadVictimDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await victimServiceClient
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
    apiResponse = await victimServiceClient
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

  captureVictim(
      String? name,
      String? surname,
      String? age,
      String? gender,
      String? victimOccupation,
      String? isVictimIndividual,
      String? victimCareGiverNames,
      String? addressLine1,
      String? addressLine2,
      String? postalCode) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await addPerson(name, surname, age, gender);
    if ((apiResponse.ApiError) == null) {
      apiResults = (apiResponse.Data as ApiResults);
      VictimDetailDto victimDetailDto = VictimDetailDto(
          victimId: 0,
          intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
          isVictimIndividual: isVictimIndividual,
          personId: 335371, // personDtoResponse.personId,
          victimOccupation: victimOccupation,
          victimCareGiverNames: victimCareGiverNames,
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          postalCode: postalCode,
          createdBy: preferences!.getInt('userId')!);

      apiResponse = await victimServiceClient.addVictimDetail(victimDetailDto);
      if ((apiResponse.ApiError) == null) {
        overlay.hide();
        await showAlertDialogMessage(
            "Successfull", (apiResponse.Data as ApiResults).message!);
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
  }

  Future<ApiResponse> addPerson(
      String? name, String? surname, String? age, String? gender) async {
    PersonDto personDto = PersonDto(
        personId: 0,
        isEstimatedAge: true,
        isPivaValidated: true,
        firstName: name,
        lastName: surname,
        age: 17,
        genderId: 1,
        createdBy: preferences!.getString('username')!);
    apiResponse = await personServiceClient.addPerson(personDto);
    return apiResponse;
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
            victimOrganisationId: 0,
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
    apiResponse = await victimServiceClient
        .addVictimOrganisation(victimOrganisationDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
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

  showAlertDialogMessage(String? headerMessage, String? message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(headerMessage!),
        content: Text(message!),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              //color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victim'),
      ),
      body: ListView(
        children: [
          CaptureVictimDetailPage(
              gendersDto: gendersDto, addNewVictim: captureVictim),
          ViewVictimDetailPage(victimDetailsDto: victimDetailsDto),
          CaptureVictimOrganisationDetailPage(
              addNewVictimOrganisation: captureVictimOrganisation),
          ViewVictimOrganisationDetailPage(
              victimOrganisationDetailsDto: victimOrganisationDetailsDto,
              victimOrganisationDetailDto: victimOrganisationDetailDto),
        ],
      ),
    );
  }
}
