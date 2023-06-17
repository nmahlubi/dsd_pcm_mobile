import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/offence_category_dto.dart';
import '../../../../model/intake/offence_schedule_dto.dart';
import '../../../../model/intake/offence_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/offence_detail_dto.dart';
import '../../../../model/static_model/yes_no_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/intake/offence_service.dart';
import '../../../../service/pcm/offence_detail_service.dart';
import '../../../../transform_dynamic/transform_offence.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../socio_economic/socio_economic.dart';
import '../victim_details/victim_detail.dart';
import 'capture_offence_detail.dart';
import 'view_offence_detail.dart';

class OffenceDetailPage extends StatefulWidget {
  const OffenceDetailPage({Key? key}) : super(key: key);

  @override
  State<OffenceDetailPage> createState() => _OffenceDetailPageState();
}

class _OffenceDetailPageState extends State<OffenceDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final _offenceTransform = OffenceTransform();
  final OffenceService offenceServiceClient = OffenceService();
  final OffenceDetailService offenceDetailServiceClient =
      OffenceDetailService();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  late List<OffenceTypeDto> offenceTypesDto = [];
  late List<OffenceCategoryDto> offenceCategoriesDto = [];
  late List<OffenceScheduleDto> offenceSchedulesDto = [];
  late List<YesNoDto> yesNoDtoItemsDto = [];
  late List<OffenceDetailDto> offenceDetailsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadOffenceTransformer();
          loadOffenceDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadOffenceTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    offenceTypesDto = await _offenceTransform.transformOffenceTypeDto();
    offenceCategoriesDto =
        await _offenceTransform.transformOffenceCategoryDto();
    offenceSchedulesDto = await _offenceTransform.transformOffenceScheduleDto();
    yesNoDtoItemsDto.add(YesNoDto(value: 'Yes', description: 'Yes'));
    yesNoDtoItemsDto.add(YesNoDto(value: 'No', description: 'No'));
    overlay.hide();
  }

  loadOffenceDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceDetailServiceClient
        .getOffenceDetailIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        offenceDetailsDto = (apiResponse.Data as List<OffenceDetailDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureOffenceDetails(
      int? offenceTypeId,
      int? offenceCategoryId,
      int? offenceScheduleId,
      String? offenceCircumstance,
      String? valueOfGoods,
      String? valueRecovered,
      String isChildResponsible,
      String? responsibilityDetails) async {
    OffenceDetailDto addOffenceDetailDto = OffenceDetailDto(
        pcmOffenceId: _randomGenerator.getRandomGeneratedNumber(),
        pcmCaseId: acceptedWorklistDto.caseId,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        offenceTypeId: offenceTypeId,
        offenceTypeDto: offenceTypeId != null
            ? offenceTypesDto
                .where((o) => o.offenceTypeId == offenceTypeId)
                .single
            : null,
        offenceCategoryId: offenceCategoryId,
        offenceCategoryDto: offenceCategoryId != null
            ? offenceCategoriesDto
                .where((o) => o.offenceCategoryId == offenceCategoryId)
                .single
            : null,
        offenceScheduleId: offenceScheduleId,
        offenceScheduleDto: offenceScheduleId != null
            ? offenceSchedulesDto
                .where((o) => o.offenceScheduleId == offenceScheduleId)
                .single
            : null,
        offenceCircumstance: offenceCircumstance,
        valueOfGoods: valueOfGoods,
        valueRecovered: valueRecovered,
        isChildResponsible: isChildResponsible,
        responsibilityDetails: responsibilityDetails);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await offenceDetailServiceClient.addOffenceDetail(addOffenceDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", 'Offence successfully created.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const OffenceDetailPage(),
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
            title: const Text("Offence Details"),
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
                          builder: (context) => const SocioEconomicPage(),
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
                          builder: (context) => const VictimDetailPage(),
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
              CaptureOffenceDetailPage(
                  yesNoDtoItemsDto: yesNoDtoItemsDto,
                  offenceTypesDto: offenceTypesDto,
                  offenceCategoriesDto: offenceCategoriesDto,
                  offenceSchedulesDto: offenceSchedulesDto,
                  addNewOffenceDetail: captureOffenceDetails),
              ViewOffenceDetailPage(offenceDetailsDto: offenceDetailsDto)
            ],
          ),
        ));
  }
}
