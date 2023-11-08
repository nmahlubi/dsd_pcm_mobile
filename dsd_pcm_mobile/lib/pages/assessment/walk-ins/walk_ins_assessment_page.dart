import 'package:dsd_pcm_mobile/model/intake/client_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/person_dto.dart';
import 'package:dsd_pcm_mobile/pages/assessment/walk-ins/create_child_details.dart';
import 'package:dsd_pcm_mobile/pages/assessment/walk-ins/walkin_search_results.dart';
import 'package:dsd_pcm_mobile/service/intake/person_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../navigation_drawer/navigation_drawer_menu.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../capture_assessment/child_detail/update_child_detail.dart';

class WalkInsAssessmentPage extends StatefulWidget {
  const WalkInsAssessmentPage({Key? key}) : super(key: key);

  @override
  State<WalkInsAssessmentPage> createState() => _WalkInsAssessmentPageState();
}

class _WalkInsAssessmentPageState extends State<WalkInsAssessmentPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _walkInFormKey = GlobalKey<FormState>();
  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _personServiceClient = PersonService();
  late ApiResponse apiResponse = ApiResponse();

  late List<PersonDto> personDto = [];
  late List<ClientDto> clientDto = [];
  late PersonDto singlePersonDto = PersonDto();

  final TextEditingController clientsReferenceNumberController =
      TextEditingController();
  TextEditingController identificationController = TextEditingController();
  final TextEditingController namesController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          //loadAllocatedCasesByProbationOfficer();
        });
      });
    });
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    clientsReferenceNumberController.dispose();
    identificationController.dispose();
    namesController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
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
              title: const Text('Child Details Assessment'),
            ),
            drawer: const NavigationDrawerMenu(),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _walkInFormKey,
                  child: Column(children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                                'Search child first to reduce duplicates'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 23, 22, 22),
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                      width: 2, color: Colors.blue),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateChildDetailPage(),
                                    ),
                                  );
                                },
                                child: const Text('Create'),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: clientsReferenceNumberController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Client Ref No',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: identificationController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Identification Number',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: namesController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Names',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: surnameController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Surname',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: dateOfBirthController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date of birth',
                              ),
                              readOnly: true, // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        1800), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  dateOfBirthController.text = formattedDate;
                                  //You can format date as per your need
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 23, 22, 22),
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                      width: 2, color: Colors.blue),
                                ),
                                onPressed: () {
                                  // setState(() {
                                  //   showClientData = !showClientData;

                                  //   if (clientsReferenceNumberController
                                  //           .text.isEmpty &&
                                  //       identificationController.text.isEmpty &&
                                  //       namesController.text.isEmpty &&
                                  //       surnameController.text.isEmpty &&
                                  //       dateOfBirthController.text.isEmpty) {
                                  //     // All fields are empty, you can display an error message or perform an action.
                                  //     showDialogMessage(ApiError(
                                  //         error:
                                  //             "Please enter at least one search criteria"));
                                  //   } else if (identificationController
                                  //           .text.isNotEmpty &&
                                  //       clientsReferenceNumberController
                                  //           .text.isNotEmpty) {
                                  //     showDialogMessage(ApiError(
                                  //         error:
                                  //             "Please enter either identity number or client reference number"));
                                  //   } else if (clientsReferenceNumberController
                                  //       .text.isNotEmpty) {
                                  //     if (identificationController
                                  //             .text.isNotEmpty ||
                                  //         namesController.text.isNotEmpty ||
                                  //         surnameController.text.isNotEmpty ||
                                  //         dateOfBirthController
                                  //             .text.isNotEmpty) {
                                  //       // Display an error message or perform necessary actions here.
                                  //       showDialogMessage(ApiError(
                                  //           error:
                                  //               "Please enter only Client Reference Number"));
                                  //     } else {
                                  //       loadSearchedPersonByClientReferenceNumber(
                                  //           clientsReferenceNumberController
                                  //               .text);
                                  //     }
                                  //   } else if (identificationController
                                  //       .text.isNotEmpty) {
                                  //     if (clientsReferenceNumberController
                                  //             .text.isNotEmpty ||
                                  //         namesController.text.isNotEmpty ||
                                  //         surnameController.text.isNotEmpty ||
                                  //         dateOfBirthController
                                  //             .text.isNotEmpty) {
                                  //       // Display an error message or perform necessary actions here.
                                  //       showDialogMessage(ApiError(
                                  //           error:
                                  //               "Please enter only identity Number"));
                                  //     } else {
                                  //       loadSearchedPersonByIdentificationNumber(
                                  //           identificationController.text);
                                  //     }
                                  //   } else if (namesController
                                  //               .text.isNotEmpty &&
                                  //           surnameController.text.isNotEmpty ||
                                  //       dateOfBirthController.text.isNotEmpty)
                                  // {
                                  //     if (clientsReferenceNumberController
                                  //             .text.isNotEmpty ||
                                  //         identificationController
                                  //             .text.isNotEmpty) {
                                  //       // Display an error message or perform necessary actions here.
                                  //       showDialogMessage(ApiError(
                                  //           error:
                                  //               "Please enter only names, surname and date of birth"));
                                  //     } else {
                                  //       loadSearchedPerson(
                                  //         namesController.text.toString(),
                                  //         surnameController.text.toString(),
                                  //         dateOfBirthController.text.toString(),
                                  //       );
                                  //     }
                                  //   }
                                  // });
                                  // if (clientsReferenceNumberController
                                  //         .text.isEmpty &&
                                  //     identificationController.text.isEmpty &&
                                  //     namesController.text.isEmpty &&
                                  //     surnameController.text.isEmpty &&
                                  //     dateOfBirthController.text.isEmpty) {
                                  //   // All fields are empty, you can display an error message or perform an action.
                                  //   showDialogMessage(ApiError(
                                  //       error:
                                  //           "Please enter at least one search criteria"));
                                  // } else if (identificationController
                                  //         .text.isNotEmpty &&
                                  //     clientsReferenceNumberController
                                  //         .text.isNotEmpty) {
                                  //   showDialogMessage(ApiError(
                                  //       error:
                                  //           "Please enter either identity number or client reference number"));
                                  // } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WalkinSearchResultDetailsPage(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'clientsReferenceNumber':
                                              clientsReferenceNumberController
                                                  .text,
                                          'identification':
                                              identificationController.text,
                                          'names': namesController.text,
                                          'surname': surnameController.text,
                                          'dateOfBirth':
                                              dateOfBirthController.text,
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Search'),
                              )),
                        ),
                      ],
                    ),
                  ]),
                ))));
  }
}
