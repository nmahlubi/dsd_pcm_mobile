import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:dsd_pcm_mobile/service/pcm/programme_module_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'view_programme_module.dart';

class DiversionModulePage extends StatefulWidget {
  const DiversionModulePage({Key? key}) : super(key: key);

  @override
  State<DiversionModulePage> createState() => _DiversionModulePageState();
}

class _DiversionModulePageState extends State<DiversionModulePage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final ProgramModuleService programmeModuleServiceClient =
      ProgramModuleService();
  late List<ProgrammeModuleDto> programmeModulesDto = [];
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadProgrammeModuleByModuleId(1);
        });
      });
    });
  }

  loadProgrammeModuleByModuleId(int? moduleId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse =
        await programmeModuleServiceClient.getProgrammeModuleById(moduleId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programmeModulesDto = (apiResponse.Data as List<ProgrammeModuleDto>);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
      ),
      body: ListView(
        children: [
          ViewProgrammeModulePage(programmeModulesDto: programmeModulesDto),
        ],
      ),
    );
  }
}
