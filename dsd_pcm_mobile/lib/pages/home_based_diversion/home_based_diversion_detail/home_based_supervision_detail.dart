import 'package:dsd_pcm_mobile/model/pcm/hbs_conditions_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/go_to_home_based_diversion_drawer.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/intake/compliance_dto.dart';
import '../../../model/pcm/home_based_supervision_dto.dart';
import '../../../model/pcm/query/homebased_diversion_query_dto.dart';
import '../../../model/pcm/visitation_outcome_dto.dart';
import '../../../service/pcm/home_based_supervision_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../home_based_diversion.dart';

class HomeBasedSupervisionDetailPage extends StatefulWidget {
  const HomeBasedSupervisionDetailPage({Key? key}) : super(key: key);

  @override
  State<HomeBasedSupervisionDetailPage> createState() =>
      _HomeBasedSupervisionDetailPageState();
}

class _HomeBasedSupervisionDetailPageState
    extends State<HomeBasedSupervisionDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late HomebasedDiversionQueryDto homebasedDiversionQueryDto =
      HomebasedDiversionQueryDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _homeBasedSupervisionServiceClient = HomeBasedSupervisionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<HomeBasedSupervionDto> homeBasedSupervionDto = [];
  late List<HBSConditionsDto> hBSConditionsDto = [];
  ExpandableController viewHomeBasedSupervisionPanelController =
      ExpandableController();
  ExpandableController viewHBSConditionPanelController = ExpandableController();

  late VisitationOutcomeDto captureVisitationOutcomeDto =
      VisitationOutcomeDto();
  late List<ComplianceDto> complianceDto = [];
  late List<VisitationOutcomeDto> visitationOutcomeDto = [];

  ExpandableController captureVisitationOutcomePanelController =
      ExpandableController();
  ExpandableController viewVisitationOutcomePanelController =
      ExpandableController();
  final TextEditingController processNotesController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dateCapturedController = TextEditingController();
  int? visitationId;
  int? complianceStatusDropdownButtonFormField;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    viewHomeBasedSupervisionPanelController =
        ExpandableController(initialExpanded: true);
    viewHBSConditionPanelController =
        ExpandableController(initialExpanded: true);
    captureVisitationOutcomePanelController =
        ExpandableController(initialExpanded: false);
    viewVisitationOutcomePanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Visitation Outcome';
    visitationId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          homebasedDiversionQueryDto = ModalRoute.of(context)!
              .settings
              .arguments as HomebasedDiversionQueryDto;
          loadLookUpTransformer();
          loadHomeBasedSupervisionDetailsByAssessmentId(
              homebasedDiversionQueryDto.intakeAssessmentId);
          loadHBSConditionsDetailsByAssessmentId(
              homebasedDiversionQueryDto.intakeAssessmentId);
          loadVisitationOutcomeByIntakeAssessmentId(
              homebasedDiversionQueryDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    complianceDto = await _lookupTransform.transformComplianceDto();
    overlay.hide();
  }

  loadVisitationOutcomeByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _homeBasedSupervisionServiceClient
        .getVisitationOutcomeByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        visitationOutcomeDto = (apiResponse.Data as List<VisitationOutcomeDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadHomeBasedSupervisionDetailsByAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _homeBasedSupervisionServiceClient
        .getHomeBasedSupervisionDetailsByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        homeBasedSupervionDto =
            (apiResponse.Data as List<HomeBasedSupervionDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadHBSConditionsDetailsByAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _homeBasedSupervisionServiceClient
        .getHomeBasedSupervisionConditionsByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        hBSConditionsDto = (apiResponse.Data as List<HBSConditionsDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateVisitationOutcome() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    VisitationOutcomeDto requestAddVisitationOutcomeDto = VisitationOutcomeDto(
        hBVisitaionOutcomeId:
            visitationId ?? _randomGenerator.getRandomGeneratedNumber(),
        homeBasedSupervisionId:
            homebasedDiversionQueryDto.homeBasedSupervisionId,
        intakeAssessmentId: homebasedDiversionQueryDto.intakeAssessmentId,
        conatactNumber: contactController.text,
        processNotes: processNotesController.text,
        createdBy: preferences!.getInt('userId')!,
        modifiedBy: preferences!.getInt('userId')!,
        dateModified: _randomGenerator.getCurrentDateGenerated(),
        complianceId: complianceStatusDropdownButtonFormField,
        complianceDto: complianceStatusDropdownButtonFormField != null
            ? complianceDto
                .where((h) =>
                    h.complianceId == complianceStatusDropdownButtonFormField)
                .single
            : null,
        dateCreated: dateCapturedController.text == ""
            ? null
            : dateCapturedController.text);

    apiResponse = await _homeBasedSupervisionServiceClient
        .addUpdateVisitationOutcome(requestAddVisitationOutcomeDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const HomeBasedSupervisionDetailPage(),
            settings: RouteSettings(
              arguments: homebasedDiversionQueryDto,
            )),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  newVisitationOutcome() {
    setState(() {
      labelButtonAddUpdate = 'Add Visitation Outcome';
      processNotesController.clear();
      contactController.clear();
      dateCapturedController.clear();
      complianceStatusDropdownButtonFormField = null;
      visitationId = null;
    });
  }

  populateVisitationOuctomeForm(VisitationOutcomeDto visitationOutcomeDto) {
    setState(() {
      visitationId = visitationOutcomeDto.hBVisitaionOutcomeId;
      captureVisitationOutcomePanelController =
          ExpandableController(initialExpanded: true);
      viewVisitationOutcomePanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Updated Visitation Outcome';
      processNotesController.text = visitationOutcomeDto.processNotes!;
      contactController.text = visitationOutcomeDto.conatactNumber!;
      dateCapturedController.text = visitationOutcomeDto.dateCreated!;
      complianceStatusDropdownButtonFormField =
          visitationOutcomeDto.complianceId;
    });
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
    processNotesController.dispose();
    contactController.dispose();
    dateCapturedController.dispose();
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
              title: const Text("Homebased Supervision Details"),
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
                  tooltip: 'Home Based Diversion',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeBasedDiversionPage()),
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
                                const HomeBasedDiversionPage(),
                            settings: RouteSettings(
                              arguments: homebasedDiversionQueryDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                ],
              ),
            ),
            drawer: GoToHomeBasedDiversionDrawer(
                homebasedDiversionQueryDto: homebasedDiversionQueryDto),
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
                                        captureVisitationOutcomePanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Visitation Outcome",
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
                                                        newVisitationOutcome();
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
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller: contactController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 2,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Contact Number',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Contact Number Required';
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
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      processNotesController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Process Notes',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Process Notes Required';
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
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      dateCapturedController,
                                                  enableInteractiveSelection:
                                                      false,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Date captured',
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
                                                                1800), //DateTime.now() - not to allow to choose before today.
                                                            lastDate:
                                                                DateTime(2101));

                                                    if (pickedDate != null) {
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                      dateCapturedController
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
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        complianceStatusDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Compliance',
                                                      labelText: 'Compliance',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: complianceDto
                                                        .map((compliance) {
                                                      return DropdownMenuItem(
                                                          value: compliance
                                                              .complianceId,
                                                          child: Text(compliance
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      complianceStatusDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Compliance required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
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
                                                          addUpdateVisitationOutcome();
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
                                        viewVisitationOutcomePanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "List Visitation Outcome",
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
                                        if (visitationOutcomeDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      visitationOutcomeDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (visitationOutcomeDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No Visitation Outcome Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Process Notes : ${visitationOutcomeDto[index].processNotes}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Contact Number : ${visitationOutcomeDto[index].conatactNumber}. '
                                                          'Date Visited : ${visitationOutcomeDto[index].dateCreated}. '
                                                          'Compliance: ${visitationOutcomeDto[index].complianceDto?.description}.',
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
                                                                populateVisitationOuctomeForm(
                                                                    visitationOutcomeDto[
                                                                        index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue)),
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
                                        viewHomeBasedSupervisionPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "List Home Based Supervision",
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
                                        if (homeBasedSupervionDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      homeBasedSupervionDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (homeBasedSupervionDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No home based supervision Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Court Type : ${homeBasedSupervionDto[index].courtTypeDto?.description}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Placement Date : ${homeBasedSupervionDto[index].placementDate}. '
                                                          'Number of Visits : ${homeBasedSupervionDto[index].numberOfVisits}. ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
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
                                    controller: viewHBSConditionPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "List HBS Conditions",
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
                                        if (homeBasedSupervionDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      hBSConditionsDto.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (hBSConditionsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No hbs conditions Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Condition : ${hBSConditionsDto[index].conditionsDto?.description}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
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
