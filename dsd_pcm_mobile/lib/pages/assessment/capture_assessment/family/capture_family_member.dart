import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/relationship_type_dto.dart';

class CaptureFamilyMemberPage extends StatelessWidget {
  final addNewFamilyMember;

  final List<Map<String, dynamic>>? genderItemsDto;
  final List<Map<String, dynamic>>? relationshipTypeItemsDto;
  CaptureFamilyMemberPage(
      {super.key,
      this.genderItemsDto,
      this.relationshipTypeItemsDto,
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
                            child: DropdownFormField<Map<String, dynamic>>(
                              controller: genderController,
                              onEmptyActionPressed: () async {},
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  labelText: "Select Gender"),
                              onSaved: (dynamic str) {},
                              onChanged: (dynamic str) {},
                              //validator: (dynamic str) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select Gender';
                                }
                                return null;
                              },
                              displayItemFn: (dynamic item) => Text(
                                (item ?? {})['description'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              findFn: (dynamic str) async => genderItemsDto!,
                              selectedFn: (dynamic item1, dynamic item2) {
                                if (item1 != null && item2 != null) {
                                  return item1['description'] ==
                                      item2['description'];
                                }
                                return false;
                              },
                              filterFn: (dynamic item, str) =>
                                  item['description']
                                      .toLowerCase()
                                      .indexOf(str.toLowerCase()) >=
                                  0,
                              dropdownItemFn: (dynamic item,
                                      int position,
                                      bool focused,
                                      bool selected,
                                      Function() onTap) =>
                                  ListTile(
                                subtitle: Text(
                                  item['description'] ?? '',
                                ),
                                tileColor: focused
                                    ? const Color.fromARGB(20, 0, 0, 0)
                                    : Colors.transparent,
                                onTap: onTap,
                              ),
                            ),
                          ),
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
                            child: DropdownFormField<Map<String, dynamic>>(
                              controller: relationshipTypeController,
                              onEmptyActionPressed: () async {},
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  labelText: "Select Relationship Type"),
                              onSaved: (dynamic str) {},
                              onChanged: (dynamic str) {},
                              //validator: (dynamic str) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select Relattionship Type';
                                }
                                return null;
                              },
                              displayItemFn: (dynamic item) => Text(
                                (item ?? {})['description'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              findFn: (dynamic str) async =>
                                  relationshipTypeItemsDto!,
                              selectedFn: (dynamic item1, dynamic item2) {
                                if (item1 != null && item2 != null) {
                                  return item1['description'] ==
                                      item2['description'];
                                }
                                return false;
                              },
                              filterFn: (dynamic item, str) =>
                                  item['description']
                                      .toLowerCase()
                                      .indexOf(str.toLowerCase()) >=
                                  0,
                              dropdownItemFn: (dynamic item,
                                      int position,
                                      bool focused,
                                      bool selected,
                                      Function() onTap) =>
                                  ListTile(
                                subtitle: Text(
                                  item['description'] ?? '',
                                ),
                                tileColor: focused
                                    ? const Color.fromARGB(20, 0, 0, 0)
                                    : Colors.transparent,
                                onTap: onTap,
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
                                    addNewFamilyMember(
                                        nameController.text.toString(),
                                        surnameController.text.toString(),
                                        int.parse(ageController.text),
                                        genderController!.value.toString(),
                                        relationshipTypeController!.value
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
