import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../background_job/background_job_offline.dart';
import '../../../background_job/background_job_offline_lookup.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../widgets/alert_dialog_messege_widget.dart';

class WorklistSyncOfflineManualPage extends StatefulWidget {
  const WorklistSyncOfflineManualPage({Key? key}) : super(key: key);

  @override
  State<WorklistSyncOfflineManualPage> createState() =>
      _WorklistSyncOfflineManualPagePageState();
}

class _WorklistSyncOfflineManualPagePageState
    extends State<WorklistSyncOfflineManualPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _backgroundJobOffline = BackgroundJobOffline();
  final _backgroundJobOfflineLookUp = BackgroundJobOfflineLookUp();
  final _worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AcceptedWorklistDto> acceptedWorklistDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadAllocatedCasesByProbationOfficer();
        });
      });
    });
  }

  loadAllocatedCasesByProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _worklistServiceClient
        .getAcceptedWorklistByProbationOfficer(preferences!.getInt('userId')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        acceptedWorklistDto = (apiResponse.Data as List<AcceptedWorklistDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError).toString());
      overlay.hide();
    }
  }

  syncAcceptedWorklist(AcceptedWorklistDto acceptedWorklist) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    try {
      await _backgroundJobOffline.syncAcceptedWorklist(
          acceptedWorklist, preferences!.getInt('userId')!);
      overlay.hide();
      if (!mounted) return;
      alertDialogMessageWidget(context, "Successfull",
          "Synced Completed for child ${acceptedWorklist.childName}.");
    } on SocketException {
      overlay.hide();
      showDialogMessage('Unable to sync offline data.');
    }
  }

  showDialogMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(0),
                child: Form(
                    child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Assessment - Start Sync',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                            fontSize: 21),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: acceptedWorklistDto.length,
                            itemBuilder: (context, int index) {
                              if (acceptedWorklistDto.isEmpty) {
                                return const Center(
                                    child: Text('No worklist Found.'));
                              }
                              return ListTile(
                                  title: Text(acceptedWorklistDto[index]
                                      .childName
                                      .toString()),
                                  subtitle: Text(
                                      acceptedWorklistDto[index]
                                          .dateAccepted
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  trailing: const Icon(Icons.sync,
                                      color: Colors.green),
                                  onTap: () {
                                    syncAcceptedWorklist(
                                        acceptedWorklistDto[index]);
                                  });
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(thickness: 1);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )))));
  }
}
