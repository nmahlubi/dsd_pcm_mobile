import 'package:dsd_pcm_mobile/model/intake/program_module_sessions_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/program_enrolment_session_outcome_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/program_module_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programs_enrolled_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/query/homebased_diversion_query_dto.dart';
import 'package:dsd_pcm_mobile/service/pcm/program_enrolment_session_outcome_service.dart';
import 'package:dsd_pcm_mobile/transform_dynamic/transform_lookup.dart';
import 'package:dsd_pcm_mobile/util/shared/apierror.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresponse.dart';
import 'package:dsd_pcm_mobile/util/shared/loading_overlay.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../navigation_drawer/go_to_home_based_diversion_drawer.dart';
import '../../../../util/shared/apiresults.dart';
import '../../home_based_diversion.dart';
import 'diversion_capture_session.dart';

class ProgramEnrolledSessionOutcomePage extends StatefulWidget {
  const ProgramEnrolledSessionOutcomePage({Key? key}) : super(key: key);

  @override
  State<ProgramEnrolledSessionOutcomePage> createState() =>
      _ProgramEnrolledSessionOutcomePageState();
}

class _ProgramEnrolledSessionOutcomePageState
    extends State<ProgramEnrolledSessionOutcomePage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late ProgramsEnrolledDto programsEnrolledDto = ProgramsEnrolledDto();
  late HomebasedDiversionQueryDto homebasedDiversionQueryDto =
      HomebasedDiversionQueryDto();
  final _lookupTransform = LookupTransform();
  final _programEnrollmentSessionOutcome =
      ProgramEnrollmentSessionOutcomeService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<ProgramEnrolmentSessionOutcomeDto>
      programEnrolmentSessionOutcomeDto = [];
  late List<ProgramModuleDto> programModuleDto = [];
  late List<ProgramModuleSessionDto> programModuleSessionDto = [];
  ExpandableController viewProgrammesEnrolledPanelController =
      ExpandableController();

  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          programsEnrolledDto =
              ModalRoute.of(context)!.settings.arguments as ProgramsEnrolledDto;
          loadLookUpTransformer();
          loadProgrammEnrolledSessionOutcome(programsEnrolledDto.enrolmentID);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    programModuleDto = await _lookupTransform.transformProgramModuleDto();
    programModuleSessionDto =
        await _lookupTransform.transformProgrammeModuleSessionDto();
    overlay.hide();
  }

  loadProgrammEnrolledSessionOutcome(int? $enrollmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await _programEnrollmentSessionOutcome
        .getProgramEnrollmentSessionOutcome($enrollmentId);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programEnrolmentSessionOutcomeDto =
            (apiResponse.Data as List<ProgramEnrolmentSessionOutcomeDto>);
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
          appBar: AppBar(
            title: const Text('Module Program Sessions'),
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
                          builder: (context) => const HomeBasedDiversionPage(),
                        ),
                      );
                    },
                    heroTag: null,
                    child: const Icon(Icons.arrow_back)),
              ],
            ),
          ),

          //drawer: GoToHomeBasedDiversionDrawer(homebasedDiversionQueryDto: homebasedDiversionQueryDto),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: programEnrolmentSessionOutcomeDto.length,
                  itemBuilder: (context, int index) {
                    if (programEnrolmentSessionOutcomeDto.isEmpty) {
                      return const Center(
                          child: Text('No Session Enrolled Found.'));
                    }
                    return programEnrolmentSessionOutcomeDto[index]
                            .sessionOutCome!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(
                                'Session Outcome: ${programEnrolmentSessionOutcomeDto[index].sessionOutCome}'),
                            subtitle: Text(
                                'Session Name : ${programEnrolmentSessionOutcomeDto[index].programModuleSessionDto?.sessionName}  \n'
                                'Module Name: ${programEnrolmentSessionOutcomeDto[index].programModuleDto?.moduleName} \n'
                                'Session date : ${programEnrolmentSessionOutcomeDto[index].sessionDate}',
                                style: const TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.play_circle_fill_rounded,
                                color: Colors.green),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DiversionProgrammeSession(),
                                  settings: RouteSettings(
                                    arguments:
                                        programEnrolmentSessionOutcomeDto[
                                            index],
                                  ),
                                ),
                              );
                            })
                        : Container();
                  },
                  separatorBuilder: (context, index) {
                    return programEnrolmentSessionOutcomeDto[index]
                            .sessionOutCome!
                            .toLowerCase()
                            .contains(searchString)
                        ? const Divider(thickness: 1)
                        : Container();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
