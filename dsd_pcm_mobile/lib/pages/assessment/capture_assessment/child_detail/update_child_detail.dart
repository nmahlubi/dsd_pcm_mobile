// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dsd_pcm_mobile/model/child_notification/identity_type_dto.dart';
import 'package:dsd_pcm_mobile/model/intake/address_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/address_type_dto.dart';
import '../../../../model/intake/disability_type_dto.dart';
import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/identification_type_dto.dart';
import '../../../../model/intake/language_dto.dart';
import '../../../../model/intake/marital_status_dto.dart';
import '../../../../model/intake/nationality_dto.dart';
import '../../../../model/intake/person_address_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/preferred_contact_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../service/intake/address_service.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';
import '../../../../widgets/dropdown_widget.dart';
import '../../../../widgets/dropdown_widget_v.dart';

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

  final _updateChildFormKey = GlobalKey<FormState>();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final PersonService personServiceClient = PersonService();
  final LookUpService lookUpServiceClient = LookUpService();
  final AddressService addressServiceClient = AddressService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late PersonDto personDto = PersonDto();
  late List<DisabilityTypeDto> disabilityTypesDto = [];
  final List<Map<String, dynamic>> disabilityTypeItemsDto = [];
  late List<GenderDto> gendersDto = [];
  late dynamic genderValue11 = {"genderId": null, "description": null};
  final List<Map<String, dynamic>> genderItemsDto = [];
  late List<PreferredContactTypeDto> preferredContactTypesDto = [];
  final List<Map<String, dynamic>> preferredContactTypeItemsDto = [];
  late List<LanguageDto> languagesDto = [];
  final List<Map<String, dynamic>> languageItemsDto = [];
  late List<NationalityDto> nationalitiesDto = [];
  final List<Map<String, dynamic>> nationalityItemsDto = [];
  late List<MaritalStatusDto> maritalStatusesDto = [];
  final List<Map<String, dynamic>> maritalStatusItemsDto = [];
  late List<IdentificationTypeDto> identificationTypesDto = [];
  late List<PersonAddressDto> previousAddressDto = [];
  final List<Map<String, dynamic>> identificationTypeItemsDto = [];
  late List<AddressTypeDto> addressTypesDto = [];
  final List<Map<String, dynamic>> addressTypeItemsDto = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  DropdownEditingController<Map<String, dynamic>>?
      identificationTypeController = DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? genderController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>?
      preferredContactTypeController = DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? disabilityController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? nationalityController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? maritalStatusController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? languageController =
      DropdownEditingController();
  DropdownEditingController<Map<String, dynamic>>? addressTypeController =
      DropdownEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

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
          loadContactPreferredTypes();
          loadLanguage();
          loadNationalities();
          loadMaritalStatus();
          loadIdentificationTypes();
          loadAddressTypes();
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
        //previousAddressDto = personDto.previousAddress!;
        assignControlValues(personDto);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  assignControlValues(PersonDto personDto) {
    firstNameController.text = personDto.firstName ?? '';
    lastNameController.text = personDto.lastName ?? '';
    identityNumberController.text = personDto.identificationNumber ?? '';
    emailAddressController.text = personDto.emailAddress ?? '';
    mobileNumberController.text = personDto.mobilePhoneNumber ?? '';
    phoneNumberController.text = personDto.phoneNumber ?? '';
    if (personDto.genderDto != null) {
      genderValue11 = {
        "genderId": personDto.genderDto!.genderId,
        "description": '${personDto.genderDto!.description}'
      };

      genderController!.value = genderItemsDto[0];

      //genderController.value.;
      setState(() {});
      //GenderDto.fromJson(personDto.genderDto!) as Map<String, dynamic>?;
      /*Map<String, dynamic> genderValue = {
        "genderId": personDto.genderDto!.genderId,
        "description": '${personDto.genderDto!.description}'
      };
      genderController!.value = genderValue;*/
    }

    generateDateOfBirth();
    //genderController!.value =
    //  GenderDto.fromJson(personDto.genderDto!) as Map<String, dynamic>?;
  }

  generateDateOfBirth() {
    var todayDate = DateTime.now();

    if (identityNumberController.text != '') {
      int? yearFromIdentityNumber =
          int.parse(identityNumberController.text.substring(0, 2));
      int? monthFromIdentityNumber =
          int.parse(identityNumberController.text.substring(2, 4));
      int? dateFromIdentityNumber =
          int.parse(identityNumberController.text.substring(4, 6));

      dateOfBirthController.text = yearFromIdentityNumber > 0 &&
              yearFromIdentityNumber <
                  int.parse(todayDate.year.toString().substring(2, 4))
          ? '20${yearFromIdentityNumber.toString()}-${monthFromIdentityNumber.toString()}-${dateFromIdentityNumber.toString()}'
          : '19${yearFromIdentityNumber.toString()}-${monthFromIdentityNumber.toString()}-${dateFromIdentityNumber.toString()}';
    }
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
            "typeName": '${disabilityType.typeName}'
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

  loadContactPreferredTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getPreferredContactTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        preferredContactTypesDto =
            (apiResponse.Data as List<PreferredContactTypeDto>);
        for (var preferredContactType in preferredContactTypesDto) {
          Map<String, dynamic> preferredContactTypeItem = {
            "preferredContactTypeId":
                preferredContactType.preferredContactTypeId,
            "description": '${preferredContactType.description}'
          };
          preferredContactTypeItemsDto.add(preferredContactTypeItem);
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

  loadAddressTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await addressServiceClient.getAddressTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        addressTypesDto = (apiResponse.Data as List<AddressTypeDto>);
        for (var addressType in addressTypesDto) {
          Map<String, dynamic> addressTypeItem = {
            "addressTypeId": addressType.addressTypeId,
            "description": '${addressType.description}'
          };
          addressTypeItemsDto.add(addressTypeItem);
        }
      });
    }
    overlay.hide();
  }

  addNewChildAddress() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    AddressTypeDto addressTypeItemValue =
        AddressTypeDto.fromJson(addressTypeController!.value);

    AddressDto requestAddress = AddressDto(
        addressId: 0,
        addressLine1: addressLine1Controller.text,
        addressLine2: addressLine2Controller.text,
        addressTypeId: addressTypeItemValue.addressTypeId,
        postalCode: postalCodeController.text);

    apiResponse = await addressServiceClient.addPersonAddress(
        requestAddress, acceptedWorklistDto.personId);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      if (!mounted) return;
      alertDialogMessageWidget(context, "Successfull", apiResults.message!);
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
    }
  }

  updateChildDetails() async {
    /*
 GenderDto? genderItemValue = genderController!.value != null
        ? GenderDto.fromJson(genderController!.value)
        : null;
   */

    //return;

    final overlay = LoadingOverlay.of(context);
    overlay.show();
    GenderDto? genderItemValue = genderController!.value != null
        ? GenderDto.fromJson(genderController!.value)
        : null;
    DisabilityTypeDto disabilityTypeItemValue =
        DisabilityTypeDto.fromJson(disabilityController!.value);
    NationalityDto nationalityItemValue =
        NationalityDto.fromJson(nationalityController!.value);
    MaritalStatusDto maritalStatusItemValue =
        MaritalStatusDto.fromJson(maritalStatusController!.value);
    LanguageDto languageItemValue =
        LanguageDto.fromJson(languageController!.value);
    PreferredContactTypeDto preferredContactTypeItemValue =
        PreferredContactTypeDto.fromJson(preferredContactTypeController!.value);
    IdentityTypeDto identityTypeItemValue =
        IdentityTypeDto.fromJson(identificationTypeController!.value);

    PersonDto requestUpdatePerson = PersonDto(
        personId: acceptedWorklistDto.personId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        identificationTypeId: identityTypeItemValue.identityTypeId,
        identificationNumber: identityNumberController.text,
        dateOfBirth: dateOfBirthController.text,
        age: int.parse(ageController.text),
        languageId: languageItemValue.languageId,
        genderId: genderItemValue!.genderId,
        maritalStatusId: maritalStatusItemValue.maritalStatusId,
        preferredContactTypeId:
            preferredContactTypeItemValue.preferredContactTypeId,
        phoneNumber: phoneNumberController.text,
        mobilePhoneNumber: mobileNumberController.text,
        emailAddress: emailAddressController.text,
        nationalityId: nationalityItemValue.nationalityId,
        disabilityTypeId: disabilityTypeItemValue.disabilityTypeId,
        isPivaValidated: true,
        isEstimatedAge: true);

    apiResponse = await personServiceClient.updatePerson(requestUpdatePerson);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      apiResults = (apiResponse.Data as ApiResults);
      if (!mounted) return;
      alertDialogMessageWidget(context, "Successfull", apiResults.message!);
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
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
    firstNameController.dispose();
    lastNameController.dispose();
    identityNumberController.dispose();
    emailAddressController.dispose();
    mobileNumberController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Child Details'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Form(
                key: _updateChildFormKey,
                child: ListView(
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter firstname';
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
                              controller: lastNameController,
                              enableInteractiveSelection: false,
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName:
                                      identificationTypeController,
                                  labelTextValue: 'Identity Type',
                                  displayItemFnValue: 'description',
                                  itemsCollection: identificationTypeItemsDto,
                                  selectedFnValue: 'identificationTypeId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
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
                              controller: identityNumberController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Identity Number',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter identity number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: const Text('Check'),
                                onPressed: () {
                                  generateDateOfBirth();
                                },
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
                              controller: dateOfBirthController,
                              enableInteractiveSelection: false,
                              readOnly: true,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date Of Birth',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter date of birth';
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
                              controller: ageController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter age';
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: genderController,
                                  labelTextValue: 'Gender',
                                  displayItemFnValue: 'description',
                                  itemsCollection: genderItemsDto,
                                  selectedFnValue: 'genderId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: languageController,
                                  labelTextValue: 'Language',
                                  displayItemFnValue: 'description',
                                  itemsCollection: languageItemsDto,
                                  selectedFnValue: 'languageId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
                        ),
                      ],
                    ),
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: disabilityController,
                                  labelTextValue: 'Disability',
                                  displayItemFnValue: 'typeName',
                                  itemsCollection: disabilityTypeItemsDto,
                                  selectedFnValue: 'disabilityTypeId',
                                  filterFnValue: 'typeName',
                                  titleValue: 'typeName',
                                  subtitleValue: '')),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: nationalityController,
                                  labelTextValue: 'Nationality',
                                  displayItemFnValue: 'description',
                                  itemsCollection: nationalityItemsDto,
                                  selectedFnValue: 'nationalityId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: maritalStatusController,
                                  labelTextValue: 'Marital Status',
                                  displayItemFnValue: 'description',
                                  itemsCollection: maritalStatusItemsDto,
                                  selectedFnValue: 'maritalStatusId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Contacts',
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName:
                                      preferredContactTypeController,
                                  labelTextValue: 'Prefered Contact Type',
                                  displayItemFnValue: 'description',
                                  itemsCollection: preferredContactTypeItemsDto,
                                  selectedFnValue: 'preferredContactTypeId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
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
                              controller: phoneNumberController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: mobileNumberController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mobile Number',
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
                              controller: emailAddressController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email Address',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Updated Address',
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: addressTypeController,
                                  labelTextValue: 'Address Type',
                                  displayItemFnValue: 'description',
                                  itemsCollection: addressTypeItemsDto,
                                  selectedFnValue: 'addressTypeId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
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
                              controller: addressLine1Controller,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address Line 1',
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
                              controller: addressLine2Controller,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address Line 2',
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
                              controller: postalCodeController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Postal Code',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: const Text('Address Add'),
                                onPressed: () {
                                  addNewChildAddress();
                                },
                              )),
                        ),
                      ],
                    ),
                    if (personDto.currentAddress != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Current Address',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w200,
                              fontSize: 21),
                        ),
                      ),
                    if (personDto.currentAddress != null)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (context, int index) {
                                return ListTile(
                                    title: Text(
                                        'Type : ${personDto.currentAddress!.addressDto?.addressType ?? ''}'),
                                    subtitle: Text(
                                        'Address : ${personDto.currentAddress!.addressDto?.addressLine1 ?? ''} ${personDto.currentAddress!.addressDto?.addressLine2 ?? ''}  ',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: Text(personDto.currentAddress!
                                            .addressDto?.postalCode ??
                                        ''));
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(thickness: 1);
                              },
                            ),
                          ),
                        ],
                      ),
                    if (personDto.previousAddress != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'Previous Address',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w200,
                              fontSize: 21),
                        ),
                      ),
                    if (personDto.previousAddress != null)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: personDto.previousAddress!.length,
                              itemBuilder: (context, int index) {
                                if (personDto.previousAddress!.isEmpty) {
                                  return const Center(
                                      child: Text('No Previous Address.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Type : ${personDto.previousAddress![index].addressDto?.addressType ?? ''}'),
                                    subtitle: Text(
                                        'Address : ${personDto.previousAddress![index].addressDto?.addressLine1 ?? ''}  ${personDto.previousAddress![index].addressDto?.addressLine2 ?? ''}  ',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: Text(personDto
                                            .previousAddress![index]
                                            .addressDto
                                            ?.postalCode ??
                                        ''));
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(thickness: 1);
                              },
                            ),
                          ),
                        ],
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
                                  if (_updateChildFormKey.currentState!
                                      .validate()) {
                                    updateChildDetails();
                                  }
                                },
                              )),
                        ),
                      ],
                    ),
                  ],
                ))));
  }
}
