import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/placement_type_dto.dart';
import '../../../model/intake/recommendation_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/recommendations_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/recommendations_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';

import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'development_assessment.dart';
import 'general_detail.dart';

class RecommandationPage extends StatefulWidget {
  const RecommandationPage({Key? key}) : super(key: key);

  @override
  State<RecommandationPage> createState() => _RecommandationPageState();
}

class _RecommandationPageState extends State<RecommandationPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

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

  ExpandableController captureRecommandationPanelController =
      ExpandableController();
  ExpandableController viewRecommandationPanelController =
      ExpandableController();

  final TextEditingController commentsForRecommendationController =
      TextEditingController();
  int? recommendationTypeDropdownButtonFormField;
  int? placementTypeDropdownButtonFormField;
  int? recommandationId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureRecommandationPanelController =
        ExpandableController(initialExpanded: false);
    viewRecommandationPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Medical';
    recommandationId = null;
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
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateRecommandation() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    RecommendationDto requestRecommendationDto = RecommendationDto(
        recommendationId:
            recommandationId ?? _randomGenerator.getRandomGeneratedNumber(),
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        recommendationTypeId: recommendationTypeDropdownButtonFormField,
        placementTypeId: placementTypeDropdownButtonFormField,
        commentsForRecommendation: commentsForRecommendationController.text,
        createdBy: preferences!.getInt('userId')!,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        recommendationTypeDto: recommendationTypeDropdownButtonFormField != null
            ? recommendationTypesDto
                .where((i) =>
                    i.recommendationTypeId ==
                    recommendationTypeDropdownButtonFormField)
                .single
            : null,
        placementTypeDto: placementTypeDropdownButtonFormField != null
            ? placementTypesDto
                .where((i) =>
                    i.placementTypeId == placementTypeDropdownButtonFormField)
                .single
            : null);

    apiResponse = await _recommendationsServiceClient
        .addUpdateRecommendation(requestRecommendationDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
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

  newMRecommandation() {
    setState(() {
      labelButtonAddUpdate = 'Add Recommandation';
      commentsForRecommendationController.clear();
      placementTypeDropdownButtonFormField = null;
      recommendationTypeDropdownButtonFormField = null;
      recommandationId = null;
    });
  }

  populateRecommandationForm(RecommendationDto recommendationDto) {
    setState(() {
      recommandationId = recommendationDto.recommendationId;
      captureRecommandationPanelController =
          ExpandableController(initialExpanded: true);
      viewRecommandationPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Recommandation';
      commentsForRecommendationController.text =
          recommendationDto.commentsForRecommendation!;
      recommendationTypeDropdownButtonFormField =
          recommendationDto.recommendationTypeId;
      placementTypeDropdownButtonFormField = recommendationDto.placementTypeId;
    });
  }

  @override
  void dispose() {
    commentsForRecommendationController.dispose();
    super.dispose();
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
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
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
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        captureRecommandationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Recommandation",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize: const Size
                                                            .fromHeight(10),
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                244,
                                                                248,
                                                                246),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        newMRecommandation();
                                                      },
                                                      child: const Text('New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          recommendationTypeDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Recommandation Type',
                                                        labelText:
                                                            'Recommandation Type',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: recommendationTypesDto
                                                          .map(
                                                              (recommandationType) {
                                                        return DropdownMenuItem(
                                                            value: recommandationType
                                                                .recommendationTypeId,
                                                            child: Text(
                                                                recommandationType
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        recommendationTypeDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Recommandation Type Required';
                                                        }
                                                        return null;
                                                      },
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          placementTypeDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Placement Type',
                                                        labelText:
                                                            'Placement Type',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: placementTypesDto
                                                          .map((placementType) {
                                                        return DropdownMenuItem(
                                                            value: placementType
                                                                .placementTypeId,
                                                            child: Text(
                                                                placementType
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        placementTypeDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Placement Type Required';
                                                        }
                                                        return null;
                                                      },
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      commentsForRecommendationController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Comments',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Comments Required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 10, 2),
                                            )),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                23,
                                                                22,
                                                                22),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        if (_loginFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          addUpdateRecommandation();
                                                        }
                                                      },
                                                      child: Text(
                                                          labelButtonAddUpdate!),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                      ]),
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        viewRecommandationPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Recommandations",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (recommendationsDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      recommendationsDto.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (recommendationsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No recommandation Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Type : ${recommendationsDto[index].recommendationTypeDto?.description ?? ''}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Placement Type ${recommendationsDto[index].placementTypeDto?.description ?? ''}'
                                                          'Comments  :  ${recommendationsDto[index].commentsForRecommendation ?? ''}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                                                          IconButton(
                                                              onPressed: () {
                                                                populateRecommandationForm(
                                                                    recommendationsDto[
                                                                        index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue)),
                                                          /*IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red)),*/
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                        thickness: 1);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
                      ]),
                    ],
                  ),
                ))));
  }
}
