import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/placement_type_dto.dart';
import '../../../../model/intake/recommendation_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/recommendations_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/pcm/recommendations_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';

import '../../../../widgets/alert_dialog_messege_widget.dart';
import 'capture_recommendation.dart';
import 'view_recommendation.dart';

class RecommandationPage extends StatefulWidget {
  const RecommandationPage({Key? key}) : super(key: key);

  @override
  State<RecommandationPage> createState() => _RecommandationPageState();
}

class _RecommandationPageState extends State<RecommandationPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final RecommendationsService recommendationsServiceClient =
      RecommendationsService();
  final LookUpService lookUpServiceClient = LookUpService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late RecommendationDto recommendationDto = RecommendationDto();
  late List<RecommendationTypeDto> recommendationTypesDto = [];
  final List<Map<String, dynamic>> recommendationTypeItemsDto = [];
  late List<PlacementTypeDto> placementTypesDto = [];
  final List<Map<String, dynamic>> placementTypeItemsDto = [];
  late List<RecommendationDto> recommendationsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadRecommandationTypes();
          loadPlacementTypes();
          loadRecommandationByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadRecommandationTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getRecommendationTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        recommendationTypesDto =
            (apiResponse.Data as List<RecommendationTypeDto>);
        for (var recommendationType in recommendationTypesDto) {
          Map<String, dynamic> recommendationTypeItem = {
            "recommendationTypeId": recommendationType.recommendationTypeId,
            "description": '${recommendationType.description}'
          };
          recommendationTypeItemsDto.add(recommendationTypeItem);
        }
      });
    }
    overlay.hide();
  }

  loadPlacementTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getPlacementTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        placementTypesDto = (apiResponse.Data as List<PlacementTypeDto>);
        for (var placementType in placementTypesDto) {
          Map<String, dynamic> placementTypeItem = {
            "placementTypeId": placementType.placementTypeId,
            "description": '${placementType.description}'
          };
          placementTypeItemsDto.add(placementTypeItem);
        }
      });
    }
    overlay.hide();
  }

  loadRecommandationByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await recommendationsServiceClient
        .getRecommendationsByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        recommendationsDto = (apiResponse.Data as List<RecommendationDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureRecommandation(
      RecommendationTypeDto recommendationTypeDto,
      PlacementTypeDto placementTypeDto,
      String? commentsForRecommendation) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    RecommendationDto requestRecommendationDto = RecommendationDto(
        recommendationId: 0,
        recommendationTypeId: recommendationTypeDto.recommendationTypeId,
        placementTypeId: placementTypeDto.placementTypeId,
        commentsForRecommendation: commentsForRecommendation,
        createdBy: preferences!.getInt('userId')!,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        recommendationTypeDto: recommendationTypeDto,
        placementTypeDto: placementTypeDto);

    apiResponse = await recommendationsServiceClient
        .addRecommendations(requestRecommendationDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      alertDialogMessageWidget(
          context, "Successfull", (apiResponse.Data as ApiResults).message!);
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const RecommandationPage(),
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Recommendation'),
          ),
          body: ListView(
            children: [
              CaptureRecommendationPage(
                  recommendationTypeItemsDto: recommendationTypeItemsDto,
                  placementTypeItemsDto: placementTypeItemsDto,
                  addNewRecommandation: captureRecommandation),
              ViewRecommendation(recommendationsDto: recommendationsDto),
            ],
          ),
        ));
  }
}
