import 'package:dsd_pcm_mobile/model/pcm/hbs_conditions_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/go_to_home_based_diversion_drawer.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/home_based_supervision_dto.dart';
import '../../../model/pcm/query/homebased_diversion_query_dto.dart';
import '../../../service/pcm/home_based_supervision_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../home_based_diversion.dart';

class HomeBasedDiversionDetailPage extends StatefulWidget {
  const HomeBasedDiversionDetailPage({Key? key}) : super(key: key);

  @override
  State<HomeBasedDiversionDetailPage> createState() =>
      _HomeBasedDiversionDetailPageState();
}

class _HomeBasedDiversionDetailPageState
    extends State<HomeBasedDiversionDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late HomebasedDiversionQueryDto homebasedDiversionQueryDto = HomebasedDiversionQueryDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _homeBasedSupervisionServiceClient = HomeBasedSupervisionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  /*late MedicalHealthDetailDto captureMedicalHealthDetailDto =
      MedicalHealthDetailDto();
  late List<HealthStatusDto> healthStatusesDto = [];
  
  */
  late List<HomeBasedSupervionDto> homeBasedSupervionDto = [];
  late List<HBSConditionsDto> hBSConditionsDto = [];

  ExpandableController viewHomeBasedSupervisionPanelController =
      ExpandableController();
  ExpandableController viewHBSConditionPanelController = ExpandableController();
  @override
  void initState() {
    super.initState();
    viewHomeBasedSupervisionPanelController =
        ExpandableController(initialExpanded: true);
    viewHBSConditionPanelController =
        ExpandableController(initialExpanded: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          homebasedDiversionQueryDto =
              ModalRoute.of(context)!.settings.arguments as HomebasedDiversionQueryDto;
          loadLookUpTransformer();
          loadHomeBasedSupervisionDetailsByAssessmentId(
              homebasedDiversionQueryDto.intakeAssessmentId);
          loadHBSConditionsDetailsByAssessmentId(
              homebasedDiversionQueryDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    //healthStatusesDto = await _lookupTransform.transformHealthStatusesDto();
    overlay.hide();
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
              title: const Text("Diversion & HBS - Child Details"),
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
            drawer: GoToHomeBasedDiversionDrawer(homebasedDiversionQueryDto: homebasedDiversionQueryDto),
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
                                                          'Court Type : ${homeBasedSupervionDto[index].courtType}',
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
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
                                                          IconButton(
                                                              onPressed: () {
                                                                /*populateHealthDetailForm(
                                                                    homeBasedSupervionDto[
                                                                        index]);*/
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .play_circle_fill_rounded,
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
                                                          'Condition : ${hBSConditionsDto[index].conditionsDto?.conditions}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                                      subtitle: Text(
                                                          'Date Created: ${hBSConditionsDto[index].dateCreated}. ',
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
                    ],
                  ),
                ))));
  }
}
