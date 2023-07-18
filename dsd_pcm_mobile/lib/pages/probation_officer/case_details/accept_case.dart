import 'package:dsd_pcm_mobile/model/child_notification/language_dto.dart';
import 'package:dsd_pcm_mobile/model/child_notification/race_dto.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/child_notification/case_information_dto.dart';
import '../../../model/child_notification/child_information_dto.dart';
import '../../../model/child_notification/country_dto.dart';
import '../../../model/child_notification/gender_dto.dart';
import '../../../model/child_notification/offence_type_dto.dart';
import '../../../model/child_notification/police_station_dto.dart';
import '../../../model/child_notification/saps_info_dto.dart';
import '../../../model/intake/probation_officer_dto.dart';
import '../../../model/pcm/allocated_case_probation_officer_dto.dart';
import '../../../model/pcm/request/create_worklist.dart';
import '../../../service/child_notification/case_information_service.dart';
import '../../../service/child_notification/notification_service.dart';
import '../../../service/child_notification/offense_type_service.dart';
import '../../../service/intake/user_service.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../sessions/session.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../supervisor/case_details/panels/child_details_panel.dart';
import '../../supervisor/case_details/panels/offence_details_panel.dart';
import '../../supervisor/case_details/panels/saps_details_panel.dart';
import '../../supervisor/case_details/panels/saps_official_details_panel.dart';
import '../../welcome/dashboard.dart';

class AcceptCasePage extends StatefulWidget {
  const AcceptCasePage({Key? key}) : super(key: key);

  @override
  State<AcceptCasePage> createState() => _AcceptCasePageState();
}

class _AcceptCasePageState extends State<AcceptCasePage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final OffenseTypeService offenseTypeServiceClient = OffenseTypeService();
  final NotificationService notificationServiceClient = NotificationService();
  final CaseInformationService caseInformationServiceClient =
      CaseInformationService();
  final UserService userServiceClient = UserService();
  final WorklistService worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late CaseInformationDto caseInformationDto = CaseInformationDto();
  late AllocatedCaseProbationOfficerDto allocatedCaseProbationOfficerDto =
      AllocatedCaseProbationOfficerDto();
  late ChildInformationDto childInformationDto = ChildInformationDto();
  late GenderDto genderDto = GenderDto();
  late CountryDto countryDto = CountryDto();
  late RaceDto raceDto = RaceDto();
  late LanguageDto languageDto = LanguageDto();
  late SapsInfoDto sapsInfoDto = SapsInfoDto();
  late PoliceStationDto? policeStationDto = PoliceStationDto();
  late OffenseTypeDto offenseTypeDto = OffenseTypeDto();
  late List<ProbationOfficerDto> probationOfficersDto = [];
  final List<Map<String, dynamic>> probationOfficerItemsDto = [];
  DropdownEditingController<Map<String, dynamic>>? probationOfficerController =
      DropdownEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          allocatedCaseProbationOfficerDto = ModalRoute.of(context)!
              .settings
              .arguments as AllocatedCaseProbationOfficerDto;
          initializeControlValues(allocatedCaseProbationOfficerDto);
        });
      });
    });
  }

  initializeControlValues(
      AllocatedCaseProbationOfficerDto allocatedCaseProbationOfficerDto) async {
    await loadCaseInformationDetails(
        allocatedCaseProbationOfficerDto.caseInformationId);
    await loadOffenceByCode(caseInformationDto.offenseType.toString());
    //await loadProbationOfficersBySupervisor(preferences!.getInt('userId')!);
  }

  loadCaseInformationDetails(int? caseInformationId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await caseInformationServiceClient
        .getCaseInformationById(caseInformationId);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        caseInformationDto = (apiResponse.Data as CaseInformationDto);
        childInformationDto = caseInformationDto.childInformationDto!;
        genderDto = childInformationDto.genderDto!;
        countryDto = childInformationDto.countryDto!;
        raceDto = childInformationDto.raceDto!;
        languageDto = childInformationDto.languageDto!;
        sapsInfoDto = caseInformationDto.sapsInfoDto!;
        policeStationDto = caseInformationDto.sapsInfoDto!.policeStationDto!;
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadOffenceByCode(String offenseCode) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse =
        await offenseTypeServiceClient.getOffenceTypeByCode(offenseCode);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        offenseTypeDto = (apiResponse.Data as OffenseTypeDto);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  acceptCaseToStartAssessment() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    CreateWorklist requestCreateWorklist = CreateWorklist(
        endPointPOId: allocatedCaseProbationOfficerDto.endPointPodId,
        userId: preferences!.getInt('userId')!);

    apiResponse =
        await worklistServiceClient.createWorklist(requestCreateWorklist);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      await showAlertDialogMessage("Successfull", apiResults.message!);
      Session session = Session();

      navigator.push(
        MaterialPageRoute(
            builder: (context) => DashboardPage(session: session, title: '')),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Case For: ${childInformationDto.childName}'),
          ),
          body: ListView(
            children: [
              ChildDetailsPanel(
                  childInformationDto: childInformationDto,
                  genderDto: genderDto,
                  countryDto: countryDto,
                  raceDto: raceDto,
                  languageDto: languageDto),
              SapsDetailsPanel(
                  caseInformationDto: caseInformationDto,
                  policeStationDto: policeStationDto),
              SapsOfficialDetailsPanel(sapsInfoDto: sapsInfoDto),
              OffenceDetailsPanel(offenseTypeDto: offenseTypeDto),
              Container(
                padding: const EdgeInsets.all(3),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text("Accept"),
            icon: const Icon(Icons.add),
            onPressed: () {
              acceptCaseToStartAssessment();
            },
          ),
        ));
  }
}
