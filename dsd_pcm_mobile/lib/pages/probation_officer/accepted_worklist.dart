import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/pcm/accepted_worklist_dto.dart';
import '../../navigation_drawer/navigation_drawer.dart';
import '../../service/pcm/worklist_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import '../assessment/capture_assessment/capture_assessment.dart';

class AcceptedWorklistPage extends StatefulWidget {
  const AcceptedWorklistPage({Key? key}) : super(key: key);

  @override
  State<AcceptedWorklistPage> createState() => _AcceptedWorklistPageState();
}

class _AcceptedWorklistPageState extends State<AcceptedWorklistPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final WorklistService worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AcceptedWorklistDto> acceptedWorklistDto = [];
  String searchString = "";

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

    apiResponse = await worklistServiceClient
        .getAcceptedWorklistByProbationOfficer(preferences!.getInt('userId')!);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        acceptedWorklistDto = (apiResponse.Data as List<AcceptedWorklistDto>);
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
        title: const Text('Accepted Worklist'),
      ),
      drawer: const NavigationDrawer(),
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
              itemCount: acceptedWorklistDto.length,
              itemBuilder: (context, int index) {
                if (acceptedWorklistDto.isEmpty) {
                  return const Center(child: Text('No worklist Found.'));
                }
                return acceptedWorklistDto[index]
                        .childName!
                        .toLowerCase()
                        .contains(searchString)
                    ? ListTile(
                        title: Text(
                            acceptedWorklistDto[index].childName.toString()),
                        subtitle: Text(
                            acceptedWorklistDto[index].dateAccepted.toString(),
                            style: const TextStyle(color: Colors.grey)),
                        trailing: const Icon(Icons.play_circle_fill_rounded,
                            color: Colors.green),
                        /*trailing: Text(
                            acceptedWorklistDto[index]
                                .arrestTime
                                .toString(),
                            style: const TextStyle(color: Colors.red)),*/
                        /*
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ViewChildDetailsPage(),
                              settings: RouteSettings(
                                arguments: acceptedWorklistDto[index],
                              ),
                            ),
                          );
                        }
                        
                        */
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CaptureAssessmentPage(),
                              settings: RouteSettings(
                                arguments: acceptedWorklistDto[index],
                              ),
                            ),
                          );
                        })
                    : Container();
              },
              separatorBuilder: (context, index) {
                return acceptedWorklistDto[index]
                        .childName!
                        .toLowerCase()
                        .contains(searchString)
                    ? const Divider(thickness: 1)
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
