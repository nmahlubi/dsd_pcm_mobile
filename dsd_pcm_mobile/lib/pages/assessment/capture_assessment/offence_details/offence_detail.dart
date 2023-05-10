import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/family_information_dto.dart';
import '../../../../model/pcm/family_member_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../service/pcm/family_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';

class OffenceDetailPage extends StatefulWidget {
  const OffenceDetailPage({Key? key}) : super(key: key);

  @override
  State<OffenceDetailPage> createState() => _OffenceDetailPageState();
}

class _OffenceDetailPageState extends State<OffenceDetailPage> {
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

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
