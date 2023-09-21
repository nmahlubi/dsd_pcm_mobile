import 'package:dsd_pcm_mobile/model/intake/province_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/accepted_worklist_dto.dart';
import 'package:dsd_pcm_mobile/model/pcm/facility_bed_space.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/general_detail.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/recommendation.dart';
import 'package:dsd_pcm_mobile/pages/assessment/capture_assessment/recommendation/capture_facility_bed_space.dart';
import 'package:dsd_pcm_mobile/service/intake/province_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/intake/admission_type.dart';
import '../../../../model/intake/cyca_facility_dto.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/facility_bed_space_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';


class FacilityBedSpacePage extends StatefulWidget {
  const FacilityBedSpacePage({Key? key}) : super(key: key);

  @override
  State<FacilityBedSpacePage> createState() =>
      _FacilityBedSpacePageState();
}

class _FacilityBedSpacePageState
    extends State<FacilityBedSpacePage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto =
      AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _facilityBedSpaceServiceClient = FacilityBedSpaceService();
  final _provinceClient = ProvinceService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<FacilityBedSpaceDto> facilityBedSpaceDto= [];
  late List<CycaFacilityDto> cycaFacilityDto = [];
  late List<AdmissionTypeDto> admissionTypeDto= [];
  late List<ProvinceDto> provinceDto=[];
  ExpandableController viewHomeBasedSupervisionPanelController =
      ExpandableController();
  ExpandableController viewHBSConditionPanelController = ExpandableController();

  ExpandableController captureFacilityBedSpaceRequestPanelController =
      ExpandableController();
  ExpandableController viewVisitationOutcomePanelController =
      ExpandableController();
  final TextEditingController requestCommentsController = TextEditingController();

  int? requestId;
  int? provinceDropdownButtonFormField;
  int? admissionTypeDropdownButtonFormField;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    viewHomeBasedSupervisionPanelController =
        ExpandableController(initialExpanded: true);
    viewHBSConditionPanelController =
        ExpandableController(initialExpanded: true);
    captureFacilityBedSpaceRequestPanelController =
        ExpandableController(initialExpanded: false);
    viewVisitationOutcomePanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Visitation Outcome';
    
    requestId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto = ModalRoute.of(context)!
              .settings
              .arguments as AcceptedWorklistDto;
          //loadLookUpTransformer();
          loadProvinces();
        
        });
      });
    });
  }

loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    cycaFacilityDto = await _lookupTransform.transformCycaFacilityDto();
    admissionTypeDto = await _lookupTransform.transformAdmissionTypeDto();
    provinceDto = await _lookupTransform.transformProvinceDto();
    overlay.hide();
  }
loadProvinces() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _provinceClient.getProvinces();
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        provinceDto = (apiResponse.Data as List<ProvinceDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

loadFacilityBedSpaceByProvinceId(int? provinceId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _facilityBedSpaceServiceClient
        .getFacilityBedSpaceByProvinceId(provinceId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        facilityBedSpaceDto = (apiResponse.Data as List<FacilityBedSpaceDto>);
      });
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
    requestCommentsController.dispose();
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
              title: const Text("FACILITY BED SPACE"),
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
                            builder: (context) => const RecommandationPage(),
                            settings: RouteSettings(
                              arguments: acceptedWorklistDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GeneralDetailPage(),
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
                                        viewHomeBasedSupervisionPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Facilities, Facility Bed Sapce, Facility Programme",
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          provinceDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Province',
                                                        labelText:
                                                            'Province',
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
                                                            child: Text(
                                                                province
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        provinceDropdownButtonFormField =
                                                            selectedValue;
                                                            loadFacilityBedSpaceByProvinceId(provinceDropdownButtonFormField);
                                                      },
                                                      
                                                    ))),
                                          ],
                                        ),
                                        
                                        if (facilityBedSpaceDto.isNotEmpty)                                       
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      facilityBedSpaceDto
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (facilityBedSpaceDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No facilities,Facility Bed Space, Facility Programmes Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Facility Name : ${facilityBedSpaceDto[index].cycaFacilityDto?.facilityName}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Facility Tell : ${facilityBedSpaceDto[index].cycaFacilityDto?.facilityTelNo}. '
                                                          'Province : ${facilityBedSpaceDto[index].provinceDto?.countryDto?.countryName}. '
                                                          'Facility Email : ${facilityBedSpaceDto[index].cycaFacilityDto?.facilityEmailAddress}. ',
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
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                             CaptureFacilityBedSpaceDetails(facilityBedSpaceDto: facilityBedSpaceDto,),
                                                                    settings:
                                                                        RouteSettings(
                                                                      arguments:
                                                                          acceptedWorklistDto,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                  Icons.play_circle_fill_rounded,
                                                                  color: Colors
                                                                      .green)),
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
