import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/child_notification/case_information_dto.dart';
import '../../../model/child_notification/child_information_dto.dart';
import '../../../model/child_notification/country_dto.dart';
import '../../../model/child_notification/gender_dto.dart';
import '../../../model/child_notification/language_dto.dart';
import '../../../model/child_notification/offence_type_dto.dart';
import '../../../model/child_notification/police_station_dto.dart';
import '../../../model/child_notification/race_dto.dart';
import '../../../model/child_notification/saps_info_dto.dart';
import '../../../model/intake/probation_officer_dto.dart';
import '../../../model/pcm/allocated_case_supervisor_dto.dart';
import '../../../model/pcm/request/re_allocate_case.dart';
import '../../../service/child_notification/case_information_service.dart';
import '../../../service/child_notification/notification_service.dart';
import '../../../service/child_notification/offense_type_service.dart';
import '../../../service/intake/user_service.dart';
import '../../../service/pcm/endpoint_inbox_service.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../welcome/dashboard.dart';
import '../case_details/panels/allocated_probation_officer_panel.dart';
import '../case_details/panels/child_details_panel.dart';
import '../case_details/panels/offence_details_panel.dart';
import '../case_details/panels/saps_details_panel.dart';
import '../case_details/panels/saps_official_details_panel.dart';

class CompleteReAssignedCasesPage extends StatefulWidget {
  const CompleteReAssignedCasesPage({Key? key}) : super(key: key);

  @override
  State<CompleteReAssignedCasesPage> createState() =>
      _CompleteReAssignedCasesPageState();
}

class _CompleteReAssignedCasesPageState
    extends State<CompleteReAssignedCasesPage> {
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
  final EndPointInboxService endPointInboxServiceClient =
      EndPointInboxService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late CaseInformationDto caseInformationDto = CaseInformationDto();
  late AllocatedCaseSupervisorDto allocatedCaseSupervisorDto =
      AllocatedCaseSupervisorDto();
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
          allocatedCaseSupervisorDto = ModalRoute.of(context)!
              .settings
              .arguments as AllocatedCaseSupervisorDto;
          initializeControlValues(allocatedCaseSupervisorDto);
        });
      });
    });
  }

  initializeControlValues(
      AllocatedCaseSupervisorDto allocatedCaseSupervisorDto) async {
    await loadCaseInformationDetails(
        allocatedCaseSupervisorDto.caseInformationId);
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

  reAllocateProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    ProbationOfficerDto probationOfficerItem =
        ProbationOfficerDto.fromJson(probationOfficerController!.value);

    ReAllocateCase reAllocateCase = ReAllocateCase(
        endPointPOId: allocatedCaseSupervisorDto.endpointPoId,
        probationOfficerId: probationOfficerItem.userId,
        modifiedBy: preferences!.getInt('userId')!);

    apiResponse =
        await endPointInboxServiceClient.reAllocateCase(reAllocateCase);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      await showAlertDialogMessage("Successfull", apiResults.message!);
      navigator.push(
        MaterialPageRoute(builder: (context) => const DashboardPage(title: '')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Case For: ${childInformationDto.childName}'),
      ),
      body: ListView(
        children: [
          AllocatedProbationOfficerPanel(
              allocatedCaseSupervisorDto: allocatedCaseSupervisorDto),
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
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(title: Text('Probation Officer To Re Allocate')),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: probationOfficerController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Select Probation Officer"),
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
                        item['username']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
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
                      child: const Text('Complete'),
                      onPressed: () {
                        reAllocateProbationOfficer();
                      },
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
