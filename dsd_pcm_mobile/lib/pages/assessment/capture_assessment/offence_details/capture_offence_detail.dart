import 'package:dsd_pcm_mobile/model/static_model/yes_no_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../../model/intake/offence_category_dto.dart';
import '../../../../model/intake/offence_schedule_dto.dart';
import '../../../../model/intake/offence_type_dto.dart';

// ignore: must_be_immutable
class CaptureOffenceDetailPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final addNewOffenceDetail;

  final List<YesNoDto> yesNoDtoItemsDto;
  final List<OffenceTypeDto> offenceTypesDto;
  final List<OffenceCategoryDto> offenceCategoriesDto;
  final List<OffenceScheduleDto> offenceSchedulesDto;

  CaptureOffenceDetailPage(
      {super.key,
      required this.yesNoDtoItemsDto,
      required this.offenceTypesDto,
      required this.offenceCategoriesDto,
      required this.offenceSchedulesDto,
      this.addNewOffenceDetail});
//controls

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

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
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
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Capture Offence Detail",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                collapsed: const Text(
                  '',
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Offence Detail',
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
                                  value: offenceCategoryDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Offence Category',
                                    labelText: 'Offence Category',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  items: offenceCategoriesDto.map((category) {
                                    return DropdownMenuItem(
                                        value: category.offenceCategoryId,
                                        child: Text(
                                            category.description.toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    offenceCategoryDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Offence category is required';
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
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  value: offenceScheduleDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Offence Schedule',
                                    labelText: 'Offence Schedule',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  items: offenceSchedulesDto.map((schedule) {
                                    return DropdownMenuItem(
                                        value: schedule.offenceScheduleId,
                                        child: Text(
                                            schedule.description.toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    offenceScheduleDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Offence schedule is required';
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
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  //menuMaxHeight: 800,
                                  //itemHeight: 300,
                                  value: offenceTypeDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Offence Type',
                                    labelText: 'Offence Type',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  isDense: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  isExpanded: true,
                                  items: offenceTypesDto.map((offenceType) {
                                    return DropdownMenuItem(
                                        value: offenceType.offenceTypeId,
                                        child: Text(offenceType.description
                                            .toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    offenceTypeDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Offence type is required';
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
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: offenceCircumstanceController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Offence Circumstance',
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
                              controller: valueOfGoodsController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Value Of Goods',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: valueRecoveredController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Value Recoved',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                value: childResponsibleDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'Child Responsible',
                                  labelText: 'Child Responsible',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: yesNoDtoItemsDto.map((yesNo) {
                                  return DropdownMenuItem(
                                      value: yesNo.value,
                                      child:
                                          Text(yesNo.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  childResponsibleDropdownButtonFormField =
                                      selectedValue;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Offence type is required';
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
                            controller: responsibilityDetailsController,
                            enableInteractiveSelection: false,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Responsibility Details',
                            ),
                          ),
                        ),
                      )
                    ]),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 70,
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
                        )),
                        Expanded(
                            child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 23, 22, 22),
                                    shape: const StadiumBorder(),
                                    side: const BorderSide(
                                        width: 2, color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    addNewOffenceDetail(
                                      offenceTypeDropdownButtonFormField,
                                      offenceCategoryDropdownButtonFormField,
                                      offenceScheduleDropdownButtonFormField,
                                      offenceCircumstanceController.text
                                          .toString(),
                                      valueOfGoodsController.text.toString(),
                                      valueRecoveredController.text.toString(),
                                      childResponsibleDropdownButtonFormField,
                                      responsibilityDetailsController.text
                                          .toString(),
                                    );
                                  },
                                  child: const Text('Add Offence'),
                                ))),
                      ],
                    ),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
