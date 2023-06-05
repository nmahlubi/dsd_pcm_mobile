import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/care_giver_details_dto.dart';
import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/person_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../service/intake/care_giver_detail_service.dart';
import '../../../../service/intake/look_up_service.dart';
import '../../../../service/intake/person_service.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import 'capture_care_giver_detail.dart';
import 'view_offence_detail.dart';

class CareGiverDetailPage extends StatefulWidget {
  const CareGiverDetailPage({Key? key}) : super(key: key);

  @override
  State<CareGiverDetailPage> createState() => _CareGiverDetailPageState();
}

class _CareGiverDetailPageState extends State<CareGiverDetailPage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final LookUpService lookUpServiceClient = LookUpService();
  final PersonService personServiceClient = PersonService();
  final CareGiverDetailService careGiverDetailServiceClient =
      CareGiverDetailService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<GenderDto> gendersDto = [];
  final List<Map<String, dynamic>> genderItemsDto = [];
  late List<CareGiverDetailsDto> careGiverDetailsDto = [];
  late List<RelationshipTypeDto> relationshipTypesDto = [];
  final List<Map<String, dynamic>> relationshipTypeItemsDto = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadGenders();
          loadRelationshipTypes();
          loadCareGiverDetailsByClientId(acceptedWorklistDto.clientId);
        });
      });
    });
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

  loadRelationshipTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await lookUpServiceClient.getRelationshipTypes();
    if ((apiResponse.ApiError) == null) {
      setState(() {
        relationshipTypesDto = (apiResponse.Data as List<RelationshipTypeDto>);
        for (var relation in relationshipTypesDto) {
          Map<String, dynamic> relationshipType = {
            "relationshipTypeId": relation.relationshipTypeId,
            "description": '${relation.description}'
          };
          relationshipTypeItemsDto.add(relationshipType);
        }
      });
    }
    overlay.hide();
  }

  loadCareGiverDetailsByClientId(int? clientId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await careGiverDetailServiceClient
        .getCareGiverDetailsByClientId(clientId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        careGiverDetailsDto = (apiResponse.Data as List<CareGiverDetailsDto>);
      });
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  captureCareGiverDetail(
      RelationshipTypeDto relationshipTypeValue,
      GenderDto genderValue,
      String? firstName,
      String? lastName,
      String? identityNumber) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await addPerson(
        firstName, lastName, identityNumber, genderValue.genderId);

    if ((apiResponse.ApiError) == null) {
      apiResults = (apiResponse.Data as ApiResults);
      PersonDto relativeMember = PersonDto.fromJson(apiResults.data);
      CareGiverDetailsDto requestAddCareGiverDetails = CareGiverDetailsDto(
          clientCaregiverId: 0,
          personId: relativeMember.personId,
          clientId: acceptedWorklistDto.clientId,
          relationshipTypeId: relationshipTypeValue.relationshipTypeId,
          createdBy: preferences!.getString('username')!);

      apiResponse = await careGiverDetailServiceClient
          .addCareGiverDetail(requestAddCareGiverDetails);
      if ((apiResponse.ApiError) == null) {
        apiResults = (apiResponse.Data as ApiResults);
        overlay.hide();
        await showAlertDialogMessage(
            "Successfull", (apiResponse.Data as ApiResults).message!);

        navigator.push(
          MaterialPageRoute(
              builder: (context) => const CareGiverDetailPage(),
              settings: RouteSettings(
                arguments: acceptedWorklistDto,
              )),
        );
      } else {
        showDialogMessage((apiResponse.ApiError as ApiError));
        overlay.hide();
      }
    }
  }

  Future<ApiResponse> addPerson(String? name, String? surname,
      String? identityNumber, int? gender) async {
    PersonDto personDto = PersonDto(
        personId: 0,
        isEstimatedAge: true,
        isPivaValidated: true,
        firstName: name,
        lastName: surname,
        identificationNumber: identityNumber,
        genderId: gender,
        createdBy: preferences!.getString('username')!);
    apiResponse = await personServiceClient.addPerson(personDto);
    return apiResponse;
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
        title: const Text('Care Giver Details'),
      ),
      body: ListView(
        children: [
          CaptureCareGiverDetailPage(
              genderItemsDto: genderItemsDto,
              relationshipTypeItemsDto: relationshipTypeItemsDto,
              addNewCareGiverDetail: captureCareGiverDetail),
          ViewCareGiverDetailPage(careGiverDetailsDto: careGiverDetailsDto)
        ],
      ),
    );
  }
}
