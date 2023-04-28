import 'package:dropdown_plus/dropdown_plus.dart';

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';
import '../../../../widgets/dropdown_widget.dart';

class CaptureFamilyMemberPage extends StatelessWidget {
  final addNewFamilyMember;

  final List<Map<String, dynamic>> genderItemsDto;
  final List<Map<String, dynamic>> relationshipTypeItemsDto;
  CaptureFamilyMemberPage(
      {super.key,
      required this.genderItemsDto,
      required this.relationshipTypeItemsDto,
      this.addNewFamilyMember});
//controls
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final DropdownEditingController<Map<String, dynamic>>? genderController =
      DropdownEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      relationshipTypeController = DropdownEditingController();

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
                      "Capture Family Member",
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
                        'Member Details',
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
                              controller: nameController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: surnameController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Surname',
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
                              controller: ageController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                              ),
                            ),
                          ),
                        ),
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
                                  subtitleValue: '')),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Relationship',
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
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                        ))
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
                                    addNewFamilyMember(
                                        nameController.text.toString(),
                                        surnameController.text.toString(),
                                        int.parse(ageController.text),
                                        GenderDto.fromJson(
                                            genderController!.value),
                                        RelationshipTypeDto.fromJson(
                                            relationshipTypeController!.value));
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
