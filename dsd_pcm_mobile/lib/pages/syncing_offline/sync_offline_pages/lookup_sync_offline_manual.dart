import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../background_job/background_job_offline.dart';
import '../../../background_job/background_job_offline_lookup.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../widgets/alert_dialog_messege_widget.dart';

class LookupSyncOfflineManualPage extends StatefulWidget {
  const LookupSyncOfflineManualPage({Key? key}) : super(key: key);

  @override
  State<LookupSyncOfflineManualPage> createState() =>
      _LookupSyncOfflineManualPageState();
}

class _LookupSyncOfflineManualPageState
    extends State<LookupSyncOfflineManualPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _backgroundJobOffline = BackgroundJobOffline();
  final _backgroundJobOfflineLookUp = BackgroundJobOfflineLookUp();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {});
      });
    });
  }

  syncOfflineManualLookUp() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    try {
      await _backgroundJobOfflineLookUp.startRunningBackgroundSyncLookUpJob();
      overlay.hide();
      if (!mounted) return;
      alertDialogMessageWidget(
          context, "Successfull", "LookUp Successully Synced.");
    } on SocketException {
      overlay.hide();
      showDialogMessage('Unable to sync lookup(offline) data.');
    }
  }

  syncOfflineManual() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    try {
      await _backgroundJobOffline.startRunningBackgroundSyncJobManually(
          preferences!.getInt('userId')!);
      overlay.hide();
      if (!mounted) return;
      alertDialogMessageWidget(context, "Successfull", "Synced Completed.");
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
                        'Start Syncing Offline Data',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                            fontSize: 21),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 23, 22, 22),
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                      width: 2, color: Colors.blue),
                                ),
                                onPressed: () {
                                  syncOfflineManual();
                                },
                                child: const Text('Start Syncing'),
                              )),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Start Syncing LookUp Offline Data',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                            fontSize: 21),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 23, 22, 22),
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                      width: 2, color: Colors.blue),
                                ),
                                onPressed: () {
                                  syncOfflineManualLookUp();
                                },
                                child: const Text('Syncing LookUp'),
                              )),
                        ),
                      ],
                    ),
                  ],
                )))));
  }
}
