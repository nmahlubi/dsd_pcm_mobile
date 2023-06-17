import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../navigation_drawer/navigation_drawer.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../service/pcm/worklist_service.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';

class CompleteAssessmentPage extends StatefulWidget {
  const CompleteAssessmentPage({Key? key}) : super(key: key);

  @override
  State<CompleteAssessmentPage> createState() => _CompleteAssessmentPageState();
}

class _CompleteAssessmentPageState extends State<CompleteAssessmentPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final WorklistService worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          initializeControlValues(acceptedWorklistDto);
        });
      });
    });
  }

  initializeControlValues(AcceptedWorklistDto acceptedWorklistDto) async {
    await completeAssessment(acceptedWorklistDto);
  }

  completeAssessment(AcceptedWorklistDto acceptedWorklistDto) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse =
        await worklistServiceClient.completeWorklist(acceptedWorklistDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      await showAlertDialogMessage("Successfull", apiResults.message!);
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
          appBar: AppBar(
            title: const Text('Complete Assessment'),
          ),
          drawer: const NavigationDrawer(),
          body: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Complete Assessment',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w200,
                      fontSize: 21),
                ),
              ),
            ],
          ),
        ));
  }
}
