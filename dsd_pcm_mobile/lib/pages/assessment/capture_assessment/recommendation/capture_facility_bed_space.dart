import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/intake/admission_type.dart';
import '../../../../model/pcm/accepted_worklist_dto.dart';
import '../../../../model/pcm/facility_bed_space.dart';
import '../../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../../service/pcm/facility_bed_space_service.dart';
import '../../../../transform_dynamic/transform_lookup.dart';
import '../../../../util/shared/apierror.dart';
import '../../../../util/shared/apiresponse.dart';
import '../../../../util/shared/apiresults.dart';
import '../../../../util/shared/loading_overlay.dart';
import '../../../../util/shared/randon_generator.dart';
import '../../../probation_officer/accepted_worklist.dart';
import 'facility_bed_space_detail.dart';


// ignore: must_be_immutable
class CaptureFacilityBedSpaceDetails extends StatefulWidget {
  late List<FacilityBedSpaceDto> facilityBedSpaceDto;
   CaptureFacilityBedSpaceDetails({Key? key, required this.facilityBedSpaceDto}) : super(key: key);

  @override
  State<CaptureFacilityBedSpaceDetails> createState() => _CaptureFacilityBedSpaceDetailsState();
}

class _CaptureFacilityBedSpaceDetailsState extends State<CaptureFacilityBedSpaceDetails> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  final _lookupTransform = LookupTransform();
  final _randomGenerator = RandomGenerator();
  final _facilityBedSpaceServiceClient = FacilityBedSpaceService();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late FacilityBedSpaceDto captureFacilityBedSpaceDto =FacilityBedSpaceDto();
  late List<AdmissionTypeDto> admissionTypeDto= [];
  late List<FacilityBedSpaceDto> facilityBedSpaceDtoList = [];
  ExpandableController captureFacilityBedSpacePanelController =ExpandableController();
  ExpandableController viewFacilityBedPanelController = ExpandableController();
  final TextEditingController requestCommentsController = TextEditingController();

  int? requestId;
  int? admissionTypeDropdownButtonFormField;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureFacilityBedSpacePanelController =
        ExpandableController(initialExpanded: false);
    viewFacilityBedPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Facility Bed Space';
    requestId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadLookUpTransformer();
          loadFacilityBedSpaceByIntakeAssessmentId(acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadLookUpTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    admissionTypeDto = await _lookupTransform.transformAdmissionTypeDto();
    overlay.hide();
  }
loadFacilityBedSpaceByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await _facilityBedSpaceServiceClient
        .getFacilityBedSpaceByIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
      facilityBedSpaceDtoList = (apiResponse.Data as List<FacilityBedSpaceDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateFacilityBedSpace() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    FacilityBedSpaceDto requestAddFacilityBedSpaceRequestDto = FacilityBedSpaceDto(
        requestId:
            requestId ?? _randomGenerator.getRandomGeneratedNumber(),
        
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
         admissionTypeId: admissionTypeDropdownButtonFormField,
            admissionTypeDto: admissionTypeDropdownButtonFormField != null
                ? admissionTypeDto
                    .where((a) =>
                        a.admissionTypeId == admissionTypeDropdownButtonFormField)
                    .single
                : null,
         facilityId: 1,
            requestStatusId: 1,
            requestOpenClose: 'Open',
            requestSubject: 'New Bed Space Request',
            requestComments: requestCommentsController.text,
        createdBy: preferences!.getInt('userId')!,
        modifiedBy: preferences!.getInt('userId')!,
        dateModified: _randomGenerator.getCurrentDateGenerated(),
        );

    apiResponse = await _facilityBedSpaceServiceClient
        .addUpdateFacilityBedSpace(requestAddFacilityBedSpaceRequestDto);

    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      if (!mounted) return;
      showSuccessMessage('Successfully $labelButtonAddUpdate');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const FacilityBedSpacePage(),
           ),
      );
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  newFacilityBedSpace() {
    setState(() {
      labelButtonAddUpdate = 'Add Facility Bed Space';
      requestCommentsController.clear();
      admissionTypeDropdownButtonFormField = null;
      requestId = null;
    });
  }

  populateHealthDetailForm(FacilityBedSpaceDto facilityBedSpaceDtoList) {
    setState(() {
      requestId = facilityBedSpaceDtoList.requestId;
      captureFacilityBedSpacePanelController =
          ExpandableController(initialExpanded: true);
      viewFacilityBedPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Facility Bed Space';
      requestCommentsController.text = facilityBedSpaceDtoList.requestComments!;
      admissionTypeDropdownButtonFormField =
          facilityBedSpaceDtoList.admissionTypeId;
    });
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
              title: const Text("Facility Bed Space"),
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
                            builder: (context) => const FacilityBedSpacePage(),
                             settings: RouteSettings(
                              arguments: acceptedWorklistDto,
                            ),
                          ),
                        );
                      },
                      heroTag: null,
                      child: const Icon(Icons.arrow_back)),

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
                                        captureFacilityBedSpacePanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Facility Bed Space",
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
                                                                    .fromARGB(
                                                                255,
                                                                244,
                                                                248,
                                                                246),
                                                        shape:
                                                            const StadiumBorder(),
                                                        side: const BorderSide(
                                                            width: 2,
                                                            color: Colors.blue),
                                                      ),
                                                      onPressed: () {
                                                        newFacilityBedSpace();
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
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      requestCommentsController,
                                                  maxLines: 2,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Request Comments',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Request Comments';
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
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        admissionTypeDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Admission Type',
                                                      labelText:
                                                          'Admission Type',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: admissionTypeDto
                                                        .map((admissionType) {
                                                      return DropdownMenuItem(
                                                          value: admissionType
                                                              .admissionTypeId,
                                                          child: Text(
                                                              admissionType
                                                                  .description
                                                                  .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      admissionTypeDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Admission Type required';
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            ),
                                          ],
                                        ),
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
                                                                    .fromARGB(
                                                                255,
                                                                23,
                                                                22,
                                                                22),
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
                                                          addUpdateFacilityBedSpace();
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
                                    controller: viewFacilityBedPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "View Facility Bed Space",
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
                                        if (facilityBedSpaceDtoList.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      facilityBedSpaceDtoList
                                                          .length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (facilityBedSpaceDtoList
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No facility bed space Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Admission Type : ${facilityBedSpaceDtoList[index].admissionTypeDto?.description}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Request Comments : ${facilityBedSpaceDtoList[index].requestComments}. ',
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
                                                                // populateHealthDetailForm(
                                                                //     facilityBedSpaceDtoList[
                                                                //         index]);
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue)),
                                                          /*IconButton(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red)),*/
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
