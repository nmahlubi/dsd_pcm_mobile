import 'package:dsd_pcm_mobile/model/pcm/program_enrolment_session_outcome_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programs_enrolled_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/query/homebased_diversion_query_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/go_to_home_based_diversion_drawer.dart';
import 'package:dsd_pcm_mobile/service/pcm/program_enrolment_session_outcome_service.dart';
import 'package:dsd_pcm_mobile/transform_dynamic/transform_lookup.dart';
import 'package:dsd_pcm_mobile/util/shared/apierror.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresponse.dart';
import 'package:dsd_pcm_mobile/util/shared/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final _lookupTransform = LookupTransform();
  final ProgramEnrollmentSessionOutcomeService
      programEnrollmentSessionOutcomeService =
      ProgramEnrollmentSessionOutcomeService();
  late ApiResponse apiResponse = ApiResponse();
  late ProgramEnrolmentSessionOutcomeDto programEnrolmentSessionOutcomeDto =
      ProgramEnrolmentSessionOutcomeDto();
  late List<ProgramEnrolmentSessionOutcomeDto> programsEnrolledDto = [];
  late ProgramsEnrolledDto programsEnrolled = ProgramsEnrolledDto();

  late HomebasedDiversionQueryDto homebasedDiversionQueryDto =
      HomebasedDiversionQueryDto();

  final ProgramEnrolmentSessionOutcomeDto programEnrolled =
      ProgramEnrolmentSessionOutcomeDto();
  late List<ProgrammesDto> programmesDto = [];
  late List<ProgrammeModuleDto> programmeModule = [];

  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          programsEnrolled =
              ModalRoute.of(context)!.settings.arguments as ProgramsEnrolledDto;
          loadLookUpTransformer();
          //programEnrolled.enrolmentID
          loadProgrammEnrolledSessionOutcome(1);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    programmesDto = await _lookupTransform.transformProgrammesDto();
    // programmeModule = await _lookupTransform.transformProgrammeModuleDto();
    overlay.hide();
  }

  loadProgrammEnrolledSessionOutcome(int? $sessionId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await programEnrollmentSessionOutcomeService
        .getProgramEnrollmentSessionOutcome($sessionId);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programsEnrolledDto =
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
            title: const Text('Sessions Enrolled'),
          ),
          drawer: GoToHomeBasedDiversionDrawer(
              homebasedDiversionQueryDto: homebasedDiversionQueryDto),
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
                  itemCount: programsEnrolledDto.length,
                  itemBuilder: (context, int index) {
                    if (programsEnrolledDto.isEmpty) {
                      return const Center(
                          child: Text('No Session Enrolled Found.'));
                    }
                    return programsEnrolledDto[index]
                            .sessionOutCome!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(programsEnrolledDto[index]
                                .programModuleId
                                .toString()),
                            subtitle: Text(
                                'Session: ${programsEnrolledDto![index].sessionOutCome}  \n'
                                'Program Module : ${programsEnrolledDto![index].programModuleId}  \n'
                                'Programme Name: ${programsEnrolledDto[index].programModuleSessionsId} \n'
                                'Session date : ${programsEnrolledDto![index].sessionDate}  \n'
                                'Session Id : ${programsEnrolledDto![index].programModuleId}',
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
                                    arguments: programsEnrolledDto,
                                  ),
                                ),
                              );
                            })
                        : Container();
                  },
                  separatorBuilder: (context, index) {
                    return programsEnrolledDto[index]
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
