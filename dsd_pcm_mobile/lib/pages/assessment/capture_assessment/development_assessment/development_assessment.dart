import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/development_assessment_dto.dart';
import '../../../../service/pcm/development_assessment_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'capture_development_assessment.dart';
import 'view_development_assessment.dart';

class DevelopmentAssessmentPage extends StatefulWidget {
  const DevelopmentAssessmentPage({Key? key}) : super(key: key);

  @override
  State<DevelopmentAssessmentPage> createState() =>
      _DevelopmentAssessmentPagetate();
}

class _DevelopmentAssessmentPagetate extends State<DevelopmentAssessmentPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final DevelopmentAssessmentService developmentAssessmentServiceClient =
      DevelopmentAssessmentService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<DevelopmentAssessmentDto> developmentAssessmentsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadDevelopmentAssessmentByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadDevelopmentAssessmentByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await developmentAssessmentServiceClient
        .getDevelopmentAssessmentsByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        developmentAssessmentsDto =
            (apiResponse.Data as List<DevelopmentAssessmentDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureDevelopmentAssessment(String? belonging, String? mastery,
      String? independence, String? generosity, String? evaluation) async {
    DevelopmentAssessmentDto addDevelopmentAssessment =
        DevelopmentAssessmentDto(
            developmentId: 0,
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            createdBy: preferences!.getInt('userId')!,
            belonging: belonging,
            mastery: mastery,
            independence: independence,
            generosity: generosity,
            evaluation: evaluation);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await developmentAssessmentServiceClient
        .addDevelopmentAssessment(addDevelopmentAssessment);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const DevelopmentAssessmentPage(),
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
        title: const Text('Development Assessment'),
      ),
      body: ListView(
        children: [
          CaptureDevelopmentAssessmentPage(
              addDevelopmentAssessment: captureDevelopmentAssessment),
          ViewDevelopmentAssessmentPage(
              developmentAssessmentsDto: developmentAssessmentsDto)
        ],
      ),
    );
  }
}
