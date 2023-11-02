import 'package:dsd_pcm_mobile/model/intake/client_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/person_dto.dart';
import 'package:dsd_pcm_mobile/service/intake/person_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../navigation_drawer/navigation_drawer_menu.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/loading_overlay.dart';
import '../capture_assessment/child_detail/update_child_detail.dart';

class WorkInsAssessmentPage extends StatefulWidget {
  const WorkInsAssessmentPage({Key? key}) : super(key: key);

  @override
  State<WorkInsAssessmentPage> createState() => _WorkInsAssessmentPageState();
}

class _WorkInsAssessmentPageState extends State<WorkInsAssessmentPage> {
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
  List<dynamic> items = [];

  final TextEditingController clientsReferenceNumberController =
      TextEditingController();
  TextEditingController identificationController = TextEditingController();
  final TextEditingController namesController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String searchString = "";
  bool showClientData = false;

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

  loadSearchedPerson(
      String? firstName, String? lastName, String? dateOfBirth) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _personServiceClient.getSearchedWalkedInChild(
        firstName, lastName, dateOfBirth);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personDto = (apiResponse.Data as List<PersonDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadSearchedPersonByIdentificationNumber(String? identificationNumber) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _personServiceClient
        .getSearchedWalkedInChildByIdentitficationNumber(identificationNumber);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personDto = (apiResponse.Data as List<PersonDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  loadSearchedPersonByClientReferenceNumber(
      String? clientReferenceNumber) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _personServiceClient
        .getSearchedWalkedInChildByClientReferenceNumber(clientReferenceNumber);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        clientDto = (apiResponse.Data as List<ClientDto>);
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
  void dispose() {
    clientsReferenceNumberController.dispose();
    identificationController.dispose();
    namesController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //List<dynamic> combinedList = [...personDto, ...clientDto];
    List<dynamic> combinedList = showClientData ? clientDto : personDto;
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Assessment'),
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
                                  // generateDateOfBirth();
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Client Ref No';
                                }
                                return null;
                              },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Identification Number';
                                }
                                return null;
                              },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Names';
                                }
                                return null;
                              },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter surname';
                                }
                                return null;
                              },
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
                                  setState(() {
                                    showClientData = !showClientData;
                                  });
                                  if (clientsReferenceNumberController
                                          .text.isEmpty &&
                                      identificationController.text.isEmpty &&
                                      namesController.text.isEmpty &&
                                      surnameController.text.isEmpty &&
                                      dateOfBirthController.text.isEmpty) {
                                    // All fields are empty, you can display an error message or perform an action.
                                    showDialogMessage(ApiError(
                                        error:
                                            "Please enter at least one search criteria"));
                                  } else if (identificationController
                                          .text.isNotEmpty &&
                                      clientsReferenceNumberController
                                          .text.isNotEmpty) {
                                    showDialogMessage(ApiError(
                                        error:
                                            "Please enter either identity number or client reference number"));
                                  } else if (clientsReferenceNumberController
                                      .text.isNotEmpty) {
                                    if (identificationController
                                            .text.isNotEmpty ||
                                        namesController.text.isNotEmpty ||
                                        surnameController.text.isNotEmpty ||
                                        dateOfBirthController.text.isNotEmpty) {
                                      // Display an error message or perform necessary actions here.
                                      showDialogMessage(ApiError(
                                          error:
                                              "Please enter only Client Reference Number"));
                                    } else {
                                      loadSearchedPersonByClientReferenceNumber(
                                          clientsReferenceNumberController
                                              .text);
                                    }
                                  } else if (identificationController
                                      .text.isNotEmpty) {
                                    if (clientsReferenceNumberController
                                            .text.isNotEmpty ||
                                        namesController.text.isNotEmpty ||
                                        surnameController.text.isNotEmpty ||
                                        dateOfBirthController.text.isNotEmpty) {
                                      // Display an error message or perform necessary actions here.
                                      showDialogMessage(ApiError(
                                          error:
                                              "Please enter only identity Number"));
                                    } else {
                                      loadSearchedPersonByIdentificationNumber(
                                          identificationController.text);
                                    }
                                  } else if (namesController.text.isNotEmpty &&
                                      surnameController.text.isNotEmpty &&
                                      dateOfBirthController.text.isNotEmpty) {
                                    if (clientsReferenceNumberController
                                            .text.isNotEmpty ||
                                        identificationController
                                            .text.isNotEmpty) {
                                      // Display an error message or perform necessary actions here.
                                      showDialogMessage(ApiError(
                                          error:
                                              "Please enter only names, surname and date of birth"));
                                    } else {
                                      loadSearchedPerson(
                                        namesController.text.toString(),
                                        surnameController.text.toString(),
                                        dateOfBirthController.text.toString(),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Search'),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: combinedList.length,
                        itemBuilder: (context, int index) {
                          if (combinedList.isEmpty) {
                            return const Center(
                                child: Text('No worklist Found.'));
                          }
                          final dynamic item = combinedList[index];

                          if (item is PersonDto) {
                            return ListTile(
                                title:
                                    Text(personDto[index].firstName.toString()),
                                subtitle: Text(
                                    personDto[index].lastName.toString(),
                                    style: const TextStyle(color: Colors.grey)),
                                trailing: const Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: Colors.green),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UpdateChildDetailPage(),
                                      settings: RouteSettings(
                                        arguments: personDto[index],
                                      ),
                                    ),
                                  );
                                });
                          } else if (item is ClientDto) {
                            return ListTile(
                                title: Text(clientDto[index]
                                    .personDto!
                                    .firstName
                                    .toString()),
                                subtitle: Text(
                                    clientDto[index]
                                        .personDto!
                                        .lastName
                                        .toString(),
                                    style: const TextStyle(color: Colors.grey)),
                                trailing: const Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: Colors.green),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UpdateChildDetailPage(),
                                      settings: RouteSettings(
                                        arguments: personDto[index],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            // Handle other object types if necessary
                          }
                          // : Container();
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(thickness: 1);
                        },
                      ),
                    ),
                  ]),
                ))));
  }
}
