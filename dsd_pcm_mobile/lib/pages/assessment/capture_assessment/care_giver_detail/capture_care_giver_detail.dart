import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dsd_pcm_mobile/model/static_model/yes_no_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/offence_category_dto.dart';
import '../../../../model/intake/offence_schedule_dto.dart';
import '../../../../model/intake/offence_type_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../widgets/dropdown_widget.dart';

class CaptureCareGiverDetailPage extends StatelessWidget {
  final addNewCareGiverDetail;

  final List<Map<String, dynamic>> genderItemsDto;
  final List<Map<String, dynamic>> relationshipTypeItemsDto;
  CaptureCareGiverDetailPage(
      {super.key,
      required this.genderItemsDto,
      required this.relationshipTypeItemsDto,
      this.addNewCareGiverDetail});
//controls

  final DropdownEditingController<Map<String, dynamic>>? genderController =
      DropdownEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      relationshipTypeController = DropdownEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController identityNumberController =
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
                      "Capture Care Giver Detail",
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
                        'Care Giver Detail',
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
                                        relationshipTypeController,
                                    labelTextValue: 'Relationship Type',
                                    displayItemFnValue: 'description',
                                    itemsCollection: relationshipTypeItemsDto,
                                    selectedFnValue: 'relationshipTypeId',
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
                                    dropdownEditingName: genderController,
                                    labelTextValue: 'Gender',
                                    displayItemFnValue: 'description',
                                    itemsCollection: genderItemsDto,
                                    selectedFnValue: 'genderId',
                                    filterFnValue: 'description',
                                    titleValue: 'description',
                                    subtitleValue: ''))),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                        )),
                      ],
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
                                labelText: 'Lastname',
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
                              controller: identityNumberController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Identity Number',
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
                                    addNewCareGiverDetail(
                                        RelationshipTypeDto.fromJson(
                                            relationshipTypeController!.value),
                                        GenderDto.fromJson(
                                            genderController!.value),
                                        firstNameController.text.toString(),
                                        lastNameController.text.toString(),
                                        identityNumberController.text
                                            .toString());
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
