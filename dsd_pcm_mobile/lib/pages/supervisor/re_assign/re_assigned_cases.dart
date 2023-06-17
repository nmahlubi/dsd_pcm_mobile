import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/allocated_case_supervisor_dto.dart';
import '../../../navigation_drawer/navigation_drawer.dart';
import '../../../service/pcm/endpoint_inbox_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import 'complete_re_assigned.dart.dart';

class ReAssignedCasesPage extends StatefulWidget {
  const ReAssignedCasesPage({Key? key}) : super(key: key);

  @override
  State<ReAssignedCasesPage> createState() => _ReAssignedCasesPageState();
}

class _ReAssignedCasesPageState extends State<ReAssignedCasesPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final EndPointInboxService endPointInboxServiceClient =
      EndPointInboxService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AllocatedCaseSupervisorDto> allocatedCaseSupervisorDto = [];
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

    apiResponse = await endPointInboxServiceClient
        .getAllocatedCasesBySupervisor(preferences!.getInt('userId')!);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        allocatedCaseSupervisorDto =
            (apiResponse.Data as List<AllocatedCaseSupervisorDto>);
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ReAllocate Case'),
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
                  itemCount: allocatedCaseSupervisorDto.length,
                  itemBuilder: (context, int index) {
                    if (allocatedCaseSupervisorDto.isEmpty) {
                      return const Center(child: Text('No Cases Found.'));
                    }
                    return allocatedCaseSupervisorDto[index]
                            .childName!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(allocatedCaseSupervisorDto[index]
                                .childName
                                .toString()),
                            subtitle: Text(
                                '${allocatedCaseSupervisorDto[index].arrestDetails} .${allocatedCaseSupervisorDto[index].probationOfficer}',
                                style: const TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.play_circle_fill_rounded,
                                color: Colors.green),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompleteReAssignedCasesPage(),
                                  settings: RouteSettings(
                                    arguments:
                                        allocatedCaseSupervisorDto[index],
                                  ),
                                ),
                              );
                            })
                        : Container();
                  },
                  separatorBuilder: (context, index) {
                    return allocatedCaseSupervisorDto[index]
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
        ));
  }
}
