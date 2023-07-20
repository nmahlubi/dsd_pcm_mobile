import 'package:dsd_pcm_mobile/model/child_notification/language_dto.dart';
import 'package:dsd_pcm_mobile/model/child_notification/race_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/child_notification/case_information_dto.dart';
import '../../../model/child_notification/child_information_dto.dart';
import '../../../model/child_notification/country_dto.dart';
import '../../../model/child_notification/gender_dto.dart';
import '../../../model/child_notification/notification_case_dto.dart';
import '../../../model/child_notification/offence_type_dto.dart';
import '../../../model/child_notification/police_station_dto.dart';
import '../../../model/child_notification/request/request_assign_case.dart';
import '../../../model/child_notification/saps_info_dto.dart';
import '../../../model/intake/probation_officer_dto.dart';
import '../../../service/child_notification/case_information_service.dart';
import '../../../service/child_notification/notification_service.dart';
import '../../../service/child_notification/offense_type_service.dart';
import '../../../service/intake/user_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../notification_cases.dart';
import 'panels/child_details_panel.dart';
import 'panels/offence_details_panel.dart';
import 'panels/saps_details_panel.dart';
import 'panels/saps_official_details_panel.dart';

class CaseDetailsAssignPage extends StatefulWidget {
  const CaseDetailsAssignPage({Key? key}) : super(key: key);

  @override
  State<CaseDetailsAssignPage> createState() => _CaseDetailsAssignPageState();
}

class _CaseDetailsAssignPageState extends State<CaseDetailsAssignPage> {
  SharedPreferences? preferences;
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final OffenseTypeService offenseTypeServiceClient = OffenseTypeService();
  final NotificationService notificationServiceClient = NotificationService();
  final CaseInformationService caseInformationServiceClient =
      CaseInformationService();
  final UserService userServiceClient = UserService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late CaseInformationDto caseInformationDto = CaseInformationDto();
  late NotificationCaseDto notificationCaseDto = NotificationCaseDto();
  late ChildInformationDto childInformationDto = ChildInformationDto();
  late GenderDto genderDto = GenderDto();
  late CountryDto countryDto = CountryDto();
  late RaceDto raceDto = RaceDto();
  late LanguageDto languageDto = LanguageDto();
  late SapsInfoDto sapsInfoDto = SapsInfoDto();
  late PoliceStationDto? policeStationDto = PoliceStationDto();
  late OffenseTypeDto offenseTypeDto = OffenseTypeDto();
  late List<ProbationOfficerDto> probationOfficersDto = [];
  int? probationOfficeDropdownButtonFormField;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          notificationCaseDto =
              ModalRoute.of(context)!.settings.arguments as NotificationCaseDto;
          initializeControlValues(notificationCaseDto);
        });
      });
    });
  }

  initializeControlValues(NotificationCaseDto notificationCaseDto) async {
    await loadCaseInformationDetails(notificationCaseDto.caseInformationId);
    await loadOffenceByCode(caseInformationDto.offenseType.toString());
    await loadProbationOfficersBySupervisor(preferences!.getInt('userId')!);
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
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
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
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadProbationOfficersBySupervisor(int? supervisorId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await userServiceClient
        .getProbationOfficersBySupervisorId(supervisorId);
    if ((apiResponse.ApiError) == null) {
      setState(() {
        probationOfficersDto = (apiResponse.Data as List<ProbationOfficerDto>);
      });
    }
    overlay.hide();
  }

  assignCaseToProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    RequestAssignCase requestAssignCase = RequestAssignCase(
        notificationId: notificationCaseDto.notificacationId,
        probationOfficerId: probationOfficeDropdownButtonFormField,
        caseInformationId: notificationCaseDto.caseInformationId,
        contactTypeId: 1,
        estimatedArrivalTime: _randomGenerator.getCurrentDateGenerated());

    apiResponse = await caseInformationServiceClient
        .assignCaseToProbationOfficer(requestAssignCase);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      showSuccessMessage("Case Successfull Assign");
      navigator.push(
        MaterialPageRoute(builder: (context) => const NotificationCasesPage()),
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
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(childInformationDto.childName.toString()),
            ),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
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
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: DropdownButtonFormField(
                                    value:
                                        probationOfficeDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Probation Officer',
                                      labelText: 'Probation Officer',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    isDense: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    isExpanded: true,
                                    items: probationOfficersDto.map((officer) {
                                      return DropdownMenuItem(
                                          value: officer.userId,
                                          child: Text(
                                              '${officer.firstName} ${officer.lastName}'));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      probationOfficeDropdownButtonFormField =
                                          selectedValue;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Probation Officer Required';
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
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
                          )),
                          Expanded(
                              child: Container(
                                  height: 70,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 23, 22, 22),
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                          width: 2, color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        assignCaseToProbationOfficer();
                                      }
                                    },
                                    child: const Text('Assign Case'),
                                  ))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                      ),
                    ],
                  ),
                ))));
  }
}
