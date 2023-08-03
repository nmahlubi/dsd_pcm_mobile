import 'package:dsd_pcm_mobile/model/pcm/preliminary_detail_dto.dart';
import 'package:dsd_pcm_mobile/pages/preliminary_inquery/court_decision/court_decision.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../model/pcm/preliminary_detailQuery_dto.dart';
import '../../navigation_drawer/navigation_drawer_menu.dart';
import '../../service/pcm/worklist_service.dart';

class PreliminaryPage extends StatefulWidget {
  const PreliminaryPage({Key? key}) : super(key: key);

  @override
  State<PreliminaryPage> createState() => _PreliminaryPageState();
}

class _PreliminaryPageState extends State<PreliminaryPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final WorklistService worklistServiceClient = WorklistService();
  late ApiResponse apiResponse = ApiResponse();
  //late List<AcceptedWorklistDto> acceptedWorklistDto = [];
  late List<PreliminaryDetailQueryDto> prelimanaryDetailsQuery = [];

  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadCompletedTaskAllocatedToProbationOfficer();
          loadLookUpTransformer();
        });
      });
    });
  }

  loadCompletedTaskAllocatedToProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse =
        await worklistServiceClient.getCompletedTaskAllocatedToProbationOfficer(
            preferences!.getInt('userId')!);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        prelimanaryDetailsQuery =
            (apiResponse.Data as List<PreliminaryDetailQueryDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    overlay.hide();
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
          appBar: AppBar(
            title: const Text('Preliminary Inquiry'),
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
                  itemCount: prelimanaryDetailsQuery.length,
                  itemBuilder: (context, int index) {
                    if (prelimanaryDetailsQuery.isEmpty) {
                      return const Center(child: Text('No worklist Found.'));
                    }
                    return prelimanaryDetailsQuery[index]
                            .childName!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(prelimanaryDetailsQuery[index]
                                .childName
                                .toString()),
                            subtitle: Text(
                                prelimanaryDetailsQuery[index]
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
                                      const CourtDecisionPage(),
                                  settings: RouteSettings(
                                    arguments: prelimanaryDetailsQuery[index],
                                  ),
                                ),
                              );
                            })
                        : Container();
                  },
                  separatorBuilder: (context, index) {
                    return prelimanaryDetailsQuery[index]
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
