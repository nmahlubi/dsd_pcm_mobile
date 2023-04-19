import 'package:dsd_pcm_mobile/model/child_notification/language_dto.dart';
import 'package:dsd_pcm_mobile/model/child_notification/race_dto.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
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

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

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
  final List<Map<String, dynamic>> probationOfficerItemsDto = [];
  DropdownEditingController<Map<String, dynamic>>? probationOfficerController =
      DropdownEditingController();

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

  loadProbationOfficersBySupervisor(int? supervisorId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await userServiceClient
        .getProbationOfficersBySupervisorId(supervisorId);

    if ((apiResponse.ApiError) == null) {
      setState(() {
        probationOfficersDto = (apiResponse.Data as List<ProbationOfficerDto>);
        for (var probationOfficer in probationOfficersDto) {
          Map<String, dynamic> probationOfficerItem = {
            "fullNames":
                '${probationOfficer.firstName} ${probationOfficer.lastName}',
            "usernameDesc":
                '${probationOfficer.username} ${probationOfficer.persalNo}',
            "username": probationOfficer.username,
            "firstName":
                '${probationOfficer.firstName} ${probationOfficer.lastName}',
            "lastName": probationOfficer.lastName,
            "userId": probationOfficer.userId,
            "persalNo": probationOfficer.persalNo,
          };
          probationOfficerItemsDto.add(probationOfficerItem);
        }
      });
    }
    overlay.hide();
  }

  assignCaseToProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    ProbationOfficerDto probationOfficerItem =
        ProbationOfficerDto.fromJson(probationOfficerController!.value);

    RequestAssignCase requestAssignCase = RequestAssignCase(
        notificationId: notificationCaseDto.notificacationId,
        probationOfficerId: probationOfficerItem.userId,
        caseInformationId: notificationCaseDto.caseInformationId,
        contactTypeId: 1,
        estimatedArrivalTime: '2023-01-15');

    apiResponse = await caseInformationServiceClient
        .assignCaseToProbationOfficer(requestAssignCase);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      await showAlertDialogMessage("Successfull", apiResults.message!);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(childInformationDto.childName.toString()),
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
            padding: const EdgeInsets.all(10),
            child: DropdownFormField<Map<String, dynamic>>(
              controller: probationOfficerController,
              onEmptyActionPressed: () async {},
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  labelText: "Probation Officer"),
              onSaved: (dynamic str) {},
              onChanged: (dynamic str) {},
              //validator: (dynamic str) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select probation officer';
                }
                return null;
              },
              displayItemFn: (dynamic item) => Text(
                (item ?? {})['fullNames'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              findFn: (dynamic str) async => probationOfficerItemsDto,
              selectedFn: (dynamic item1, dynamic item2) {
                if (item1 != null && item2 != null) {
                  return item1['username'] == item2['username'];
                }
                return false;
              },
              filterFn: (dynamic item, str) =>
                  item['username'].toLowerCase().indexOf(str.toLowerCase()) >=
                  0,
              dropdownItemFn: (dynamic item, int position, bool focused,
                      bool selected, Function() onTap) =>
                  ListTile(
                title: Text(item['fullNames']),
                subtitle: Text(
                  item['usernameDesc'] ?? '',
                ),
                tileColor: focused
                    ? const Color.fromARGB(20, 0, 0, 0)
                    : Colors.transparent,
                onTap: onTap,
              ),
            ),
          ),
          Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
              child: ElevatedButton(
                child: const Text('Assign Case To Probation Officer'),
                onPressed: () {
                  assignCaseToProbationOfficer();
                },
              )),
          Container(
            padding: const EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
