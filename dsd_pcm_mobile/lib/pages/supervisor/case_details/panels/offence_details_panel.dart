import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/child_notification/offence_type_dto.dart';

class OffenceDetailsPanel extends StatelessWidget {
  final OffenseTypeDto? offenseTypeDto;
  const OffenceDetailsPanel({super.key, this.offenseTypeDto});

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
                      "Offence Details",
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
                        maxLines: 1,
                        controller: TextEditingController(
                            text: offenseTypeDto!.offenseCode),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Offence Code',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 4,
                        controller: TextEditingController(
                            text: offenseTypeDto!.offenseDescription),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Offence Description',
                        ),
                      ),
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
