import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/health_status_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/medical_health_detail_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/medical_health_details_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../care_giver_detail/care_giver_detail.dart';
import '../child_detail/update_child_detail.dart';
import 'capture_medical_health.dart';
import 'view_medical_health.dart';

class HealthDetailPage extends StatefulWidget {
  const HealthDetailPage({Key? key}) : super(key: key);

  @override
  State<HealthDetailPage> createState() => _HealthDetailPageState();
}

class _HealthDetailPageState extends State<HealthDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final MedicalHealthDetailsService medicalHealthDetailsServiceClient =
      MedicalHealthDetailsService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<HealthStatusDto> healthStatusesDto = [];
  late List<MedicalHealthDetailDto> medicalHealthDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadMedicalHealthDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    healthStatusesDto = await _lookupTransform.transformHealthStatusesDto();
    overlay.hide();
  }

  loadMedicalHealthDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await medicalHealthDetailsServiceClient
        .getMedicalHealthDetailsByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        medicalHealthDetailsDto =
            (apiResponse.Data as List<MedicalHealthDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureMedicalHealth(String? injuries, String? medication, String? allergies,
      String? medicalAppointment, int? healthStatusId) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    MedicalHealthDetailDto requestAddmedicalHealthDetailDto =
        MedicalHealthDetailDto(
            healthDetailsId: _randomGenerator.getRandomGeneratedNumber(),
            healthStatusId: healthStatusId,
            healthStatusDto: healthStatusId != null
                ? healthStatusesDto
                    .where((h) => h.healthStatusId == healthStatusId)
                    .single
                : null,
            injuries: injuries,
            medication: medication,
            allergies: allergies,
            dateCreated: _randomGenerator.getCurrentDateGenerated(),
            medicalAppointments: medicalAppointment,
            intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
            createdBy: preferences!.getInt('userId'));

    apiResponse = await medicalHealthDetailsServiceClient
        .addMedicalHealthDetail(requestAddmedicalHealthDetailDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      //apiResults = (apiResponse.Data as ApiResults);
      if (!mounted) return;
      alertDialogMessageWidget(
          context, 'Successfull', 'Medical Health is successfully created.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const HealthDetailPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
    }
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  showAlertDialogMessage(String? headerMessage, String? message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(headerMessage!),
        content: Text(message!),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              //color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
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
            title: const Text("Medical Information"),
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
                          builder: (context) => const UpdateChildDetailPage(),
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
                          builder: (context) => const CareGiverDetailPage(),
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
              CaptureMedicalHealthPage(
                  healthStatusesDto: healthStatusesDto,
                  addNewMedicalHealth: captureMedicalHealth),
              ViewMedicalHealth(
                  medicalHealthDetailsDto: medicalHealthDetailsDto)
            ],
          ),
        ));
  }
}
