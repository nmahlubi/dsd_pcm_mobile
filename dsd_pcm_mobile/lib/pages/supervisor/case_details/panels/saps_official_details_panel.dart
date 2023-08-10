import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/child_notification/saps_info_dto.dart';

class SapsOfficialDetailsPanel extends StatelessWidget {
  final SapsInfoDto? sapsInfoDto;
  const SapsOfficialDetailsPanel({super.key, this.sapsInfoDto});

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
                      "SAPS Official Details",
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
                        maxLines: 1,
                        controller: TextEditingController(
                            text: sapsInfoDto!.policeFullName),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Police Officer Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 1,
                        controller: TextEditingController(
                            text: sapsInfoDto!.contactDetailsText),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contact Number',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 1,
                        controller: TextEditingController(
                            text: sapsInfoDto!.policeUnitName),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Unit Name',
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
                                  text: sapsInfoDto!.componentCode),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Component Code',
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
