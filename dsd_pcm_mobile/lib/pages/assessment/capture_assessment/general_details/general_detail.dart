import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/general_detail_dto.dart';
import '../../../../service/pcm/general_detail_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'capture_general_detail.dart';
import 'view_general_detail.dart';

class GeneralDetailPage extends StatefulWidget {
  const GeneralDetailPage({Key? key}) : super(key: key);

  @override
  State<GeneralDetailPage> createState() => _GeneralDetailPageState();
}

class _GeneralDetailPageState extends State<GeneralDetailPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final GeneralDetailService generalDetailServiceClient =
      GeneralDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<GeneralDetailDto> generalDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadGeneralDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadGeneralDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await generalDetailServiceClient
        .getGeneralDetailByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        generalDetailsDto = (apiResponse.Data as List<GeneralDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureGeneralDetail(String? consultedSources, String? traceEfforts,
      String? commentsBySupervisor, String? additionalInfo) async {
    GeneralDetailDto generalDetailDto = GeneralDetailDto(
        generalDetailsId: 0,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        consultedSources: consultedSources,
        traceEfforts: traceEfforts,
        commentsBySupervisor: commentsBySupervisor,
        additionalInfo: additionalInfo);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await generalDetailServiceClient.addGeneralDetail(generalDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const GeneralDetailPage(),
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
        title: const Text('General Details'),
      ),
      body: ListView(
        children: [
          CaptureGeneralDetailPage(addNewGeneralDetail: captureGeneralDetail),
          ViewGeneralDetailPage(generalDetailsDto: generalDetailsDto)
        ],
      ),
    );
  }
}
