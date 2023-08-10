import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/intake/offence_category_dto.dart';
import '../../../model/intake/offence_schedule_dto.dart';
import '../../../model/intake/offence_type_dto.dart';
import '../../../model/pcm/accepted_worklist_dto.dart';
import '../../../model/pcm/offence_detail_dto.dart';
import '../../../model/static_model/yes_no_dto.dart';
import '../../../navigation_drawer/go_to_assessment_drawer.dart';
import '../../../service/intake/offence_service.dart';
import '../../../service/pcm/offence_detail_service.dart';
import '../../../transform_dynamic/transform_offence.dart';
import '../../../util/shared/apierror.dart';
import '../../../util/shared/apiresponse.dart';
import '../../../util/shared/apiresults.dart';
import '../../../util/shared/loading_overlay.dart';
import '../../../util/shared/randon_generator.dart';
import '../../probation_officer/accepted_worklist.dart';
import 'socio_economic.dart';
import 'victim_detail.dart';

class OffenceDetailPage extends StatefulWidget {
  const OffenceDetailPage({Key? key}) : super(key: key);

  @override
  State<OffenceDetailPage> createState() => _OffenceDetailPageState();
}

class _OffenceDetailPageState extends State<OffenceDetailPage> {
  SharedPreferences? preferences;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _loginFormKey = GlobalKey<FormState>();

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _randomGenerator = RandomGenerator();
  final _offenceTransform = OffenceTransform();
  final OffenceService offenceServiceClient = OffenceService();
  final OffenceDetailService offenceDetailServiceClient =
      OffenceDetailService();
  late AcceptedWorklistDto acceptedWorklistDto = AcceptedWorklistDto();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResults apiResults = ApiResults();
  late List<OffenceTypeDto> offenceTypesDto = [];
  late List<OffenceCategoryDto> offenceCategoriesDto = [];
  late List<OffenceScheduleDto> offenceSchedulesDto = [];
  late List<YesNoDto> yesNoDtoItemsDto = [];
  late List<OffenceDetailDto> offenceDetailsDto = [];

  ExpandableController captureOffenceDetailPanelController =
      ExpandableController();
  ExpandableController viewOffenceDetailPanelController =
      ExpandableController();
  final TextEditingController offenceCircumstanceController =
      TextEditingController();
  final TextEditingController valueOfGoodsController = TextEditingController();
  final TextEditingController valueRecoveredController =
      TextEditingController();
  final TextEditingController responsibilityDetailsController =
      TextEditingController();
  String? childResponsibleDropdownButtonFormField;
  int? offenceTypeDropdownButtonFormField;
  int? offenceCategoryDropdownButtonFormField;
  int? offenceScheduleDropdownButtonFormField;
  int? offenceDetailId;
  String? labelButtonAddUpdate = '';

  @override
  void initState() {
    super.initState();
    captureOffenceDetailPanelController =
        ExpandableController(initialExpanded: false);
    viewOffenceDetailPanelController =
        ExpandableController(initialExpanded: true);
    labelButtonAddUpdate = 'Add Offence';
    offenceDetailId = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        setState(() {
          acceptedWorklistDto =
              ModalRoute.of(context)!.settings.arguments as AcceptedWorklistDto;
          loadOffenceTransformer();
          loadOffenceDetailsByIntakeAssessmentId(
              acceptedWorklistDto.intakeAssessmentId);
        });
      });
    });
  }

  loadOffenceTransformer() async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    offenceTypesDto = await _offenceTransform.transformOffenceTypeDto();
    offenceCategoriesDto =
        await _offenceTransform.transformOffenceCategoryDto();
    offenceSchedulesDto = await _offenceTransform.transformOffenceScheduleDto();
    yesNoDtoItemsDto.add(YesNoDto(value: 'Yes', description: 'Yes'));
    yesNoDtoItemsDto.add(YesNoDto(value: 'No', description: 'No'));
    overlay.hide();
  }

  loadOffenceDetailsByIntakeAssessmentId(int? intakeAssessmentId) async {
    final overlay = LoadingOverlay.of(context);
    overlay.show();
    apiResponse = await offenceDetailServiceClient
        .getOffenceDetailIntakeAssessmentId(intakeAssessmentId);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      setState(() {
        offenceDetailsDto = (apiResponse.Data as List<OffenceDetailDto>);
      });
    } else {
      overlay.hide();
      showDialogMessage((apiResponse.ApiError as ApiError));
    }
  }

  addUpdateOffenceDetails() async {
    OffenceDetailDto addOffenceDetailDto = OffenceDetailDto(
        pcmOffenceId:
            offenceDetailId ?? _randomGenerator.getRandomGeneratedNumber(),
        pcmCaseId: acceptedWorklistDto.caseId,
        intakeAssessmentId: acceptedWorklistDto.intakeAssessmentId,
        createdBy: preferences!.getInt('userId')!,
        dateCreated: _randomGenerator.getCurrentDateGenerated(),
        offenceTypeId: offenceTypeDropdownButtonFormField,
        offenceTypeDto: offenceTypeDropdownButtonFormField != null
            ? offenceTypesDto
                .where((o) =>
                    o.offenceTypeId == offenceTypeDropdownButtonFormField)
                .single
            : null,
        offenceCategoryId: offenceCategoryDropdownButtonFormField,
        offenceCategoryDto: offenceCategoryDropdownButtonFormField != null
            ? offenceCategoriesDto
                .where((o) =>
                    o.offenceCategoryId ==
                    offenceCategoryDropdownButtonFormField)
                .single
            : null,
        offenceScheduleId: offenceScheduleDropdownButtonFormField,
        offenceScheduleDto: offenceScheduleDropdownButtonFormField != null
            ? offenceSchedulesDto
                .where((o) =>
                    o.offenceScheduleId ==
                    offenceScheduleDropdownButtonFormField)
                .single
            : null,
        offenceCircumstance: offenceCircumstanceController.text,
        valueOfGoods: valueOfGoodsController.text,
        valueRecovered: valueRecoveredController.text,
        isChildResponsible: childResponsibleDropdownButtonFormField,
        responsibilityDetails: responsibilityDetailsController.text);

    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();
    apiResponse = await offenceDetailServiceClient
        .addUpdateOffenceDetail(addOffenceDetailDto);
    if ((apiResponse.ApiError) == null) {
      overlay.hide();
      showSuccessMessage('Successfully $labelButtonAddUpdate.');
      navigator.push(
        MaterialPageRoute(
            builder: (context) => const OffenceDetailPage(),
            settings: RouteSettings(
              arguments: acceptedWorklistDto,
            )),
      );
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

  populateOffenceDetailForm(OffenceDetailDto offenceDetailDto) {
    setState(() {
      offenceDetailId = offenceDetailDto.pcmOffenceId;
      captureOffenceDetailPanelController =
          ExpandableController(initialExpanded: true);
      viewOffenceDetailPanelController =
          ExpandableController(initialExpanded: false);
      labelButtonAddUpdate = 'Update Offence';
      valueOfGoodsController.text = offenceDetailDto.valueOfGoods!;
      valueRecoveredController.text = offenceDetailDto.valueRecovered!;
      responsibilityDetailsController.text =
          offenceDetailDto.responsibilityDetails!;

      childResponsibleDropdownButtonFormField =
          (offenceDetailDto.isChildResponsible != null
              ? yesNoDtoItemsDto
                  .where((o) =>
                      o.value ==
                      offenceDetailDto.isChildResponsible
                          .toString()
                          .replaceAll(' ', ''))
                  .single
                  .value
                  .toString()
              : null)!;
      // childResponsibleDropdownButtonFormField =
      //    offenceDetailDto.isChildResponsible!;
      offenceTypeDropdownButtonFormField = offenceDetailDto.offenceTypeId!;
      offenceCategoryDropdownButtonFormField =
          offenceDetailDto.offenceCategoryId;
      offenceScheduleDropdownButtonFormField =
          offenceDetailDto.offenceScheduleId;
    });
  }

  newOffenceDetail() {
    setState(() {
      labelButtonAddUpdate = 'Add Offence';
      valueOfGoodsController.clear();
      valueRecoveredController.clear();
      responsibilityDetailsController.clear();
      childResponsibleDropdownButtonFormField = null;
      offenceTypeDropdownButtonFormField = null;
      offenceCategoryDropdownButtonFormField = null;
      offenceScheduleDropdownButtonFormField = null;
      offenceDetailId = null;
    });
  }

  @override
  void dispose() {
    valueOfGoodsController.dispose();
    valueRecoveredController.dispose();
    responsibilityDetailsController.dispose();
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
              title: const Text("Offence Details"),
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
                            builder: (context) => const SocioEconomicPage(),
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
                            builder: (context) => const VictimDetailPage(),
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
                                        captureOffenceDetailPanelController,
                                    theme: const ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.center,
                                      tapBodyToCollapse: true,
                                    ),
                                    header: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Capture Offence Detail",
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
                                                        newOffenceDetail();
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
                                                          offenceCategoryDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Offence Category',
                                                        labelText:
                                                            'Offence Category',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items:
                                                          offenceCategoriesDto
                                                              .map((category) {
                                                        return DropdownMenuItem(
                                                            value: category
                                                                .offenceCategoryId,
                                                            child: Text(category
                                                                .description
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        offenceCategoryDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Offence Category Required';
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          offenceScheduleDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Offence Schedule',
                                                        labelText:
                                                            'Offence Schedule',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      items: offenceSchedulesDto
                                                          .map((schedule) {
                                                        return DropdownMenuItem(
                                                            value: schedule
                                                                .offenceScheduleId,
                                                            child: Text(schedule
                                                                .description
                                                                .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        offenceScheduleDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Offence Schedule Required';
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child:
                                                        DropdownButtonFormField(
                                                      //menuMaxHeight: 800,
                                                      //itemHeight: 300,
                                                      value:
                                                          offenceTypeDropdownButtonFormField,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Offence Type',
                                                        labelText:
                                                            'Offence Type',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                      isDense: true,
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                      ),
                                                      isExpanded: true,
                                                      items: offenceTypesDto
                                                          .map((offenceType) {
                                                        return DropdownMenuItem(
                                                            value: offenceType
                                                                .offenceTypeId,
                                                            child: Text(
                                                                offenceType
                                                                    .description
                                                                    .toString()));
                                                      }).toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        offenceTypeDropdownButtonFormField =
                                                            selectedValue;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return 'Offence Type Required';
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
                                                child: TextFormField(
                                                  controller:
                                                      offenceCircumstanceController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Offence Circumstance',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Offence Circumstance Required';
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
                                                child: TextFormField(
                                                  controller:
                                                      valueOfGoodsController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Value Of Goods',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Value Of Goods Required';
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
                                                child: TextFormField(
                                                  controller:
                                                      valueRecoveredController,
                                                  maxLines: 1,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Value Recovered',
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Value Recovered Required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          Expanded(
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child:
                                                      DropdownButtonFormField(
                                                    value:
                                                        childResponsibleDropdownButtonFormField,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Child Responsible',
                                                      labelText:
                                                          'Child Responsible',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                    items: yesNoDtoItemsDto
                                                        .map((yesNo) {
                                                      return DropdownMenuItem(
                                                          value: yesNo.value,
                                                          child: Text(yesNo
                                                              .description
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (selectedValue) {
                                                      childResponsibleDropdownButtonFormField =
                                                          selectedValue;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Offence Type Required';
                                                      }
                                                      return null;
                                                    },
                                                  ))),
                                        ]),
                                        Row(children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller:
                                                    responsibilityDetailsController,
                                                maxLines: 1,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      'Responsibility Details',
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Responsibility Required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          )
                                        ]),
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
                                                          addUpdateOffenceDetails();
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
                                          "View Offence Details",
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
                                        if (offenceDetailsDto.isNotEmpty)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      offenceDetailsDto.length,
                                                  itemBuilder:
                                                      (context, int index) {
                                                    if (offenceDetailsDto
                                                        .isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              'No offence category Found.'));
                                                    }
                                                    return ListTile(
                                                      title: Text(
                                                          'Category : ${offenceDetailsDto[index].offenceCategoryDto?.description ?? ''}',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      subtitle: Text(
                                                          'Type : ${offenceDetailsDto[index].offenceTypeDto?.description ?? ''} '
                                                          'Responsibility details : ${offenceDetailsDto[index].responsibilityDetails ?? ''} '
                                                          'Value of goods : ${offenceDetailsDto[index].valueOfGoods ?? ''}.'
                                                          'Value Recoverd ${offenceDetailsDto[index].valueRecovered ?? ''}',
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
                                                                populateOffenceDetailForm(
                                                                    offenceDetailsDto[
                                                                        index]);
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
