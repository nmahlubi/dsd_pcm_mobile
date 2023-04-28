import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/socio_economic_dto.dart';
import '../../../../service/pcm/socio_economic_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'view_socio_economic.dart';

class SocioEconomicPage extends StatefulWidget {
  const SocioEconomicPage({Key? key}) : super(key: key);

  @override
  State<SocioEconomicPage> createState() => _SocioEconomicPageState();
}

class _SocioEconomicPageState extends State<SocioEconomicPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final SocioEconomicService socioEconomicServiceClient =
      SocioEconomicService();
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
    apiResponse = await socioEconomicServiceClient
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

  captureSocioEconomics(String? consultedSources, String? traceEfforts,
      String? commentsBySupervisor, String? additionalInfo) async {
    SocioEconomicDto socioEconomicDto = SocioEconomicDto(
        /*generalDetailsId: 0,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        consultedSources: consultedSources,
        traceEfforts: traceEfforts,
        commentsBySupervisor: commentsBySupervisor,
        additionalInfo: additionalInfo
        
        */
        );

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse =
        await socioEconomicServiceClient.addSocioEconomic(socioEconomicDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      await showAlertDialogMessage(
          "Successfull", (apiResponse.Data as ApiResults).message!);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Details'),
      ),
      body: ListView(
        children: [
          //CaptureSocioEconomicPage(addNewGeneralDetail: captureGeneralDetail),
          ViewSocioEconomicPage(socioEconomicsDto: socioEconomicsDto)
        ],
      ),
    );
  }
}
