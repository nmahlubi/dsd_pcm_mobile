import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/child_notification/notification_case_dto.dart';
import '../../navigation_drawer/navigation_drawer.dart';
import '../../service/child_notification/notification_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import 'case_details/case_details_assign.dart';

class NotificationCasesPage extends StatefulWidget {
  const NotificationCasesPage({Key? key}) : super(key: key);

  @override
  State<NotificationCasesPage> createState() => _NotificationCasesPageState();
}

class _NotificationCasesPageState extends State<NotificationCasesPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final NotificationService notificationServiceClient = NotificationService();
  late ApiResponse apiResponse = ApiResponse();
  late List<NotificationCaseDto> notificationCasesDto = [];
  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          loadNotificationCases();
        });
      });
    });
  }

  loadNotificationCases() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await notificationServiceClient
        .getNotificationCasesBySupervisor(preferences!.getString('username')!);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        notificationCasesDto = (apiResponse.Data as List<NotificationCaseDto>);
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
        title: const Text('Notification Cases'),
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
              itemCount: notificationCasesDto.length,
              itemBuilder: (context, int index) {
                if (notificationCasesDto.isEmpty) {
                  return const Center(child: Text('No Cases Found.'));
                }
                return notificationCasesDto[index]
                        .childName!
                        .toLowerCase()
                        .contains(searchString)
                    ? ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 194, 191, 199),
                          child: Text(notificationCasesDto[index]
                              .childNameAbbr
                              .toString()),
                        ),
                        title: Text(
                            notificationCasesDto[index].childName.toString()),
                        subtitle: Text(
                            notificationCasesDto[index]
                                .notificationDateSet
                                .toString(),
                            style: const TextStyle(color: Colors.grey)),
                        trailing: Text(
                            notificationCasesDto[index].hoursLeft.toString(),
                            style: const TextStyle(color: Colors.green)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CaseDetailsAssignPage(),
                              settings: RouteSettings(
                                arguments: notificationCasesDto[index],
                              ),
                            ),
                          );
                        })
                    : Container();
              },
              separatorBuilder: (context, index) {
                return notificationCasesDto[index]
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
