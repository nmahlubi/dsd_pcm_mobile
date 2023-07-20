import 'package:dsd_pcm_mobile/model/child_notification/language_dto.dart';
import 'package:dsd_pcm_mobile/model/child_notification/race_dto.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/child_notification/child_information_dto.dart';
import '../../../../model/child_notification/country_dto.dart';
import '../../../../model/child_notification/gender_dto.dart';

class ChildDetailsPanel extends StatelessWidget {
  final ChildInformationDto? childInformationDto;
  final GenderDto? genderDto;
  final CountryDto? countryDto;
  final RaceDto? raceDto;
  final LanguageDto? languageDto;
  const ChildDetailsPanel(
      {super.key,
      this.childInformationDto,
      this.genderDto,
      this.countryDto,
      this.raceDto,
      this.languageDto});

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
                      "Child Details",
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
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        readOnly: true,
                        enabled: true,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        controller: TextEditingController(
                            text: childInformationDto!
                                .personFingerprintReference),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Finger Print',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              readOnly: true,
                              enabled: true,
                              enableInteractiveSelection: false,
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
                              readOnly: true,
                              enabled: true,
                              enableInteractiveSelection: false,
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
                        readOnly: true,
                        enabled: true,
                        enableInteractiveSelection: false,
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
                        readOnly: true,
                        enabled: true,
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        controller: TextEditingController(
                            text: countryDto!.countryName),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Identity Country',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              readOnly: true,
                              enabled: true,
                              enableInteractiveSelection: false,
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
                              readOnly: true,
                              enabled: true,
                              enableInteractiveSelection: false,
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
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              readOnly: true,
                              enabled: true,
                              enableInteractiveSelection: false,
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
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
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
