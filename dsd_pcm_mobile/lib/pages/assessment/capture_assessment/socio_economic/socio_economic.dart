import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/socio_economic_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/socio_economic_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../family/family.dart';
import '../offence_details/offence_detail.dart';
import 'capture_socio_economic.dart';
import 'view_socio_economic.dart';

class SocioEconomicPage extends StatefulWidget {
  const SocioEconomicPage({Key? key}) : super(key: key);

  @override
  State<SocioEconomicPage> createState() => _SocioEconomicPageState();
}

class _SocioEconomicPageState extends State<SocioEconomicPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _randomGenerator = RandomGenerator();
  final _socioEconomicServiceClient = SocioEconomicService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<SocioEconomicDto> socioEconomicsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadSocioEconomicsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadSocioEconomicsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _socioEconomicServiceClient
        .getsocioEconomicsByAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        socioEconomicsDto = (apiResponse.Data as List<SocioEconomicDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureSocioEconomic(
      String? familyBackgroundComment,
      String? financeWorkRecord,
      String? housing,
      String? socialCircumsances,
      String? previousIntervention,
      String? interPersonalRelationship,
      String? peerPresure,
      String? substanceAbuse,
      String? religiousInvolve,
      String? childBehavior,
      String? other) async {
    SocioEconomicDto socioEconomicDto = SocioEconomicDto(
        socioEconomyid: _randomGenerator.getRandomGeneratedNumber(),
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        createdBy: preferences!.getInt('userId')!,
        familyBackgroundComment: familyBackgroundComment,
        financeWorkRecord: financeWorkRecord,
        housing: housing,
        socialCircumsances: socialCircumsances,
        previousIntervention: previousIntervention,
        interPersonalRelationship: interPersonalRelationship,
        peerPresure: peerPresure,
        substanceAbuse: substanceAbuse,
        religiousInvolve: religiousInvolve,
        childBehavior: childBehavior,
        other: other);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await _socioEconomicServiceClient.addSocioEconomic(socioEconomicDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          'Successfull', 'Socio economic successfully added.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const SocioEconomicPage(),
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
            title: const Text("Socio Ecomonic"),
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
                          builder: (context) => const FamilyPage(),
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
                          builder: (context) => const OffenceDetailPage(),
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
            children: [
              CaptureSocioEconomicPage(
                  addNewSocioEconomic: captureSocioEconomic),
              ViewSocioEconomicPage(socioEconomicsDto: socioEconomicsDto)
            ],
          ),
        ));
  }
}
