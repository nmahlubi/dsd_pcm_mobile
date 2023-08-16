import 'package:dsd_pcm_mobile/model/pcm/program_enrolment_session_outcome_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:dsd_pcm_mobile/navigation_drawer/navigation_drawer_menu.dart';
import 'package:dsd_pcm_mobile/service/pcm/program_enrolment_session_outcome_service.dart';
import 'package:dsd_pcm_mobile/service/pcm/programme_module_service.dart';
import 'package:dsd_pcm_mobile/transform_dynamic/transform_lookup.dart';
import 'package:dsd_pcm_mobile/util/shared/apierror.dart';
import 'package:dsd_pcm_mobile/util/shared/apiresponse.dart';
import 'package:dsd_pcm_mobile/util/shared/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final ProgramEnrollmentSessionOutcomeService
      programEnrollmentSessionOutcomeService =
      ProgramEnrollmentSessionOutcomeService();
  final ProgramModuleService programModuleService = ProgramModuleService();
  late ApiResponse apiResponse = ApiResponse();
  final _lookupTransform = LookupTransform();
  late List<ProgramEnrolmentSessionOutcomeDto>
      programEnrolmentSessionOutcomeDto = [];
  late List<ProgrammeModuleDto> programmeModuleDto = [];

  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadCompletedTaskAllocatedToProbationOfficer();
          loadLookUpTransformer();
        });
      });
    });
  }

  loadCompletedTaskAllocatedToProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await programEnrollmentSessionOutcomeService
        .getProgramEnrollmentSessionOutcome(preferences!.getInt('userId')!);

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

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    overlay.hide();
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
          drawer: const NavigationDrawerMenu(),
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
                            title: Text(programEnrolmentSessionOutcomeDto[index]
                                .programModuleId
                                .toString()),
                            subtitle: Text(
                                'Module Name : ${programEnrolmentSessionOutcomeDto[index].programModuleId}.  \n'
                                'Session: ${programEnrolmentSessionOutcomeDto[index].sessionId}  \n'
                                'Session date : ${programEnrolmentSessionOutcomeDto[index].sessionDate}  \n'
                                'Session outcomes : ${programEnrolmentSessionOutcomeDto[index].sessionOutCome}',
                                style: const TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.play_circle_fill_rounded,
                                color: Colors.green),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProgramEnrolledSessionOutcomePage(), //////////////////////////////////////will be update
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
