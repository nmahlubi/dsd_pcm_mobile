import 'package:dsd_pcm_mobile/model/pcm/home_based_supervision_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../navigation_drawer/navigation_drawer_menu.dart';
import '../../service/pcm/worklist_service.dart';
import 'home_based_diversion_detail/home_based_diversion_detail.dart';

class HomeBasedDiversionPage extends StatefulWidget {
  const HomeBasedDiversionPage({Key? key}) : super(key: key);

  @override
  State<HomeBasedDiversionPage> createState() => _HomeBasedDiversionPageState();
}

class _HomeBasedDiversionPageState extends State<HomeBasedDiversionPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  late List<AcceptedWorklistDto> acceptedWorklistDto = [];
  String searchString = "";
  ExpandableController viewMedicalInfoPanelController = ExpandableController();

  @override
  void initState() {
    super.initState();
    viewMedicalInfoPanelController =
        ExpandableController(initialExpanded: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadLookUpTransformer();
          loadCompletedCasesByProbationOfficer();
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    //healthStatusesDto = await _lookupTransform.transformHealthStatusesDto();
    overlay.hide();
  }

  loadCompletedCasesByProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _worklistServiceClient
        .getCompletedWorklistByProbationOfficerOnline(
            preferences!.getInt('userId')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        acceptedWorklistDto = (apiResponse.Data as List<AcceptedWorklistDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  showSuccessMessage(String? message) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(message!), backgroundColor: Colors.green),
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
            title: const Text("Diversion & HBS"),
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
                          child: Text('No completed worklist Found.'));
                    }
                    return acceptedWorklistDto[index]
                            .childName!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(acceptedWorklistDto[index]
                                .childName
                                .toString()),
                            subtitle: Text(
                                acceptedWorklistDto[index]
                                    .dateAccepted
                                    .toString(),
                                style: const TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.play_circle_fill_rounded,
                                color: Colors.green),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeBasedDiversionDetailPage(),
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
        ));
  }
}
