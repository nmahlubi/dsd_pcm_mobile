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
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/intake/address_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../transform_dynamic/tranform_address.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../../widgets/alert_dialog_messege_widget.dart';
import '../../../probation_officer/accepted_worklist.dart';
import '../assessment_detail.dart';

class UpdateChildDetailPage extends StatefulWidget {
  const UpdateChildDetailPage({Key? key}) : super(key: key);

  @override
  State<UpdateChildDetailPage> createState() => _UpdateChildDetailPageState();
}

class _UpdateChildDetailPageState extends State<UpdateChildDetailPage> {
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
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
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
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadChildDetailsByPersonId(acceptedWorklistDto.personId);
          loadPersonAddressByPersonId(acceptedWorklistDto.personId);
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
      generateDateOfBirth();
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

  generateDateOfBirth() {
    if (identityNumberController.text != '') {
      var todayDate = DateTime.now();
      String startYear = '19';
      String? yearFromIdentityNumber =
          identityNumberController.text.substring(0, 2);
      String? monthFromIdentityNumber =
          identityNumberController.text.substring(2, 4);
      String? dateFromIdentityNumber =
          identityNumberController.text.substring(4, 6);
      startYear = int.parse(yearFromIdentityNumber) >= 0 &&
              int.parse(yearFromIdentityNumber) > todayDate.year
          ? '20$yearFromIdentityNumber'
          : '19$yearFromIdentityNumber';
      dateOfBirthController.text =
          '${startYear.toString()}/${monthFromIdentityNumber.toString()}/${dateFromIdentityNumber.toString()}';
      ageController.text =
          (todayDate.year - int.parse(startYear.toString())).toString();
    }
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

  addPersonAddress() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    int? addressIdGenerated = _randomGenerator.getRandomGeneratedNumber();

    PersonAddressDto requestPersonAddress = PersonAddressDto(
        personId: acceptedWorklistDto.personId,
        addressId: addressIdGenerated,
        addressDto: AddressDto(
            addressId: addressIdGenerated,
            addressLine1: addressLine1Controller.text,
            addressLine2: addressLine2Controller.text,
            addressTypeId: addressTypeDropdownButtonFormField,
            postalCode: postalCodeController.text,
            addressTypeDto: addressTypeDropdownButtonFormField != null
                ? addressTypesDto
                    .where((i) =>
                        i.addressTypeId == addressTypeDropdownButtonFormField)
                    .single
                : null));

    apiResponse =
        await _addressServiceClient.addPersonAddress(requestPersonAddress);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Address Successfully Created.');
      addressLine1Controller.text = '';
      addressLine2Controller.text = '';
      postalCodeController.text = '';
      addressTypeDropdownButtonFormField = null;
      await loadPersonAddressByPersonId(acceptedWorklistDto.personId);
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
      return;
    }
  }

  updateChildDetails() async {
    if (dateOfBirthController.text.toString() != '') {
      if (int.parse(dateOfBirthController.text.substring(5, 7)) > 12 ||
          int.parse(dateOfBirthController.text.substring(8, 10)) > 31) {
        alertDialogMessageWidget(context, "Error", "Invalid Dateofbirth.");
        return;
      }
    }

    final overlay = LoadingOverlay.of(context);
    overlay.show();
    PersonDto requestUpdatePerson = PersonDto(
        personId: acceptedWorklistDto.personId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        identificationTypeId: identityTypeDropdownButtonFormField,
        identificationTypeDto: identityTypeDropdownButtonFormField != null
            ? identificationTypesDto
                .where((i) =>
                    i.identificationTypeId ==
                    identityTypeDropdownButtonFormField)
                .single
            : null,
        identificationNumber: identityNumberController.text,
        dateOfBirth: dateOfBirthController.text,
        age: int.parse(ageController.text),
        languageId: languageDropdownButtonFormField,
        languageDto: languageDropdownButtonFormField != null
            ? languagesDto
                .where((h) => h.languageId == languageDropdownButtonFormField)
                .single
            : null,
        genderId: genderDropdownButtonFormField,
        genderDto: genderDropdownButtonFormField != null
            ? gendersDto
                .where((h) => h.genderId == genderDropdownButtonFormField)
                .single
            : null,
        maritalStatusId: maritalStatusDropdownButtonFormField,
        maritalStatusDto: maritalStatusDropdownButtonFormField != null
            ? maritalStatusesDto
                .where((h) =>
                    h.maritalStatusId == maritalStatusDropdownButtonFormField)
                .single
            : null,
        preferredContactTypeId: preferredContactTypeDropdownButtonFormField,
        phoneNumber: phoneNumberController.text,
        mobilePhoneNumber: mobileNumberController.text,
        emailAddress: emailAddressController.text,
        nationalityId: nationalityDropdownButtonFormField,
        disabilityTypeId: disabilityTypeDropdownButtonFormField,
        disabilityTypeDto: disabilityTypeDropdownButtonFormField != null
            ? disabilityTypesDto
                .where((h) =>
                    h.disabilityTypeId == disabilityTypeDropdownButtonFormField)
                .single
            : null,
        isPivaValidated: true,
        isEstimatedAge: true,
        isActive: true,
        isDeleted: false,
        pivaTransactionId: "",
        sexualOrientationId: null,
        religionId: null,
        populationGroupId: null,
        citizenshipId: null);

    var acceptedWorklistOffline = AcceptedWorklistDto(
        assessmentStatus: acceptedWorklistDto.assessmentStatus,
        assessmentRegisterId: acceptedWorklistDto.assessmentRegisterId,
        caseId: acceptedWorklistDto.caseId,
        worklistId: acceptedWorklistDto.worklistId,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        personId: acceptedWorklistDto.personId,
        childName:
            '${firstNameController.text} ${lastNameController.text} - DOB (${dateOfBirthController.text})',
        dateAccepted: acceptedWorklistDto.dateAccepted,
        childNameAbbr: acceptedWorklistDto.childNameAbbr,
        clientId: acceptedWorklistDto.clientId);

    apiResponse = await _personServiceClient.updatePerson(requestUpdatePerson,
        preferences!.getInt('userId')!, acceptedWorklistOffline);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Child Details Successfully Updated.');
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
                  tooltip: 'Accepted Worklist',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AcceptedWorklistPage()),
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
                                  const AcceptedWorklistPage()),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AssessmentDetailPage(),
                            settings: RouteSettings(
                              arguments: acceptedWorklistDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ),
            drawer: GoToAssessmentDrawer(
                acceptedWorklistDto: acceptedWorklistDto, isCompleted: true),
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
                                      generateDateOfBirth();
                                    },
                                    child: const Text('Verify'),
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
                                  child: DropdownButtonFormField(
                                    value:
                                        disabilityTypeDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Disability',
                                      labelText: 'Disability',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: disabilityTypesDto.map((disability) {
                                      return DropdownMenuItem(
                                          value: disability.disabilityTypeId,
                                          child: Text(
                                              disability.typeName.toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        disabilityTypeDropdownButtonFormField =
                                            selectedValue;
                                      });
                                    },
                                  )),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: DropdownButtonFormField(
                                    value: nationalityDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Nationality',
                                      labelText: 'Nationality',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: nationalitiesDto.map((nationality) {
                                      return DropdownMenuItem(
                                          value: nationality.nationalityId,
                                          child: Text(nationality.description
                                              .toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        nationalityDropdownButtonFormField =
                                            selectedValue;
                                      });
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
                                  child: DropdownButtonFormField(
                                    value: maritalStatusDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Marital Status',
                                      labelText: 'Marital Status',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items:
                                        maritalStatusesDto.map((maritalStatus) {
                                      return DropdownMenuItem(
                                          value: maritalStatus.maritalStatusId,
                                          child: Text(maritalStatus.description
                                              .toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        maritalStatusDropdownButtonFormField =
                                            selectedValue;
                                      });
                                    },
                                  )),
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
                                  child: DropdownButtonFormField(
                                    value:
                                        preferredContactTypeDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Prefered Contact Type',
                                      labelText: 'Prefered Contact Type',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: preferredContactTypesDto
                                        .map((preferredContactType) {
                                      return DropdownMenuItem(
                                          value: preferredContactType
                                              .preferredContactTypeId,
                                          child: Text(preferredContactType
                                              .description
                                              .toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        preferredContactTypeDropdownButtonFormField =
                                            selectedValue;
                                      });
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
                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        updateChildDetails();
                                      }
                                    },
                                    child: const Text('Update Child'),
                                  )),
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
                                  child: DropdownButtonFormField(
                                    value: addressTypeDropdownButtonFormField,
                                    decoration: const InputDecoration(
                                      hintText: 'Address Type',
                                      labelText: 'Address Type',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                      ),
                                    ),
                                    items: addressTypesDto.map((addressType) {
                                      return DropdownMenuItem(
                                          value: addressType.addressTypeId,
                                          child: Text(addressType.description
                                              .toString()));
                                    }).toList(),
                                    onChanged: (selectedValue) {
                                      setState(() {
                                        addressTypeDropdownButtonFormField =
                                            selectedValue;
                                      });
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
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 23, 22, 22),
                                      shape: const StadiumBorder(),
                                      side: const BorderSide(
                                          width: 2, color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      addPersonAddress();
                                    },
                                    child: const Text('Add Address'),
                                  )),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            'Address History',
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
                                itemCount: personAddressesDto.isEmpty
                                    ? 0
                                    : personAddressesDto.length,
                                itemBuilder: (context, int index) {
                                  if (personAddressesDto.isEmpty) {
                                    return const Center(
                                        child: Text('No Address found.'));
                                  }
                                  return ListTile(
                                      title: Text(
                                          'Type : ${personAddressesDto[index].addressDto?.addressType ?? ''}'),
                                      subtitle: Text(
                                          'Address : ${personAddressesDto[index].addressDto?.addressLine1 ?? ''}  ${personAddressesDto[index].addressDto?.addressLine2 ?? ''}  ',
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                      trailing: Text(personAddressesDto[index]
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
                      ],
                    )))));
  }
}
