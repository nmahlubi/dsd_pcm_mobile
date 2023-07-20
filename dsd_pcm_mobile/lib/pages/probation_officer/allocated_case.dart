import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/pcm/allocated_case_probation_officer_dto.dart';
import '../../navigation_drawer/navigationDrawerMenu.dart';
import '../../service/pcm/endpoint_inbox_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import 'case_details/accept_case.dart';

class AllocatedCasesPage extends StatefulWidget {
  const AllocatedCasesPage({Key? key}) : super(key: key);

  @override
  State<AllocatedCasesPage> createState() => _AllocatedCasesPageState();
}

class _AllocatedCasesPageState extends State<AllocatedCasesPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final EndPointInboxService endPointInboxServiceClient =
      EndPointInboxService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AllocatedCaseProbationOfficerDto> allocatedCasesProbationOfficer =
      [];
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
        .getAllocatedCasesByProbationOfficer(preferences!.getInt('userId')!);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        allocatedCasesProbationOfficer =
            (apiResponse.Data as List<AllocatedCaseProbationOfficerDto>);
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
            title: const Text('Incoming Cases'),
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
                  itemCount: allocatedCasesProbationOfficer.length,
                  itemBuilder: (context, int index) {
                    if (allocatedCasesProbationOfficer.isEmpty) {
                      return const Center(child: Text('No Cases Found.'));
                    }
                    return allocatedCasesProbationOfficer[index]
                            .fullName!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(allocatedCasesProbationOfficer[index]
                                .fullName
                                .toString()),
                            subtitle: Text(
                                '${allocatedCasesProbationOfficer[index].arrestDetails} ${allocatedCasesProbationOfficer[index].allocatedInfo}',
                                style: const TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.arrow_right,
                                color: Colors.green),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AcceptCasePage(),
                                  settings: RouteSettings(
                                    arguments:
                                        allocatedCasesProbationOfficer[index],
                                  ),
                                ),
                              );
                            })
                        : Container();
                  },
                  separatorBuilder: (context, index) {
                    return allocatedCasesProbationOfficer[index]
                            .fullName!
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
