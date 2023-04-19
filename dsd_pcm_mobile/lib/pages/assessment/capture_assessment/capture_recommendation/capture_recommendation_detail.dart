import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/recommendations_dto.dart';
import '../../../../service/pcm/recommendation_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'view_recommendation_details.dart';

class CaptureRecommendationDetail extends StatefulWidget {
  const CaptureRecommendationDetail({super.key});

  @override
  State<CaptureRecommendationDetail> createState() =>
      _CaptureRecommendationDetailPageState();
}

class _CaptureRecommendationDetailPageState
    extends State<CaptureRecommendationDetail> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final RecommendationService victimServiceClient = RecommendationService();
  late ApiResponse apiResponse = ApiResponse();
  late List<RecommendationDto> recommendationDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;

          loadRecommendationsByIntakeAssessmentId(14565);
        });
      });
    });
  }

  loadRecommendationsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await victimServiceClient
        .getRecommendationByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        recommendationDto = (apiResponse.Data as List<RecommendationDto>);
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
        title: const Text('Recommendations'),
      ),
      body: ListView(
        children: [
          ViewRecommendationDetails(recommendationDto: recommendationDto),
        ],
      ),
    );
  }
}
