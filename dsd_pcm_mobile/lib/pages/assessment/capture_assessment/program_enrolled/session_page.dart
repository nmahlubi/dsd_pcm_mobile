import 'package:dsd_pcm_mobile/model/pcm/accepted_worklist_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programs_enrolled_dto.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/program_enrolled/view_programs_enrolled.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../model/pcm/program_enrolment_session_outcome_dto.dart';
import '../../../../../service/pcm/program_enrolment_session_outcome_service.dart';
import '../../../../../service/pcm/programs_enrolled_service.dart';
import '../../../../../util/shared/apierror.dart';
import '../../../../../util/shared/apiresponse.dart';
import '../../../../../util/shared/apiresults.dart';
import '../../../../../util/shared/loading_overlay.dart';
import 'capture_program_enrolment_session_outcome.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto completedWorklistDto = AcceptedWorklistDto();
  final PorgramEnrolledService programEnrolledServiceClient =
      PorgramEnrolledService();
  final ProgramEnrollmentSessionOutcomeService
      programEnrollmentSessionOutcomeServiceClient =
      ProgramEnrollmentSessionOutcomeService();
  late List<ProgramsEnrolledDto> programsEnrolledDto = [];
  late List<ProgramEnrolmentSessionOutcomeDto>
      programEnrolmentSessionOutcomeDto = [];

  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          completedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadProgramEnrolled(completedWorklistDto.personId);
          loadProgramEnrollmentSessionOutcome(2);
        });
      });
    });
  }

  loadProgramEnrolled(int? userId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse =
        await programEnrolledServiceClient.getProgramsEnrolled(userId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programsEnrolledDto = (apiResponse.Data as List<ProgramsEnrolledDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadProgramEnrollmentSessionOutcome(int? sessionId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await programEnrollmentSessionOutcomeServiceClient
        .getProgramEnrollmentSessionOutcome(sessionId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programEnrolmentSessionOutcomeDto =
            (apiResponse.Data as List<ProgramEnrolmentSessionOutcomeDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  addProgramEnrollmentSessionOutcome(
      String? sessionDate, String? sessionOutcome) async {
    ProgramEnrolmentSessionOutcomeDto programEnrolmentSessionOutcomeDto =
        ProgramEnrolmentSessionOutcomeDto(
            sessionId: 0,
            enrolmentID: 0,
            programModuleId: 0,
            sessionOutCome: sessionOutcome,
            sessionDate: sessionDate,
            programModuleSessionsId: 0,
            createdBy: preferences!.getInt('userId')!,
            dateCreated: sessionDate,
            modifiedBy: preferences!.getInt('userId')!,
            dateModified: sessionDate);
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    apiResponse = await programEnrollmentSessionOutcomeServiceClient
        .addProgramEnrollmentSessionOutcome(programEnrolmentSessionOutcomeDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const SessionPage(),
            settings: RouteSettings(
              arguments: completedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
    }
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
        title: const Text('SessionPage'),
      ),
      body: ListView(
        children: [
          CaptureProgramEnrolmentSessionOutcomePage(
              addProgramEnrollmentSessionOutcome:
                  addProgramEnrollmentSessionOutcome),
          ViewProgramsEnrolled(programsEnrolledDto: programsEnrolledDto),
        ],
      ),
    );
  }
}
