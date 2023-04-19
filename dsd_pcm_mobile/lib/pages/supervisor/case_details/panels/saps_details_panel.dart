import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/child_notification/case_information_dto.dart';
import '../../../../model/child_notification/police_station_dto.dart';

class SapsDetailsPanel extends StatelessWidget {
  final CaseInformationDto? caseInformationDto;
  final PoliceStationDto? policeStationDto;
  const SapsDetailsPanel(
      {super.key, this.caseInformationDto, this.policeStationDto});

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
                      "SAPS Details",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                collapsed: const Text(
                  '',
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        maxLines: 1,
                        controller: TextEditingController(
                            text: caseInformationDto!.casNumber),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Case Number',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              controller: TextEditingController(
                                  text:
                                      caseInformationDto!.notificationDateSet),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Notify Date',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: policeStationDto!.policeStationName),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Police Station',
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
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: caseInformationDto!.arrestDateFormat),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Arrest Date',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              controller: TextEditingController(
                                  text: caseInformationDto!.arrestTime),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Arrest Time',
                              ),
                            ),
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
