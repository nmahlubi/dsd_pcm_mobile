import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/offence_detail_dto.dart';
import '../../../../navigation_drawer/navigation_drawer.dart';
import '../../../../service/pcm/offence_detail_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../victim_details/capture_victim_detail.dart';
import 'view_offence_detail.dart';

class CaptureOffenceDetailPage extends StatefulWidget {
  const CaptureOffenceDetailPage({Key? key}) : super(key: key);

  @override
  State<CaptureOffenceDetailPage> createState() =>
      _CaptureOffenceDetailPageState();
}

class _CaptureOffenceDetailPageState extends State<CaptureOffenceDetailPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final OffenceDetailService offenceDetailServicelient = OffenceDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late List<OffenceDetailDto> offenceDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadOffenceDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadOffenceDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await offenceDetailServicelient
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
        title: const Text('Offence Details'),
      ),
      body: ListView(
        children: [
          ViewOffenceDetailPage(offenceDetailsDto: offenceDetailsDto),
        ],
      ),
    );
  }
}
