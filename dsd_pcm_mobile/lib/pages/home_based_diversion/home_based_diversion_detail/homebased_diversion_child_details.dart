import 'package:dsd_pcm_mobile/model/intake/address_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/query/homebased_diversion_query_dto.dart';
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
import '../../../../service/intake/address_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../transform_dynamic/tranform_address.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../navigation_drawer/go_to_home_based_diversion_drawer.dart';
import '../home_based_diversion.dart';
import 'home_based_supervision_detail.dart';

class DiversionHbsChildDetails extends StatefulWidget {
  const DiversionHbsChildDetails({super.key});

  @override
  State<DiversionHbsChildDetails> createState() => _DiversionHbsChildDetailsState();
}

class _DiversionHbsChildDetailsState extends State<DiversionHbsChildDetails> {
SharedPreferences? preferences;
  final _loginFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
 
   Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _personServiceClient = PersonService();
  final _addressServiceClient = AddressService();
  final _lookupTransform = LookupTransform();
  final _addressTransform = AddressTransform();
  final _randomGenerator = RandomGenerator();
  late HomebasedDiversionQueryDto homebasedDiversionQueryDto = HomebasedDiversionQueryDto();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late PersonDto personDto = PersonDto();
  late List<DisabilityTypeDto> disabilityTypesDto = [];
  late List<GenderDto> gendersDto = [];
  late List<PreferredContactTypeDto> preferredContactTypesDto = [];
  late List<LanguageDto> languagesDto = [];
  late List<NationalityDto> nationalitiesDto = [];
  late List<MaritalStatusDto> maritalStatusesDto = [];
  late List<IdentificationTypeDto> identificationTypesDto = [];
  late List<PersonAddressDto> personAddressesDto = [];
  late List<AddressTypeDto> addressTypesDto = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();

  int? identityTypeDropdownButtonFormField;
  int? genderDropdownButtonFormField;
  int? disabilityTypeDropdownButtonFormField;
  int? preferredContactTypeDropdownButtonFormField;
  int? languageDropdownButtonFormField;
  int? nationalityDropdownButtonFormField;
  int? maritalStatusDropdownButtonFormField;
  int? addressTypeDropdownButtonFormField;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          homebasedDiversionQueryDto =
              ModalRoute.of(context)!.settings.arguments as HomebasedDiversionQueryDto;
          loadLookUpTransformer();
          loadChildDetailsByPersonId(homebasedDiversionQueryDto.personId);
          loadPersonAddressByPersonId(homebasedDiversionQueryDto.personId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    identificationTypesDto =
        await _lookupTransform.transformIdentificationTypeDto();
    disabilityTypesDto = await _lookupTransform.transformDisabilityTypesDto();
    gendersDto = await _lookupTransform.transformGendersDto();
    preferredContactTypesDto =
        await _lookupTransform.transformContactPreferredTypesDto();
    languagesDto = await _lookupTransform.transformLanguageDto();
    nationalitiesDto = await _lookupTransform.transformNationalitiesDto();
    maritalStatusesDto = await _lookupTransform.transformMaritalStatusDto();
    addressTypesDto = await _addressTransform.transformAddressTypesDto();
    overlay.hide();
  }

  loadChildDetailsByPersonId(int? personId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _personServiceClient.getPersonById(
        personId, preferences!.getInt('userId')!);
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
    setState(() {
      firstNameController.text = personDto.firstName ?? '';
      lastNameController.text = personDto.lastName ?? '';
      identityNumberController.text = personDto.identificationNumber ?? '';
      emailAddressController.text = personDto.emailAddress ?? '';
      mobileNumberController.text = personDto.mobilePhoneNumber ?? '';
      phoneNumberController.text = personDto.phoneNumber ?? '';
      identityTypeDropdownButtonFormField = personDto.identificationTypeId;
      genderDropdownButtonFormField = personDto.genderId;
      disabilityTypeDropdownButtonFormField = personDto.disabilityTypeId;
      preferredContactTypeDropdownButtonFormField =
          personDto.preferredContactTypeId;
      languageDropdownButtonFormField = personDto.languageId;
      nationalityDropdownButtonFormField = personDto.nationalityId;
      maritalStatusDropdownButtonFormField = personDto.maritalStatusId;
    });
  }

  loadPersonAddressByPersonId(int? personId) async {
    apiResponse = await _addressServiceClient.getAddressByPersonId(personId);
    if ((apiResponse.ApiError) == null) {
      setState(() {
        personAddressesDto = (apiResponse.Data as List<PersonAddressDto>);
      });
    } else {
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
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text("Child Details"),
              leading: IconButton(
                icon: const Icon(Icons.offline_pin_rounded),
                onPressed: () {
                  if (scaffoldKey.currentState!.isDrawerOpen) {
                    scaffoldKey.currentState!.closeDrawer();
                    //close drawer, if drawer is open
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                    //open drawer, if drawer is closed
                  }
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  tooltip: 'Home Based Diversion',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeBasedDiversionPage()),
                    );
                  },
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HomeBasedDiversionPage()),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeBasedSupervisionDetailPage(),
                            settings: RouteSettings(
                              arguments: homebasedDiversionQueryDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ),
            drawer:GoToHomeBasedDiversionDrawer(homebasedDiversionQueryDto: homebasedDiversionQueryDto),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                    key: _loginFormKey,
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
                                  child: DropdownButtonFormField(
                                    value: identityTypeDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Identity Type',
                                      labelText: 'Identity Type',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: identificationTypesDto
                                        .map((identification) {
                                      return DropdownMenuItem(
                                          value: identification
                                              .identificationTypeId,
                                          child: Text(identification.description
                                              .toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        identityTypeDropdownButtonFormField =
                                            selectedValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Identifycation Type is required';
                                      }
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
                                  keyboardType: TextInputType.number,
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
                                  child: DropdownButtonFormField(
                                    value: genderDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Gender',
                                      labelText: 'Gender',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: gendersDto.map((gender) {
                                      return DropdownMenuItem(
                                          value: gender.genderId,
                                          child: Text(
                                              gender.description.toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        genderDropdownButtonFormField =
                                            selectedValue;
                                      });
                                    },
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: DropdownButtonFormField(
                                    value: languageDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Language',
                                      labelText: 'Language',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: languagesDto.map((language) {
                                      return DropdownMenuItem(
                                          value: language.languageId,
                                          child: Text(
                                              language.description.toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        languageDropdownButtonFormField =
                                            selectedValue;
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
       
  ],
                    )))));
  }
}