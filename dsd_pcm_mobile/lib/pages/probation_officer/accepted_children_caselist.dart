import 'package:dsd_pcm_mobile/model/pcm/accepted_worklist_dto.dart';
import 'package:dsd_pcm_mobile/service/pcm/worklist_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navigation_drawer/navigation_drawer_menu.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import '../preliminary_inquery/preliminary.dart';

class ChildrenCaseListPage extends StatefulWidget {
  const ChildrenCaseListPage({Key? key}) : super(key: key);

  @override
  State<ChildrenCaseListPage> createState() => _ChildrenCaseListPageState();
}

class _ChildrenCaseListPageState extends State<ChildrenCaseListPage> {
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
          loadCompleteTaskAllocatedToProbationOfficer();
        });
      });
    });
  }

  loadCompleteTaskAllocatedToProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse =
        await worklistServiceClient.getCompletedTaskAllocatedToProbationOfficer(
            preferences!.getInt('userId')!);

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
        title: const Text('Children Case List'),
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
              itemCount: acceptedWorklistDto.length,
              itemBuilder: (context, int index) {
                if (acceptedWorklistDto.isEmpty) {
                  return const Center(
                      child: Text('No Complete Assessment Case list Found.'));
                }
                return acceptedWorklistDto[index]
                        .childNameAbbr!
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PreliminaryPage(),
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
