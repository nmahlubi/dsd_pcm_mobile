import 'package:dsd_pcm_mobile/model/intake/organization_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/diversion_recommendation_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/programmes_dto.dart';
import 'package:dsd_pcm_mobile/service/intake/organization_service.dart';
import 'package:dsd_pcm_mobile/service/intake/programmes_service.dart';
import 'package:dsd_pcm_mobile/service/pcm/recommendations_service.dart';
import 'package:dsd_pcm_mobile/util/shared/randon_generator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/intake/district_dto.dart';
import '../../../model/intake/local_municipality_dto.dart';
import '../../../model/intake/organization_type_dto.dart';
import '../../../model/intake/province_dto.dart';
import '../../../model/pcm/recommendations_dto.dart';
import '../../../navigation_drawer/recommendation_drawer.dart';
import '../../../service/intake/district_service.dart';
import '../../../service/intake/local_municipality_service.dart';
import '../../../service/intake/organization_type_service.dart';
import '../../../service/intake/province_service.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../probation_officer/accepted_worklist.dart';

class ServiceProviderPage extends StatefulWidget {
  const ServiceProviderPage({Key? key}) : super(key: key);

  @override
  State<ServiceProviderPage> createState() => _ServiceProviderPageState();
}

class _ServiceProviderPageState extends State<ServiceProviderPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late RecommendationDto recommendationDto = RecommendationDto();
  final _randomGenerator = RandomGenerator();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  final _provinceClient = ProvinceService();
  final _recommendationsServiceClient = RecommendationsService();
  final _districtServiceClient = DistrictService();
  final _localMunicipalityServiceClient = LocalMunicipalityService();
  final _organizationTypeServiceClient = OrganizationTypeService();
  final _organizationServiceClient = OrganizationService();
  final _programmesServiceClient = ProgrammesService();
  late List<ProvinceDto> provinceDto = [];
  late List<DistrictDto> districtDto = [];
  late List<OrganizationTypeDto> organizationTypeDto = [];
  late List<LocalMunicipalityDto> localMunicipalityDto = [];
  late List<ProgrammesDto> programmesDto = [];
  late List<OrganizationDto> organizationDto = [];
  late List<DiversionRecommendationDto> diversionRecommendationDto = [];
  late List<ProgrammesDto> tempArray = [];
  ExpandableController captureServiceProviderPanelController =
      ExpandableController();
  ExpandableController viewOffenceDetailPanelController =
      ExpandableController();

  int? provinceDropdownButtonFormField;
  int? districtDropdownButtonForm;
  int? localMunicipalityDropdownButtonFormField;
  int? organizationTypeDropdownButtonFormField;
  int? organizationDropdownButtonFormField;
  int? programmesDropdownButtonFormField;
  int? pcmDiversionRecommId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureServiceProviderPanelController =
        ExpandableController(initialExpanded: false);
    viewOffenceDetailPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Diversion';
    pcmDiversionRecommId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          recommendationDto =
              ModalRoute.of(context)!.settings.arguments as RecommendationDto;
          loadProvinces();
          loadOrganizationTypes();
          loadDiversionRecommendationByRecommendationId(
              recommendationDto.recommendationId);
        });
      });
    });
  }

  loadProvinces() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _provinceClient.getProvinces();
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        districtDto = [];
        localMunicipalityDto = [];
        organizationDto = [];
        programmesDto = [];
        provinceDto = (apiResponse.Data as List<ProvinceDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadDistrictsByProvince(int? selectedValue) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse =
        await _districtServiceClient.getDistrictByProvinceId(selectedValue!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        localMunicipalityDto = [];
        organizationDto = [];
        programmesDto = [];
        districtDto = (apiResponse.Data as List<DistrictDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadLocalMunicipalitiesByDistrictId(int? districtId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _localMunicipalityServiceClient
        .getLocalMunicipalitiesByDistrictId(districtId!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        organizationDto = [];
        programmesDto = [];
        localMunicipalityDto = (apiResponse.Data as List<LocalMunicipalityDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadOrganizationTypes() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _organizationTypeServiceClient.getOrganizationTypes();
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        organizationDto = [];
        programmesDto = [];
        organizationTypeDto = (apiResponse.Data as List<OrganizationTypeDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadOrganizationByOrganizationTypeAndLocalMunicipality(
      int? localMunicipalityId, int? organizationTypeId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _organizationServiceClient
        .getOrganizationByOrganizationTypeAndLocalMunicipality(
            localMunicipalityId!, organizationTypeId!);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programmesDto = [];
        organizationDto = (apiResponse.Data as List<OrganizationDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadProgrammesByOrganizationId(int? organizationId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _programmesServiceClient
        .getProgrammesByOrganizationId(organizationId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        programmesDto = (apiResponse.Data as List<ProgrammesDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  loadDiversionRecommendationByRecommendationId(int? diversionId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _recommendationsServiceClient
        .getDiversionRecommendationByRecommendationId(diversionId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        diversionRecommendationDto =
            (apiResponse.Data as List<DiversionRecommendationDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  deleteDiversionRecommendationByRecommendationForm(
      DiversionRecommendationDto diversionRecommendationDto) async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    apiResponse = await _recommendationsServiceClient
        .deleteDiversionRecommendation(diversionRecommendationDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully deleted');
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const ServiceProviderPage(),
        ),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateServiceProviderMember() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    DiversionRecommendationDto requestAddDiversionRecommendationRequestDto =
        DiversionRecommendationDto(
      pcmDiversionRecommId:
          pcmDiversionRecommId ?? _randomGenerator.getRandomGeneratedNumber(),
      recommendationId: recommendationDto.recommendationId,
      recommendationProgrammesId: programmesDropdownButtonFormField,
      programmesDto: programmesDropdownButtonFormField != null
          ? programmesDto
              .where((a) => a.programmeId == programmesDropdownButtonFormField)
              .single
          : null,
      createdBy: preferences!.getInt('userId')!,
      dateCreated: _randomGenerator.getCurrentDateGenerated(),
    );

    apiResponse =
        await _recommendationsServiceClient.addUpdateDiversionRecommendation(
            requestAddDiversionRecommendationRequestDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate');
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const ServiceProviderPage(),
        ),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  newServiceProvider() {
    setState(() {
      labelButtonAddUpdate = 'Add Service Provider';

      districtDropdownButtonForm = null;
      provinceDropdownButtonFormField = null;
      localMunicipalityDropdownButtonFormField = null;
      organizationTypeDropdownButtonFormField = null;
      organizationDropdownButtonFormField = null;
      pcmDiversionRecommId = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text("Service Provider"),
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
            ),
            drawer:
                GoToRecommendationDrawer(recommendationDto: recommendationDto),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Form(
                  key: _loginFormKey,
                  child: ListView(
                    children: [
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        captureServiceProviderPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Service Provider",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        minimumSize: const Size
                                                            .fromHeight(10),
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                244, 248, 246),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        newServiceProvider();
                                                      },
                                                      child: const Text('New',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue)),
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          provinceDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Provine',
                                                        labelText: 'Province',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: provinceDto
                                                          .map((province) {
                                                        return DropdownMenuItem(
                                                            value: province
                                                                .provinceId,
                                                            child: Text(province
                                                                .description
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) async {
                                                        setState(() {
                                                          districtDropdownButtonForm =
                                                              null;
                                                        });
                                                        provinceDropdownButtonFormField =
                                                            selectedValue;

                                                        if (selectedValue !=
                                                            null) {
                                                          loadDistrictsByProvince(
                                                              selectedValue);
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Province Required';
                                                        }
                                                        return null;
                                                      },
                                                    ))),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        districtDropdownButtonForm,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'District',
                                                      labelText: 'District',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: districtDto
                                                        .map((district) {
                                                      return DropdownMenuItem(
                                                          value: district
                                                              .districtId,
                                                          child: Text(district
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged:
                                                        (selectedValue) async {
                                                      setState(() {
                                                        localMunicipalityDropdownButtonFormField =
                                                            null;
                                                      });

                                                      districtDropdownButtonForm =
                                                          selectedValue;
                                                      if (selectedValue !=
                                                          null) {
                                                        loadLocalMunicipalitiesByDistrictId(
                                                            selectedValue);
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'district Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        localMunicipalityDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Municipality',
                                                      labelText: 'Municipality',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: localMunicipalityDto
                                                        .map((municipality) {
                                                      return DropdownMenuItem(
                                                          value: municipality
                                                              .localMunicipalityId,
                                                          child: Text(
                                                              municipality
                                                                  .description
                                                                  .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      localMunicipalityDropdownButtonFormField =
                                                          selectedValue;
                                                      if (selectedValue !=
                                                          null) {}
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Municipality Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        organizationTypeDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Org Type',
                                                      labelText: 'Org Type',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: organizationTypeDto
                                                        .map(
                                                            (organizationType) {
                                                      return DropdownMenuItem(
                                                          value: organizationType
                                                              .organizationTypeId,
                                                          child: Text(
                                                              organizationType
                                                                  .description
                                                                  .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      setState(() {
                                                        organizationDropdownButtonFormField =
                                                            null;
                                                      });
                                                      organizationTypeDropdownButtonFormField =
                                                          selectedValue;
                                                      if (selectedValue !=
                                                          null) {
                                                        loadOrganizationByOrganizationTypeAndLocalMunicipality(
                                                            localMunicipalityDropdownButtonFormField,
                                                            selectedValue);
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Org Type Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        organizationDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Organization',
                                                      labelText: 'Organization',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: organizationDto
                                                        .map((organization) {
                                                      return DropdownMenuItem(
                                                          value: organization
                                                              .organizationId,
                                                          child: Text(
                                                              organization
                                                                  .description
                                                                  .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      setState(() {
                                                        programmesDropdownButtonFormField =
                                                            null;
                                                      });
                                                      organizationDropdownButtonFormField =
                                                          selectedValue;
                                                      if (selectedValue !=
                                                          null) {
                                                        loadProgrammesByOrganizationId(
                                                            selectedValue);
                                                      }
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Organization Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        programmesDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Programmes',
                                                      labelText: 'Programmes',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: programmesDto
                                                        .map((programmes) {
                                                      return DropdownMenuItem(
                                                          value: programmes
                                                              .programmeId,
                                                          child: Text(programmes
                                                              .programmeName
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      programmesDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Programme is Required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: Container(
                                        //         padding:
                                        //             const EdgeInsets.all(10),
                                        //         child: ListView.separated(
                                        //           shrinkWrap: true,
                                        //           itemCount:
                                        //               programmesDto.length,
                                        //           itemBuilder:
                                        //               (context, int index) {
                                        //             if (programmesDto.isEmpty) {
                                        //               return const Center(
                                        //                   child: Text(
                                        //                       'No Programme Found.'));
                                        //             }
                                        //             return InkWell(
                                        //               onTap: () {
                                        //                 setState(() {
                                        //                   if (tempArray
                                        //                       .contains(
                                        //                           programmesDto[
                                        //                               index])) {
                                        //                     tempArray.remove(
                                        //                         programmesDto[
                                        //                             index]);
                                        //                   } else {
                                        //                     tempArray.add(
                                        //                         programmesDto[
                                        //                             index]);
                                        //                   }
                                        //                 });
                                        //                 print(tempArray[index]
                                        //                     .programmeName);
                                        //               },
                                        //               child: Card(
                                        //                   child: ListTile(
                                        //                 title: Text(
                                        //                     'Programme Name : ${programmesDto[index].programmeName}',
                                        //                     style: const TextStyle(
                                        //                         color: Colors
                                        //                             .black,
                                        //                         fontWeight:
                                        //                             FontWeight
                                        //                                 .bold)),
                                        //                 subtitle: Text(
                                        //                     'Organization : ${programmesDto[index].organizationId}.',
                                        //                     style:
                                        //                         const TextStyle(
                                        //                             color: Colors
                                        //                                 .black)),
                                        //                 trailing: Container(
                                        //                   height: 40,
                                        //                   width: 100,
                                        //                   decoration:
                                        //                       BoxDecoration(
                                        //                     color: tempArray.contains(
                                        //                             programmesDto[
                                        //                                 index])
                                        //                         ? Colors.red
                                        //                         : Colors.green,
                                        //                     borderRadius:
                                        //                         BorderRadius
                                        //                             .circular(
                                        //                                 10),
                                        //                   ),
                                        //                   child: Center(
                                        //                     child: Text(tempArray
                                        //                             .contains(
                                        //                                 programmesDto[
                                        //                                     index])
                                        //                         ? 'Remove'
                                        //                         : 'Add'),
                                        //                   ),
                                        //                 ),
                                        //               )),
                                        //             );
                                        //           },
                                        //           separatorBuilder:
                                        //               (context, index) {
                                        //             return const Divider(
                                        //                 thickness: 1);
                                        //           },
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 10, 2),
                                            )),
                                            Expanded(
                                                child: Container(
                                                    height: 70,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        10, 20, 10, 2),
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                23, 22, 22),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        if (_loginFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          addUpdateServiceProviderMember();
                                                        }
                                                      },
                                                      child: Text(
                                                          labelButtonAddUpdate!),
                                                    ))),
                                          ],
                                        ),
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )))
                      ]),
                      Row(children: [
                        Expanded(
                            child: ExpandableNotifier(
                                child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: <Widget>[
                                ScrollOnExpand(
                                  scrollOnExpand: true,
                                  scrollOnCollapse: false,
                                  child: ExpandablePanel(
                                    controller:
                                        viewOffenceDetailPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Diversion Programmes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        )),
                                    collapsed: const Text(
                                      '',
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (diversionRecommendationDto
                                            .isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      diversionRecommendationDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (diversionRecommendationDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No diversion programmes Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Programme name : ${diversionRecommendationDto[index].programmesDto?.programmeName}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Organisation : ${diversionRecommendationDto[index].programmesDto?.organizationDto?.description} ',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          //IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),

                                                          IconButton(
                                                              onPressed: () {
                                                                deleteDiversionRecommendationByRecommendationForm(
                                                                    diversionRecommendationDto[
                                                                        index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red)),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                        thickness: 1);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                    builder: (_, collapsed, expanded) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Expandable(
                                          collapsed: collapsed,
                                          expanded: expanded,
                                          theme: const ExpandableThemeData(
                                              crossFadePoint: 0),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
                      ]),
                    ],
                  ),
                ))));
  }
}
