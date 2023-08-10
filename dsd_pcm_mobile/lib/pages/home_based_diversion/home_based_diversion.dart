import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../model/pcm/query/homebased_diversion_query_dto.dart';
import '../../navigation_drawer/navigation_drawer_menu.dart';
import '../../service/pcm/worklist_service.dart';
import 'home_based_diversion_detail/homebased_diversion_child_details.dart';

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
  late List<HomebasedDiversionQueryDto> homebasedDiversionQueryDto = [];

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
          loadHBSDiversionyProbationOfficer();
        });
      });
    });
  }
  loadHBSDiversionyProbationOfficer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _worklistServiceClient
        .getHomebasedDiversionListByProbationOfficer(
            preferences!.getInt('userId')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        homebasedDiversionQueryDto = (apiResponse.Data as List<HomebasedDiversionQueryDto>);
    
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
                  itemCount: homebasedDiversionQueryDto.length,
                  itemBuilder: (context, int index) {
                    if (homebasedDiversionQueryDto.isEmpty) {
                      return const Center(
                          child: Text('No HBS and  Diversionlist Found.'));
                    }
                    return homebasedDiversionQueryDto[index]
                            .childName!
                            .toLowerCase()
                            .contains(searchString)
                        ? ListTile(
                            title: Text(homebasedDiversionQueryDto[index]
                                .childName
                                .toString()),
                            subtitle: Text(
                                homebasedDiversionQueryDto[index]
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
                                      const DiversionHbsChildDetails(),
                                  settings: RouteSettings(
                                    arguments: homebasedDiversionQueryDto[index],
                                  ),
                                ),
                              );
                            })
                        : Container();
                },
                  separatorBuilder: (context, index) {
                    return homebasedDiversionQueryDto[index]
                            .childName!
                            .toLowerCase()
                            .contains(searchString)
                        ? const Divider(thickness: 1)
                        : Container();
                  }
  ),
              ),
            ],
          ),
        ));
  }
}
