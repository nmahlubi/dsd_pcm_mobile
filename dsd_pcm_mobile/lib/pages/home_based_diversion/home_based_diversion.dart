import 'package:dsd_pcm_mobile/model/pcm/home_based_supervision_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/health_status_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/medical_health_detail_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/pcm/medical_health_details_service.dart';
import '../../../transform_dynamic/transform_lookup.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../navigation_drawer/navigation_drawer_menu.dart';
import '../../service/pcm/home_based_supervision_service.dart';
import 'home_based_diversion_detail/home_based_diversion_detail.dart';

class HomeBasedDiversionPage extends StatefulWidget {
  const HomeBasedDiversionPage({Key? key}) : super(key: key);

  @override
  State<HomeBasedDiversionPage> createState() => _HomeBasedDiversionPageState();
}

class _HomeBasedDiversionPageState extends State<HomeBasedDiversionPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _homeBasedSupervisionServiceClient = HomeBasedSupervisionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  /*late MedicalHealthDetailDto captureMedicalHealthDetailDto =
      MedicalHealthDetailDto();
  late List<HealthStatusDto> healthStatusesDto = [];
  
  */
  late List<HomeBasedSupervionDto> homeBasedSupervionDto= [];

  ExpandableController viewMedicalInfoPanelController = ExpandableController();

  @override
  void initState() {
    super.initState();
    viewMedicalInfoPanelController =
        ExpandableController(initialExpanded: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadLookUpTransformer();
          loadHomeBasedSupervisionDetailsByIntakeAssessmentId(
           acceptedWorklistDto.intakeAssessmentId,
           );
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


  loadHomeBasedSupervisionDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _homeBasedSupervisionServiceClient
        .getHomeBasedSupervisionDetailsByAssessmentId(intakeAssessmentId,preferences!.getInt('userId')!);
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
              title: const Text("Diversion & HBS"),
            ),
            drawer: const NavigationDrawerMenu(),
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
                                    controller: viewMedicalInfoPanelController,
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
                                        /*Row(
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
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeBasedDiversionDetailPage()),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Child Details',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
                                          ],
                                        ),*/
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
                                                              'No home Based Supervision List Found.'));
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
                                                          'SupervisorId : ${homeBasedSupervionDto[index].supervisorId}.',
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
