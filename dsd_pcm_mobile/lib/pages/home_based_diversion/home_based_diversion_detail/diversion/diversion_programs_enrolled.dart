import 'package:dsd_pcm_mobile/model/pcm/hbs_conditions_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/go_to_home_based_diversion_drawer.dart';
import 'package:dsd_pcm_mobile/pages/home_based_diversion/home_based_diversion_detail/diversion/diversion_capture_session.dart';
import 'package:dsd_pcm_mobile/pages/home_based_diversion/home_based_diversion_detail/diversion/diversion_program_enrolled_session_outcome.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/pcm/programs_enrolled_dto.dart';
import '../../../../model/pcm/query/homebased_diversion_query_dto.dart';
import '../../../../service/pcm/diversion_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../assessment/capture_assessment/program_enrolled/capture_program_enrolment_session_outcome.dart';
import '../../home_based_diversion.dart';

class ProgrammesEnrolledDetailsPage extends StatefulWidget {
  const ProgrammesEnrolledDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProgrammesEnrolledDetailsPage> createState() =>
      _ProgrammesEnrolledDetailsPageState();
}

class _ProgrammesEnrolledDetailsPageState
    extends State<ProgrammesEnrolledDetailsPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late HomebasedDiversionQueryDto homebasedDiversionQueryDto =
      HomebasedDiversionQueryDto();
  final _lookupTransform = LookupTransform();
  final _diversionServiceClient = DiversionService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<ProgramsEnrolledDto> programsEnrolledDto = [];
  late List<ProgrammesDto> programmesDto = [];
  ExpandableController viewProgrammesEnrolledPanelController =
      ExpandableController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          homebasedDiversionQueryDto = ModalRoute.of(context)!
              .settings
              .arguments as HomebasedDiversionQueryDto;
          loadLookUpTransformer();
          //homebasedDiversionQueryDto.intakeAssessmentId
          loadProgrammesEnrolledByAssessmentId(18225);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    programmesDto = await _lookupTransform.transformProgrammesDto();
    overlay.hide();
  }

  loadProgrammesEnrolledByAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _diversionServiceClient
        .getProgramesEnrolledByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programsEnrolledDto = (apiResponse.Data as List<ProgramsEnrolledDto>);
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
              title: const Text("Programmes Enrolled Details"),
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
                                        viewProgrammesEnrolledPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "List Programmes Enrolled",
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
                                        if (programsEnrolledDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: programsEnrolledDto
                                                      .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (programsEnrolledDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No Programmes Enrolled Found.'));
                                                    }
                                                    return ListTile(
                                                        title: Text(
                                                            'Programme Name: ${programsEnrolledDto[index].programmesDto?.programmeName}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        subtitle: Text(
                                                            'Facilitator : ${programsEnrolledDto[index].facilitator}. '
                                                            'Programme Start Date : ${programsEnrolledDto[index].startDate}. '
                                                            'Programme End Date: ${programsEnrolledDto[index].endDate}.',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                        trailing: const Icon(
                                                            Icons
                                                                .play_circle_fill_rounded,
                                                            color:
                                                                Colors.green),
                                                        onTap: () {
                                                          /*Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ProgramEnrolledSessionOutcomePage(),
                                                         Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ProgramEnrolledSessionOutcomePage(),
                                                              settings:
                                                                  RouteSettings(
                                                                arguments:
                                                                    programsEnrolledDto[
                                                                        index],
                                                              ),
                                                            ),
                                                          );*/
                                                        });
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
