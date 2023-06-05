import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/offence_category_dto.dart';
import '../../../../model/intake/offence_schedule_dto.dart';
import '../../../../model/intake/offence_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/offence_detail_dto.dart';
import '../../../../model/static_model/yes_no_dto.dart';
import '../../../../service/intake/offence_service.dart';
import '../../../../service/pcm/offence_detail_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'capture_offence_detail.dart';
import 'view_offence_detail.dart';

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
  final OffenceService offenceServiceClient = OffenceService();
  final OffenceDetailService offenceDetailServiceClient =
      OffenceDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<OffenceTypeDto> offenceTypesDto = [];
  final List<Map<String, dynamic>> offenceTypeItemsDto = [];
  late List<OffenceCategoryDto> offenceCategoriesDto = [];
  final List<Map<String, dynamic>> offenceCategoryItemsDto = [];
  late List<OffenceScheduleDto> offenceSchedulesDto = [];
  final List<Map<String, dynamic>> offenceScheduleItemsDto = [];
  final List<Map<String, dynamic>> yesNoDtoItemsDto = [];
  late List<OffenceDetailDto> offenceDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadYesNoStatus();
          loadOffenceCategory();
          loadOffenceSchedule();
          loadOffenceTypes();
          loadOffenceDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadYesNoStatus() async {
    yesNoDtoItemsDto.add({"value": 'Yes', "description": 'Yes'});
    yesNoDtoItemsDto.add({"value": 'No', "description": 'No'});
  }

  loadOffenceCategory() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceServiceClient.getOffenceCategories();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        offenceCategoriesDto = (apiResponse.Data as List<OffenceCategoryDto>);
        for (var offenceCategory in offenceCategoriesDto) {
          Map<String, dynamic> offenceCategoryItem = {
            "offenceCategoryId": offenceCategory.offenceCategoryId,
            "description": '${offenceCategory.description}'
          };
          offenceCategoryItemsDto.add(offenceCategoryItem);
        }
      });
    }
    overlay.hide();
  }

  loadOffenceSchedule() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceServiceClient.getOffenceSchedules();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        offenceSchedulesDto = (apiResponse.Data as List<OffenceScheduleDto>);
        for (var offenceSchedule in offenceSchedulesDto) {
          Map<String, dynamic> offenceScheduleItem = {
            "offenceScheduleId": offenceSchedule.offenceScheduleId,
            "description": '${offenceSchedule.description}'
          };
          offenceScheduleItemsDto.add(offenceScheduleItem);
        }
      });
    }
    overlay.hide();
  }

  loadOffenceTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceServiceClient.getOffenceTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        offenceTypesDto = (apiResponse.Data as List<OffenceTypeDto>);
        for (var offenceType in offenceTypesDto) {
          Map<String, dynamic> offenceTypeItem = {
            "offenceTypeId": offenceType.offenceTypeId,
            "description": '${offenceType.description}'
          };
          offenceTypeItemsDto.add(offenceTypeItem);
        }
      });
    }
    overlay.hide();
  }

  loadOffenceDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceDetailServiceClient
        .getOffenceDetailIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        offenceDetailsDto = (apiResponse.Data as List<OffenceDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureOffenceDetails(
      OffenceTypeDto offenceTypeDtoValue,
      OffenceCategoryDto offenceCategoryDtoValue,
      OffenceScheduleDto offenceScheduleDtoValue,
      String? offenceCircumstance,
      String? valueOfGoods,
      String? valueRecovered,
      YesNoDto isChildResponsible,
      String? responsibilityDetails) async {
    OffenceDetailDto addOffenceDetailDto = OffenceDetailDto(
        pcmOffenceId: 0,
        pcmCaseId: acceptedWorklistDto.caseId,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        offenceTypeId: offenceTypeDtoValue.offenceTypeId,
        offenceCategoryId: offenceCategoryDtoValue.offenceCategoryId,
        offenceScheduleId: offenceScheduleDtoValue.offenceScheduleId,
        offenceCircumstance: offenceCircumstance,
        valueOfGoods: valueOfGoods,
        valueRecovered: valueRecovered,
        isChildResponsible: isChildResponsible.value,
        responsibilityDetails: responsibilityDetails);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await offenceDetailServiceClient.addOffenceDetail(addOffenceDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const OffenceDetailPage(),
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
        title: const Text('Offence Details'),
      ),
      body: ListView(
        children: [
          CaptureOffenceDetailPage(
              yesNoDtoItemsDto: yesNoDtoItemsDto,
              offenceTypeItemsDto: offenceTypeItemsDto,
              offenceCategoryItemsDto: offenceCategoryItemsDto,
              offenceScheduleItemsDto: offenceScheduleItemsDto,
              addNewOffenceDetail: captureOffenceDetails),
          ViewOffenceDetailPage(offenceDetailsDto: offenceDetailsDto)
        ],
      ),
    );
  }
}
