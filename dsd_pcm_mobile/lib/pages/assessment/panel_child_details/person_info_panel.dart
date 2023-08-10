import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../model/intake/language_dto.dart';
import '../../../model/intake/nationality_dto.dart';
import '../../../model/intake/person_dto.dart';

class PersonInfoPanel extends StatelessWidget {
  final PersonDto? personDto;
  final NationalityDto? nationalityDto;
  final LanguageDto? languageDto;
  const PersonInfoPanel(
      {super.key, this.personDto, this.nationalityDto, this.languageDto});

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
                      "Child's Details",
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.firstName),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.lastName.toString()),
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
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.dateOfBirth),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Alias',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: languageDto?.description),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Language',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 1,
                        controller: TextEditingController(
                            text: personDto!.identificationNumber),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Identity Number',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.dateOfBirth),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date Of Birth',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: nationalityDto!.description),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nationality',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 1,
                        controller: TextEditingController(
                            text: personDto!.emailAddress),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Street Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 1,
                        controller: TextEditingController(
                            text: personDto!.emailAddress),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Town',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.lastName.toString()),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'City',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: personDto!.lastName.toString()),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Postal Code',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: childInformationDto!.personDateOfBirth),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date Of Birth',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: childInformationDto!.personAge
                                      .toString()),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        
                        maxLines: 1,
                        controller: TextEditingController(
                            text: childInformationDto!.personIDNumber),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Identity Number',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        
                        maxLines: 1,
                        controller: TextEditingController(
                            text: countryDto!.countryName),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Identity Country',
                        ),
                      ),
                    ),*/
                    /*Row(
                      children: [
                       Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: genderDto!.personGender),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Gender',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: raceDto!.raceType),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Race',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: languageDto!.personLanguage),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Language',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),*/
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
