import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/placement_type_dto.dart';
import '../../../../model/intake/recommendation_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/recommendations_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/recommendations_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';

import '../../../../util/shared/randon_generator.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../development_assessment/development_assessment.dart';
import '../general_details/general_detail.dart';
import 'capture_recommendation.dart';
import 'view_recommendation.dart';

class RecommandationPage extends StatefulWidget {
  const RecommandationPage({Key? key}) : super(key: key);

  @override
  State<RecommandationPage> createState() => _RecommandationPageState();
}

class _RecommandationPageState extends State<RecommandationPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final _lookupTransform = LookupTransform();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _recommendationsServiceClient = RecommendationsService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late RecommendationDto recommendationDto = RecommendationDto();
  late List<RecommendationTypeDto> recommendationTypesDto = [];
  late List<PlacementTypeDto> placementTypesDto = [];
  late List<RecommendationDto> recommendationsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadRecommandationByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    placementTypesDto = await _lookupTransform.transformPlacementTypeDto();
    recommendationTypesDto =
        await _lookupTransform.transformRecommendationTypeDto();
    overlay.hide();
  }

  loadRecommandationByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _recommendationsServiceClient
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

  captureRecommandation(int? recommendationTypeId, int? placementTypeId,
      String? commentsForRecommendation) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    RecommendationDto requestRecommendationDto = RecommendationDto(
        recommendationId: _randomGenerator.getRandomGeneratedNumber(),
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        recommendationTypeId: recommendationTypeId,
        placementTypeId: placementTypeId,
        commentsForRecommendation: commentsForRecommendation,
        createdBy: preferences!.getInt('userId')!,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        recommendationTypeDto: recommendationTypeId != null
            ? recommendationTypesDto
                .where((i) => i.recommendationTypeId == recommendationTypeId)
                .single
            : null,
        placementTypeDto: placementTypeId != null
            ? placementTypesDto
                .where((i) => i.placementTypeId == placementTypeId)
                .single
            : null);

    apiResponse = await _recommendationsServiceClient
        .addRecommendations(requestRecommendationDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Recommandation Successfully Created.');
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

  showSuccessMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text("Recommendation"),
            leading: IconButton(
              icon: const Icon(Icons.offline_pin_rounded),
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Accepted Worklist',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AcceptedWorklistPage()),
                  );
                },
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DevelopmentAssessmentPage(),
                          settings: RouteSettings(
                            arguments: acceptedWorklistDto,
                          ),
                        ),
                      );
                    },
                    heroTag: null,
                    child: const Icon(Icons.arrow_back)),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GeneralDetailPage(),
                          settings: RouteSettings(
                            arguments: acceptedWorklistDto,
                          ),
                        ),
                      );
                    },
                    heroTag: null,
                    child: const Icon(Icons.arrow_forward)),
              ],
            ),
          ),
          drawer: GoToAssessmentDrawer(
              acceptedWorklistDto: acceptedWorklistDto, isCompleted: true),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            children: [
              CaptureRecommendationPage(
                  recommendationTypesDto: recommendationTypesDto,
                  placementTypesDto: placementTypesDto,
                  addNewRecommandation: captureRecommandation),
              ViewRecommendation(recommendationsDto: recommendationsDto),
            ],
          ),
        ));
  }
}
