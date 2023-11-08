import 'package:dsd_pcm_mobile/model/intake/client_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/person_dto.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/child_detail/update_child_detail.dart';
import 'package:dsd_pcm_mobile/pages/assessment/walk-ins/create_child_details.dart';
import 'package:dsd_pcm_mobile/service/intake/person_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';

class WalkinSearchResultDetailsPage extends StatefulWidget {
  const WalkinSearchResultDetailsPage({Key? key}) : super(key: key);

  @override
  State<WalkinSearchResultDetailsPage> createState() =>
      _ViewChildDetailsPageState();
}

class _ViewChildDetailsPageState extends State<WalkinSearchResultDetailsPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _personServiceClient = PersonService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<PersonDto> personDto = [];
  late List<ClientDto> clientDto = [];
  List<dynamic> items = [];
  bool showData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          final Map<String, dynamic> arguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;

          String clientsReferenceNumber = arguments['clientsReferenceNumber'];
          String identification = arguments['identification'];
          String names = arguments['names'];
          String surname = arguments['surname'];
          String dateOfBirth = arguments['dateOfBirth'];

          if (clientsReferenceNumber.isNotEmpty) {
            loadSearchedPersonByClientReferenceNumber(clientsReferenceNumber);
            print(clientsReferenceNumber);
          } else if (identification.isNotEmpty) {
            loadSearchedPersonByIdentificationNumber(identification);
            print(identification);
          } else {
            loadSearchedPerson(names, surname, dateOfBirth);
          }
          showData = !showData;
          print(showData);
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
        .getSearchedWalkedInChildByClientReferenceNumber(
            Uri.encodeComponent(clientReferenceNumber!));
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

  showAlertDialogMessage(String? headerMessage, String? message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(headerMessage!),
        content: Text(message!),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              //color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //List<dynamic> combinedList = showData ? clientDto : personDto;
    List<dynamic> combinedList = [];
    combinedList.addAll(personDto);
    combinedList.addAll(clientDto);
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Walkin Child Details'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Search Results',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: combinedList.length,
                  itemBuilder: (context, int index) {
                    if (combinedList.isEmpty) {
                      return const Center(child: Text('No results Found.'));
                    }

                    final dynamic item = combinedList[index];

                    if (item is PersonDto) {
                      return ListTile(
                          title: Text(personDto[index].firstName.toString()),
                          subtitle: Text(personDto[index].lastName.toString(),
                              style: const TextStyle(color: Colors.grey)),
                          trailing: const Icon(Icons.play_circle_fill_rounded,
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
                          title: Text(
                              clientDto[index].personDto!.firstName.toString()),
                          subtitle: Text(
                              clientDto[index].personDto!.lastName.toString(),
                              style: const TextStyle(color: Colors.grey)),
                          trailing: const Icon(Icons.play_circle_fill_rounded,
                              color: Colors.green),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateChildDetailPage(),
                                // settings: RouteSettings(
                                //   arguments: personDto[index],
                                // ),
                              ),
                            );
                          });
                    }
                    return const SizedBox.shrink();
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
