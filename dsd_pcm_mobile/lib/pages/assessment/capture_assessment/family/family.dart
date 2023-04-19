import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/family_information_dto.dart';
import '../../../../model/pcm/family_member_dto.dart';
import '../../../../model/pcm/victim_detail_dto.dart';
import '../../../../model/pcm/victim_organisation_detail_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../service/pcm/family_service.dart';
import '../../../../service/pcm/victim_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
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

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final FamilyService familyServiceClient = FamilyService();
  final LookUpService lookUpServiceClient = LookUpService();
  final PersonService personServiceClient = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<GenderDto> gendersDto = [];
  final List<Map<String, dynamic>> genderItemsDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];
  final List<Map<String, dynamic>> relationshipTypeItemsDto = [];
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
          loadGenders();
          loadRelationshipTypes();
          loadFamilyMembersByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
          loadFamilyInformationsByIntakeAssessmentId(
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
        for (var gender in gendersDto) {
          Map<String, dynamic> genderItem = {
            "genderId": gender.genderId,
            "description": '${gender.description}'
          };
          genderItemsDto.add(genderItem);
        }
      });
    }
    overlay.hide();
  }

  loadRelationshipTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getRelationshipTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        relationshipTypesDto = (apiResponse.Data as List<RelationshipTypeDto>);
        for (var relation in relationshipTypesDto) {
          Map<String, dynamic> relationshipType = {
            "relationshipTypeId": relation.relationshipTypeId,
            "description": '${relation.description}'
          };
          relationshipTypeItemsDto.add(relationshipType);
        }
      });
    }
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

  captureFamilyMember(String? name, String? surname, int? age, String? gender,
      String? relationshipType) async {
    //GenderDto genderValue = GenderDto.fromJson(gender);
    //RelationshipTypeDto relationshipTypeValue =
    // RelationshipTypeDto.fromJson(relationshipType);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await addPerson(name, surname, age, 1);
    if ((apiResponse.ApiError) == null) {
      apiResults = (apiResponse.Data as ApiResults);
      FamilyMemberDto familyMemberDto = FamilyMemberDto(
          familyMemberId: 0,
          intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
          personId: 335371, // personDtoResponse.personId,
          relationshipTypeId: 1, // relationshipTypeValue.relationshipTypeId,
          createdBy: preferences!.getInt('userId')!);

      apiResponse = await familyServiceClient.addFamilyMember(familyMemberDto);
      if ((apiResponse.ApiError) == null) {
        apiResults = (apiResponse.Data as ApiResults);
        overlay.hide();
        await showAlertDialogMessage(
            "Successfull", (apiResponse.Data as ApiResults).message!);
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
  }

  captureFamilyInformation(String? familyBackground) async {
    FamilyInformationDto familyInformationDto = FamilyInformationDto(
        familyInformationId: 0,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        familyBackground: familyBackground,
        createdBy: preferences!.getInt('userId')!);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await familyServiceClient.addFamilyInformation(familyInformationDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
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

  Future<ApiResponse> addPerson(
      String? name, String? surname, int? age, int? gender) async {
    PersonDto personDto = PersonDto(
        personId: 0,
        isEstimatedAge: true,
        isPivaValidated: true,
        firstName: name,
        lastName: surname,
        age: age,
        genderId: gender,
        createdBy: preferences!.getString('username')!);
    apiResponse = await personServiceClient.addPerson(personDto);
    return apiResponse;
  }
//family information

/*
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

  */

  /*

  

  */

/*
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
  */

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
        title: const Text('Family'),
      ),
      body: ListView(
        children: [
          CaptureFamilyMemberPage(
              genderItemsDto: genderItemsDto,
              relationshipTypeItemsDto: relationshipTypeItemsDto,
              addNewFamilyMember: captureFamilyMember),
          ViewFamilyMemberPage(familyMembersDto: familyMembersDto),
          CaptureFamilyInformationPage(
              addNewFamilyInformation: captureFamilyInformation),
          ViewFamilyInformationPage(
              familyInformationsDto: familyInformationsDto),
        ],
      ),
    );
  }
}
