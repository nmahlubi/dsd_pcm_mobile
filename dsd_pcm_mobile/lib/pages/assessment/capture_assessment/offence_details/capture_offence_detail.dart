import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dsd_pcm_mobile/model/static_model/yes_no_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../../model/intake/offence_category_dto.dart';
import '../../../../model/intake/offence_schedule_dto.dart';
import '../../../../model/intake/offence_type_dto.dart';
import '../../../../widgets/dropdown_widget.dart';

class CaptureOffenceDetailPage extends StatelessWidget {
  final addNewOffenceDetail;

  final List<Map<String, dynamic>> yesNoDtoItemsDto;
  final List<Map<String, dynamic>> offenceTypeItemsDto;
  final List<Map<String, dynamic>> offenceCategoryItemsDto;
  final List<Map<String, dynamic>> offenceScheduleItemsDto;

  CaptureOffenceDetailPage(
      {super.key,
      required this.yesNoDtoItemsDto,
      required this.offenceTypeItemsDto,
      required this.offenceCategoryItemsDto,
      required this.offenceScheduleItemsDto,
      this.addNewOffenceDetail});
//controls
  final DropdownEditingController<Map<String, dynamic>>? offenceTypeController =
      DropdownEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      offenceCategoryController = DropdownEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      offenceScheduleController = DropdownEditingController();
  final TextEditingController offenceCircumstanceController =
      TextEditingController();
  final TextEditingController valueOfGoodsController = TextEditingController();
  final TextEditingController valueRecoveredController =
      TextEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      isChildResponsibleController = DropdownEditingController();
  final TextEditingController responsibilityDetailsController =
      TextEditingController();

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
                                child: dynamicDropdownWidget(
                                    dropdownEditingName:
                                        offenceCategoryController,
                                    labelTextValue: 'Offence Category',
                                    displayItemFnValue: 'description',
                                    itemsCollection: offenceCategoryItemsDto,
                                    selectedFnValue: 'offenceCategoryId',
                                    filterFnValue: 'description',
                                    titleValue: 'description',
                                    subtitleValue: ''))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: dynamicDropdownWidget(
                                    dropdownEditingName:
                                        offenceScheduleController,
                                    labelTextValue: 'Offence Schedule',
                                    displayItemFnValue: 'description',
                                    itemsCollection: offenceScheduleItemsDto,
                                    selectedFnValue: 'offenceScheduleId',
                                    filterFnValue: 'description',
                                    titleValue: 'description',
                                    subtitleValue: ''))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: dynamicDropdownWidget(
                                    dropdownEditingName: offenceTypeController,
                                    labelTextValue: 'Offence Type',
                                    displayItemFnValue: 'description',
                                    itemsCollection: offenceTypeItemsDto,
                                    selectedFnValue: 'offenceTypeId',
                                    filterFnValue: 'description',
                                    titleValue: 'description',
                                    subtitleValue: ''))),
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
                              child: dynamicDropdownWidget(
                                  dropdownEditingName:
                                      isChildResponsibleController,
                                  labelTextValue: 'Child Responsible',
                                  displayItemFnValue: 'description',
                                  itemsCollection: yesNoDtoItemsDto,
                                  selectedFnValue: 'value',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: ''))),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                        ),
                      )
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
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        Expanded(
                            child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                child: ElevatedButton(
                                  child: const Text('Add'),
                                  onPressed: () {
                                    addNewOffenceDetail(
                                      OffenceTypeDto.fromJson(
                                          offenceTypeController!.value),
                                      OffenceCategoryDto.fromJson(
                                          offenceCategoryController!.value),
                                      OffenceScheduleDto.fromJson(
                                          offenceScheduleController!.value),
                                      offenceCircumstanceController.text
                                          .toString(),
                                      valueOfGoodsController.text.toString(),
                                      valueRecoveredController.text.toString(),
                                      YesNoDto.fromJson(
                                          isChildResponsibleController!.value),
                                      responsibilityDetailsController.text
                                          .toString(),
                                    );
                                  },
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
