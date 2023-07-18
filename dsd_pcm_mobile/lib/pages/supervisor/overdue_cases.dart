import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../model/child_notification/notification_case_dto.dart';
import '../../navigation_drawer/navigation_drawer.dart';
import '../../service/child_notification/notification_service.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import 'case_details/case_details_assign.dart';

class OverdueCasesPage extends StatefulWidget {
  const OverdueCasesPage({Key? key}) : super(key: key);

  @override
  State<OverdueCasesPage> createState() => _OverdueCasesPageState();
}

class _OverdueCasesPageState extends State<OverdueCasesPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final NotificationService notificationServiceClient = NotificationService();
  late ApiResponse apiResponse = ApiResponse();
  late List<NotificationCaseDto> notificationCasesDto = [];
  String searchString = "";
  TextEditingController overdueStartDateController = TextEditingController();
  TextEditingController overdueEndDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          DateTime today = DateTime.now();
          var prevMonth = DateTime(today.year, today.month - 6, today.day);
          overdueStartDateController.text =
              "${prevMonth.year}-${prevMonth.month}-${prevMonth.day}";
          overdueEndDateController.text =
              "${today.year}-${today.month}-${today.day}"; //set the initial value of text field
          loadNotificationCases(
              overdueStartDateController.text, overdueEndDateController.text);
        });
      });
    });
  }

  loadNotificationCases(String startDate, String endDate) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();

    apiResponse = await notificationServiceClient.getOverdueCasesBySupervisor(
        preferences!.getString('username')!, startDate, endDate);

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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Overdue Cases'),
          ),
          drawer: const NavigationDrawerMenu(),
          body: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: overdueStartDateController,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Start Date',
                        ),
                        readOnly: true, // when true user cannot edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(
                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                            //You can format date as per your need
                            setState(() {
                              overdueStartDateController.text = formattedDate;
                              loadNotificationCases(
                                  overdueStartDateController.text,
                                  overdueEndDateController
                                      .text); //set foratted date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: overdueEndDateController,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'End Date',
                        ),
                        readOnly: true, // when true user cannot edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(
                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is remov

                            setState(() {
                              overdueEndDateController.text =
                                  formattedDate; //set foratted date to TextField value.
                              loadNotificationCases(
                                  overdueStartDateController.text,
                                  overdueEndDateController.text);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
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
                                .contains(searchString) ||
                            notificationCasesDto[index]
                                .notificationDateSet!
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
                            title: Text(notificationCasesDto[index]
                                .childName
                                .toString()),
                            subtitle: Text(
                                notificationCasesDto[index]
                                    .notificationDateSet
                                    .toString(),
                                style: const TextStyle(color: Colors.grey)),
                            trailing: Text(
                                notificationCasesDto[index]
                                    .hoursLeft
                                    .toString(),
                                style: const TextStyle(color: Colors.red)),
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
                                .contains(searchString) ||
                            notificationCasesDto[index]
                                .notificationDateSet!
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
