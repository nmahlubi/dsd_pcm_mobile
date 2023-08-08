import 'package:dsd_pcm_mobile/model/pcm/query/preliminary_detail_query_dto.dart';
import 'package:dsd_pcm_mobile/pages/preliminary_inquery/preliminary.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/placement_type_dto.dart';
import '../../../model/intake/recommendation_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/preliminaryStatus_dto.dart';
import '../../../model/pcm/preliminary_detail_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/intake/look_up_service.dart';
import '../../../service/pcm/diversion_service.dart';
import '../../../service/pcm/preliminary_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';

class CourtDecisionPage extends StatefulWidget {
  const CourtDecisionPage({super.key});

  @override
  State<CourtDecisionPage> createState() => _CourtDecisionPageState();
}

class _CourtDecisionPageState extends State<CourtDecisionPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final _lookupTransform = LookupTransform();

  late PreliminaryDetailQueryDto preliminaryDetailQueryDto =
      PreliminaryDetailQueryDto();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final LookUpService lookUpServiceClient = LookUpService();
  final _preliminaryDetailService = PreliminaryDetailService();
  final DiversionService diversionService = DiversionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<PreliminaryDetailDto> preliminaryDetailsDto = [];

  late List<PreliminaryStatusDto> preliminaryStatusDto = [];
  final List<Map<String, dynamic>> preliminaryStatusItemsDto = [];

  late List<PlacementTypeDto> placementTypeDto = [];
  final List<Map<String, dynamic>> placementTypeItemsDto = [];

  late List<RecommendationTypeDto> recommendationTypeDto = [];
  final List<Map<String, dynamic>> recommendetiontypeItemsDto = [];

  ExpandableController captureCourtDecisionPanelController =
      ExpandableController();

  final TextEditingController preliminaryDateController =
      TextEditingController();

  final TextEditingController outcomeReasonController = TextEditingController();

  int? preliminaryStatusDropdownButtonFormField;
  int? pCMPreliminaryId;
  int? reasonOutcomeId;
  int? recommandationId;
  int? recommendationTypeDropdownButtonFormField;
  int? placementTypeDropdownButtonFormField;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureCourtDecisionPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Court Decision';
    pCMPreliminaryId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          preliminaryDetailQueryDto = ModalRoute.of(context)!.settings.arguments
              as PreliminaryDetailQueryDto;
          loadLookUpTransformer();
          loadPreliminaryDetailsBypreliminaryId(
              preliminaryDetailQueryDto.preliminaryId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    preliminaryStatusDto =
        await _lookupTransform.transformPreliminaryStatusDto();
    placementTypeDto = await _lookupTransform.transformPlacementTypeDto();
    recommendationTypeDto =
        await _lookupTransform.transformRecommendationTypeDto();
    overlay.hide();
  }

  loadPreliminaryDetailsBypreliminaryId(int? preliminaryId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _preliminaryDetailService
        .getPreliminaryByPreliminaryId(preliminaryId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        if (apiResponse.Data != null) {
          PreliminaryDetailDto preliminaryDetailDto =
              (apiResponse.Data as PreliminaryDetailDto);
          labelButtonAddUpdate = 'Update Preliminary Details';
          pCMPreliminaryId = preliminaryDetailQueryDto.preliminaryId!;
          preliminaryStatusDropdownButtonFormField =
              preliminaryDetailDto.pCMPreliminaryStatusId!;
          preliminaryDateController.text =
              preliminaryDetailDto.pCMPreliminaryDate!;
          outcomeReasonController.text = preliminaryDetailDto.pCMOutcomeReason!;
          recommendationTypeDropdownButtonFormField =
              preliminaryDetailDto.pCMRecommendationId!;
          placementTypeDropdownButtonFormField =
              preliminaryDetailDto.placementPreRecommendedId!;
        }
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateCourtDecision() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    PreliminaryDetailDto requestpreliminaryCourtDecisionDto =
        PreliminaryDetailDto(
            pCMPreliminaryId: preliminaryDetailQueryDto.preliminaryId!,
            clientId: preliminaryDetailQueryDto.clientId,
            intakeAssessmentId: preliminaryDetailQueryDto.intakeAssessmentId,
            pCMPreliminaryStatusId: preliminaryStatusDropdownButtonFormField,
            pCMPreliminaryDate: _randomGenerator.getCurrentDateGenerated(),
            pCMOutcomeReason: outcomeReasonController.text,
            pCMRecommendationId: recommendationTypeDropdownButtonFormField,
            placementPreRecommendedId: placementTypeDropdownButtonFormField,
            createdBy: preferences!.getInt('userId')!,
            modifiedBy: preferences!.getInt('userId')!,
            dateModified: _randomGenerator.getCurrentDateGenerated(),
            preliminaryStatusDto: preliminaryStatusDropdownButtonFormField !=
                    null
                ? preliminaryStatusDto
                    .where((i) =>
                        i.preliminaryStatusId ==
                        preliminaryStatusDropdownButtonFormField)
                    .single
                : null,
            recommendationTypeDto:
                recommendationTypeDropdownButtonFormField != null
                    ? recommendationTypeDto
                        .where((i) =>
                            i.recommendationTypeId ==
                            recommendationTypeDropdownButtonFormField)
                        .single
                    : null,
            placementTypeDto: placementTypeDropdownButtonFormField != null
                ? placementTypeDto
                    .where((i) =>
                        i.placementTypeId ==
                        placementTypeDropdownButtonFormField)
                    .single
                : null);

    apiResponse = await _preliminaryDetailService.AddUpdatePreliminaryDetail(
        requestpreliminaryCourtDecisionDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const PreliminaryPage(),
            settings: RouteSettings(
              arguments: preliminaryDetailQueryDto,
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
  void dispose() {
    outcomeReasonController.dispose();
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
              title: const Text("Preliminary Court Decision"),
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
                  tooltip: 'Preliminary Inquiry',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PreliminaryPage()),
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
                            builder: (context) => const PreliminaryPage(),
                            settings: RouteSettings(
                              arguments: preliminaryDetailQueryDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
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
                                        captureCourtDecisionPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Preliminary Court Decision",
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          preliminaryStatusDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Preliminary Status Type',
                                                        labelText:
                                                            'Preliminary Status Type',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: preliminaryStatusDto
                                                          .map(
                                                              (preliminaryStatus) {
                                                        return DropdownMenuItem(
                                                            value: preliminaryStatus
                                                                .preliminaryStatusId,
                                                            child: Text(
                                                                preliminaryStatus
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        preliminaryStatusDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Preliminary Status Type Required';
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
                                                      preliminaryDateController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Preliminary Date*',
                                                  ),
                                                  readOnly:
                                                      true, // when true user cannot edit text
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate: DateTime
                                                                .now(), //get today's date
                                                            firstDate: DateTime(
                                                                2000), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2101));

                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      preliminaryDateController
                                                          .text = formattedDate;
                                                      //You can format date as per your need
                                                    }
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      outcomeReasonController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Reason Outcomes',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Reason Outcome Required';
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
                                                      items: recommendationTypeDto
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
                                                      items: placementTypeDto
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
                                                          addUpdateCourtDecision();
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
                    ],
                  ),
                ))));
  }
}
