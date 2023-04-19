import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/health_status_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/general_detail_dto.dart';
import '../../../../model/pcm/medical_health_detail_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/pcm/general_detail_service.dart';
import '../../../../service/pcm/medical_health_details_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'capture_medical_health.dart';
import 'view_medical_health.dart';

class HealthDetailPage extends StatefulWidget {
  const HealthDetailPage({Key? key}) : super(key: key);

  @override
  State<HealthDetailPage> createState() => _HealthDetailPageState();
}

class _HealthDetailPageState extends State<HealthDetailPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final LookUpService lookUpServiceClient = LookUpService();
  final MedicalHealthDetailsService medicalHealthDetailsServiceClient =
      MedicalHealthDetailsService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<HealthStatusDto> healthStatusesDto = [];
  final List<Map<String, dynamic>> healthStatusItemsDto = [];
  late List<MedicalHealthDetailDto> medicalHealthDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadHealthStatuses();
          loadMedicalHealthDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadHealthStatuses() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getHealthStatuses();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        healthStatusesDto = (apiResponse.Data as List<HealthStatusDto>);
        for (var health in healthStatusesDto) {
          Map<String, dynamic> healthItem = {
            "healthStatusId": health.healthStatusId,
            "description": '${health.description}'
          };
          healthStatusItemsDto.add(healthItem);
        }
      });
    }
    overlay.hide();
  }

  loadMedicalHealthDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await medicalHealthDetailsServiceClient
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

  captureMedicalHealth() {}

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
        title: const Text('General Details'),
      ),
      body: ListView(
        children: [
          CaptureMedicalHealthPage(
              healthStatusItemsDto: healthStatusItemsDto,
              addNewMedicalHealth: captureMedicalHealth),
          ViewMedicalHealth(medicalHealthDetailsDto: medicalHealthDetailsDto)
        ],
      ),
    );
  }
}
