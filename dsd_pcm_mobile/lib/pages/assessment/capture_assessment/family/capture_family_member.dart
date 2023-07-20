import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';

import '../../../../model/intake/gender_dto.dart';
import '../../../../model/intake/relationship_type_dto.dart';

// ignore: must_be_immutable
class CaptureFamilyMemberPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final addNewFamilyMember;
  final List<GenderDto> gendersDto;
  final List<RelationshipTypeDto> relationshipTypesDto;

  CaptureFamilyMemberPage(
      {super.key,
      required this.gendersDto,
      required this.relationshipTypesDto,
      this.addNewFamilyMember});
//controls
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  int? genderDropdownButtonFormField;
  int? relationshipTypeDropdownButtonFormField;

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
                              controller: dateOfBirthController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date Of Birth',
                              ),
                              readOnly: true, // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  dateOfBirthController.text = formattedDate;
                                  //You can format date as per your need

                                }
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
                            child: TextFormField(
                              controller: ageController,
                              enableInteractiveSelection: false,
                              keyboardType: TextInputType.number,
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
                                      child:
                                          Text(gender.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  genderDropdownButtonFormField = selectedValue;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Gender is required';
                                  }
                                },
                              )),
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
                                child: DropdownButtonFormField(
                                  value:
                                      relationshipTypeDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Relationship Type',
                                    labelText: 'Relationship Type',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  items:
                                      relationshipTypesDto.map((relationship) {
                                    return DropdownMenuItem(
                                        value: relationship.relationshipTypeId,
                                        child: Text(relationship.description
                                            .toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    relationshipTypeDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Relationship Type is required';
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
                                    addNewFamilyMember(
                                        nameController.text.toString(),
                                        surnameController.text.toString(),
                                        dateOfBirthController.text.toString(),
                                        int.parse(ageController.text),
                                        genderDropdownButtonFormField,
                                        relationshipTypeDropdownButtonFormField);
                                  },
                                  child: const Text('Add Member'),
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
