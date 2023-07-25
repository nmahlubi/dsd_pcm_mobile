import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/pcm/mobile_dashboard_dto.dart';
import '../../../service/child_notification/notification_service.dart';
import '../../../service/pcm/mobile_dasboard_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _mobileDashboardServiceClient = MobileDashboardService();
  final _notificationServiceClient = NotificationService();
  late ApiResponse apiResponse = ApiResponse();
  late MobileDashboardDto mobileDashboardDto = MobileDashboardDto();
  late int overdueCases = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          mobileDashboardDto = MobileDashboardDto(
              reAssignedCases: 0, newPropationOfficerInbox: 0, newWorklist: 0);
          loadDashboardbyUser();
          if (preferences?.getBool('supervisor') == true) {
            loadCountedOverdueCasesBySupervisor();
          }
        });
      });
    });
  }

  loadDashboardbyUser() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _mobileDashboardServiceClient
        .getMobileDashboardByUser(preferences!.getInt('userId')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        mobileDashboardDto = (apiResponse.Data as MobileDashboardDto);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadCountedOverdueCasesBySupervisor() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse =
        await _notificationServiceClient.getCountedOverdueCasesBySupervisor(
            preferences!.getString('username')!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        overdueCases = (apiResponse.Data as int);
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
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                child: ListView(
              children: <Widget>[
                if (preferences?.getBool('supervisor') == true)
                  _buildTile(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/notification-cases'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text('Inbox (notification cases)',
                                    style: TextStyle(color: Colors.green)),
                              ],
                            ),
                            Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(24.0),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.inbox,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                if (preferences?.getBool('supervisor') == false)
                  _buildTile(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/allocated-cases'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Incoming Cases',
                                    style: TextStyle(color: Colors.green)),
                                Text(
                                    mobileDashboardDto.newPropationOfficerInbox
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(24.0),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.notifications,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                if (preferences?.getBool('supervisor') == true)
                  _buildTile(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/re-assigned-cases'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Allocated Cases',
                                    style: TextStyle(color: Colors.blue)),
                                Text(
                                    mobileDashboardDto.reAssignedCases
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(24.0),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.move_up,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                if (preferences?.getBool('supervisor') == true)
                  _buildTile(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/overdue-cases'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                    'Overdue Cases (for the past six month)',
                                    style: TextStyle(color: Colors.red)),
                                Text(overdueCases.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0))
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.timelapse,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                //if (preferences?.getBool('supervisor') == false)
                _buildTile(
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/accepted-worklist'),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('My WorkList',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Text(mobileDashboardDto.newWorklist.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0))
                            ],
                          ),
                          Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline,
                                    color: Colors.white, size: 30.0),
                              )))
                        ]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                if (preferences?.getBool('supervisor') == false)
                  _buildTile(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/sync-manual-offline'),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text('Sync(Offline)',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(24.0),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.sync,
                                      color: Colors.white, size: 30.0),
                                )))
                          ]),
                    ),
                  ),
              ],
            ))));
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: const Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    //print('Not set yet');
                  },
            child: child));
  }
}
