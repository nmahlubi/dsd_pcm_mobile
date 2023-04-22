import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/disability_type_dto.dart';
import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/identification_type_dto.dart';
import '../../../../model/intake/language_dto.dart';
import '../../../../model/intake/marital_status_dto.dart';
import '../../../../model/intake/nationality_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';

class UpdateChildDetailPage extends StatefulWidget {
  const UpdateChildDetailPage({Key? key}) : super(key: key);

  @override
  State<UpdateChildDetailPage> createState() => _UpdateChildDetailPageState();
}

class _UpdateChildDetailPageState extends State<UpdateChildDetailPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final PersonService personServiceClient = PersonService();
  final LookUpService lookUpServiceClient = LookUpService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late PersonDto personDto = PersonDto();
  late List<DisabilityTypeDto> disabilityTypesDto = [];
  final List<Map<String, dynamic>> disabilityTypeItemsDto = [];
  late List<GenderDto> gendersDto = [];
  final List<Map<String, dynamic>> genderItemsDto = [];
  late List<LanguageDto> languagesDto = [];
  final List<Map<String, dynamic>> languageItemsDto = [];
  late List<NationalityDto> nationalitiesDto = [];
  final List<Map<String, dynamic>> nationalityItemsDto = [];
  late List<MaritalStatusDto> maritalStatusesDto = [];
  final List<Map<String, dynamic>> maritalStatusItemsDto = [];
  late List<IdentificationTypeDto> identificationTypesDto = [];
  final List<Map<String, dynamic>> identificationTypeItemsDto = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  DropdownEditingController<Map<String, dynamic>>? genderController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? disabilityController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? nationalityController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? maritalStatusController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? languageController =
      DropdownEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadDisabilityTypes();
          loadGenders();
          loadLanguage();
          loadNationalities();
          loadMaritalStatus();
          loadIdentificationTypes();
          loadChildDetailsByPersonId(acceptedWorklistDto.personId);
        });
      });
    });
  }

  loadChildDetailsByPersonId(int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await personServiceClient.getPersonById(personId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        personDto = (apiResponse.Data as PersonDto);
        assignControlValues(personDto);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  assignControlValues(PersonDto personDto) {
    firstNameController.text = personDto.firstName!;
    lastNameController.text = personDto.lastName!;
    identityNumberController.text = personDto.identificationNumber!;
    dateOfBirthController.text = personDto.dateOfBirth!;
    ageController.text = personDto.age!.toString();
    //genderController!.value =
    //  GenderDto.fromJson(personDto.genderDto!) as Map<String, dynamic>?;
  }

  calculateAge() {
    /*
     TextEditingController identityNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
    */
  }

  loadDisabilityTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getDisabilityTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        disabilityTypesDto = (apiResponse.Data as List<DisabilityTypeDto>);
        for (var disabilityType in disabilityTypesDto) {
          Map<String, dynamic> disabilityItem = {
            "disabilityTypeId": disabilityType.disabilityTypeId,
            "description": '${disabilityType.typeName}'
          };
          disabilityTypeItemsDto.add(disabilityItem);
        }
      });
    }
    overlay.hide();
  }

  loadGenders() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getGenders();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        gendersDto = (apiResponse.Data as List<GenderDto>);
        for (var gender in gendersDto) {
          Map<String, dynamic> genderItem = {
            "genderId": gender.genderId,
            "description": '${gender.description}'
          };
          genderItemsDto.add(genderItem);
        }
      });
    }
    overlay.hide();
  }

  loadLanguage() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getLanguages();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        languagesDto = (apiResponse.Data as List<LanguageDto>);
        for (var language in languagesDto) {
          Map<String, dynamic> languageItem = {
            "languageId": language.languageId,
            "description": '${language.description}'
          };
          languageItemsDto.add(languageItem);
        }
      });
    }
    overlay.hide();
  }

  loadNationalities() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getNationalities();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        nationalitiesDto = (apiResponse.Data as List<NationalityDto>);
        for (var nationality in nationalitiesDto) {
          Map<String, dynamic> nationalityItem = {
            "nationalityId": nationality.nationalityId,
            "description": '${nationality.description}'
          };
          nationalityItemsDto.add(nationalityItem);
        }
      });
    }
    overlay.hide();
  }

  loadMaritalStatus() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getMaritalStatus();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        maritalStatusesDto = (apiResponse.Data as List<MaritalStatusDto>);
        for (var maritalStatus in maritalStatusesDto) {
          Map<String, dynamic> maritalStatusItem = {
            "maritalStatusId": maritalStatus.maritalStatusId,
            "description": '${maritalStatus.description}'
          };
          maritalStatusItemsDto.add(maritalStatusItem);
        }
      });
    }
    overlay.hide();
  }

  loadIdentificationTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getIdentificationTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        identificationTypesDto =
            (apiResponse.Data as List<IdentificationTypeDto>);
        for (var identificationType in identificationTypesDto) {
          Map<String, dynamic> identificationTypeItem = {
            "identificationTypeId": identificationType.identificationTypeId,
            "description": '${identificationType.description}'
          };
          identificationTypeItemsDto.add(identificationTypeItem);
        }
      });
    }
    overlay.hide();
  }

  updateChildDetails() async {
    GenderDto genderItemValue = GenderDto.fromJson(genderController!.value);
    DisabilityTypeDto disabilityTypeItemValue =
        DisabilityTypeDto.fromJson(disabilityController!.value);
    NationalityDto nationalityItemValue =
        NationalityDto.fromJson(nationalityController!.value);
    MaritalStatusDto maritalStatusItemValue =
        MaritalStatusDto.fromJson(maritalStatusController!.value);
    LanguageDto languageItemValue =
        LanguageDto.fromJson(languageController!.value);

    print(genderItemValue.genderId);
    print(disabilityTypeItemValue.disabilityTypeId);
    print(nationalityItemValue.nationalityId);
    print(maritalStatusItemValue.maritalStatusId);
    print(languageItemValue.languageId);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Details'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Personal Details',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: firstNameController,
                    enableInteractiveSelection: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Firstname',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: lastNameController,
                    enableInteractiveSelection: false,
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
                    controller: identityNumberController,
                    enableInteractiveSelection: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Identity Number',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                    enableInteractiveSelection: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date Of Birth',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: ageController,
                    enableInteractiveSelection: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
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
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: genderController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Genders"),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic str) {},
                    //validator: (dynamic str) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Genders';
                      }
                      return null;
                    },
                    displayItemFn: (dynamic item) => Text(
                      (item ?? {})['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => genderItemsDto,
                    selectedFn: (dynamic item1, dynamic item2) {
                      if (item1 != null && item2 != null) {
                        return item1['genderId'] == item2['genderId'];
                      }
                      return false;
                    },
                    filterFn: (dynamic item, str) =>
                        item['description']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
                        0,
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(item['description']),
                      subtitle: Text(
                        item['description'] ?? '',
                      ),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: languageController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Language"),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic str) {},
                    //validator: (dynamic str) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Language';
                      }
                      return null;
                    },
                    displayItemFn: (dynamic item) => Text(
                      (item ?? {})['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => languageItemsDto,
                    selectedFn: (dynamic item1, dynamic item2) {
                      if (item1 != null && item2 != null) {
                        return item1['languageId'] == item2['languageId'];
                      }
                      return false;
                    },
                    filterFn: (dynamic item, str) =>
                        item['description']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
                        0,
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(item['description']),
                      subtitle: Text(
                        item['description'] ?? '',
                      ),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /*

          */
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Additional Information',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: disabilityController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Disability"),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic str) {},
                    //validator: (dynamic str) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Disability';
                      }
                      return null;
                    },
                    displayItemFn: (dynamic item) => Text(
                      (item ?? {})['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => disabilityTypeItemsDto,
                    selectedFn: (dynamic item1, dynamic item2) {
                      if (item1 != null && item2 != null) {
                        return item1['disabilityTypeId'] ==
                            item2['disabilityTypeId'];
                      }
                      return false;
                    },
                    filterFn: (dynamic item, str) =>
                        item['description']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
                        0,
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(item['description']),
                      subtitle: Text(
                        item['description'] ?? '',
                      ),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
            ],
          ),
//second
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: nationalityController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Nationality"),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic str) {},
                    //validator: (dynamic str) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nationality';
                      }
                      return null;
                    },
                    displayItemFn: (dynamic item) => Text(
                      (item ?? {})['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => nationalityItemsDto,
                    selectedFn: (dynamic item1, dynamic item2) {
                      if (item1 != null && item2 != null) {
                        return item1['nationalityId'] == item2['nationalityId'];
                      }
                      return false;
                    },
                    filterFn: (dynamic item, str) =>
                        item['description']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
                        0,
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(item['description']),
                      subtitle: Text(
                        item['description'] ?? '',
                      ),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: DropdownFormField<Map<String, dynamic>>(
                    controller: maritalStatusController,
                    onEmptyActionPressed: () async {},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        labelText: "Marital Status"),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic str) {},
                    //validator: (dynamic str) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Marital Status';
                      }
                      return null;
                    },
                    displayItemFn: (dynamic item) => Text(
                      (item ?? {})['description'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => maritalStatusItemsDto,
                    selectedFn: (dynamic item1, dynamic item2) {
                      if (item1 != null && item2 != null) {
                        return item1['maritalStatusId'] ==
                            item2['maritalStatusId'];
                      }
                      return false;
                    },
                    filterFn: (dynamic item, str) =>
                        item['description']
                            .toLowerCase()
                            .indexOf(str.toLowerCase()) >=
                        0,
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(item['description']),
                      subtitle: Text(
                        item['description'] ?? '',
                      ),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Address',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w200,
                  fontSize: 21),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                ),
              ),
              Expanded(
                child: Container(
                    height: 70,
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
                    child: ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () {
                        updateChildDetails();
                      },
                    )),
              ),
            ],
          ),

          /*

          */
        ],
      ),
    );
  }
}
