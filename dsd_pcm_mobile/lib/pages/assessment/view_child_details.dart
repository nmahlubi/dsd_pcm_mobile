import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../model/intake/language_dto.dart';
import '../../model/intake/nationality_dto.dart';
import '../../model/intake/person_dto.dart';
import '../../model/intake/person_education_query_dto.dart';
import '../../model/pcm/accepted_worklist_dto.dart';
import '../../model/pcm/family_information_dto.dart';
import '../../model/pcm/family_member_dto.dart';

import '../../model/pcm/medical_health_detail_dto.dart';
import '../../model/pcm/query/co_accused_details_query_dto.dart';
import '../../service/intake/person_service.dart';
import '../../service/pcm/case_info_service.dart';
import '../../service/pcm/family_service.dart';
import '../../service/pcm/medical_health_details_service.dart';
import 'capture_assessment/capture_assessment.dart';
import 'panel_child_details/co_accused_details_panel.dart';
import 'panel_child_details/education_info_panel.dart';
import 'panel_child_details/family_info_panel.dart';
import 'panel_child_details/family_member_panel.dart';
import 'panel_child_details/medical_info_panel.dart';
import 'panel_child_details/person_info_panel.dart';

class ViewChildDetailsPage extends StatefulWidget {
  const ViewChildDetailsPage({Key? key}) : super(key: key);

  @override
  State<ViewChildDetailsPage> createState() => _ViewChildDetailsPageState();
}

class _ViewChildDetailsPageState extends State<ViewChildDetailsPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final PersonService personServiceClient = PersonService();
  final CaseInfoService caseInfoServiceClient = CaseInfoService();
  final MedicalHealthDetailsService medicalHealthDetailsService =
      MedicalHealthDetailsService();
  final FamilyService familyServiceClient = FamilyService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  late PersonDto personDto = PersonDto();
  late NationalityDto nationalityDto = NationalityDto();
  late LanguageDto languageDto = LanguageDto();
  late List<PersonEducationQueryDto> personEducationsQueryDto = [];
  late List<CoAccusedDetailsQueryDto> coAccusedDetailsQueryDto = [];
  late List<MedicalHealthDetailDto> medicalHealthDetailsDto = [];
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
          initializeControlValues(acceptedWorklistDto);
        });
      });
    });
  }

  initializeControlValues(AcceptedWorklistDto acceptedWorklistDto) async {
    await loadPersonDetailsById(acceptedWorklistDto.personId);
    await loadEducationByPersonId(acceptedWorklistDto.personId);
    await loadCoAccusedByIntakeAssesmentId(
        acceptedWorklistDto.intakeAssessmentId);
    await loadFamilyMembersByIntakeAssesmentId(
        acceptedWorklistDto.intakeAssessmentId);
    await loadFamilyInformationsByIntakeAssesmentId(
        acceptedWorklistDto.intakeAssessmentId);
  }

  loadPersonDetailsById(int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await personServiceClient.getPersonById(
        personId, preferences!.getInt('userId')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personDto = (apiResponse.Data as PersonDto);
        if (personDto.nationalityDto != null) {
          nationalityDto = personDto.nationalityDto!;
        }
        if (personDto.languageDto != null) {
          languageDto = personDto.languageDto!;
        }
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadEducationByPersonId(int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await personServiceClient.getEducationByPersonId(personId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personEducationsQueryDto =
            (apiResponse.Data as List<PersonEducationQueryDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadCoAccusedByIntakeAssesmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await caseInfoServiceClient
        .getCoAccusedDetailsByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        coAccusedDetailsQueryDto =
            (apiResponse.Data as List<CoAccusedDetailsQueryDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadMedicalHealthDetails(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await medicalHealthDetailsService
        .getMedicalHealthDetailsByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        medicalHealthDetailsDto =
            (apiResponse.Data as List<MedicalHealthDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadFamilyMembersByIntakeAssesmentId(int? intakeAssessmentId) async {
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

  loadFamilyInformationsByIntakeAssesmentId(int? intakeAssessmentId) async {
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
        title: const Text('View Child Details'),
      ),
      body: ListView(
        children: [
          PersonInfoPanel(
              personDto: personDto,
              nationalityDto: nationalityDto,
              languageDto: languageDto),
          EducationInfoPanel(
              personEducationsQueryDto: personEducationsQueryDto),
          MedicalInfoPanel(medicalHealthDetailsDto: medicalHealthDetailsDto),
          FamilyMemberPanel(familyMembersDto: familyMembersDto),
          FamilyInfoPanel(familyInformationDto: familyInformationsDto),
          CoAccusedDetailsPanel(
              coAccusedDetailsQueryDto: coAccusedDetailsQueryDto),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Assessment"),
        icon: const Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CaptureAssessmentPage(),
              settings: RouteSettings(
                arguments: acceptedWorklistDto,
              ),
            ),
          );
        },
      ),
    );
  }
}
