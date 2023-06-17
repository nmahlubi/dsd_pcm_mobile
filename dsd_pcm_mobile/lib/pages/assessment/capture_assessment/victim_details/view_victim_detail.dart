import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/victim_detail_dto.dart';

class ViewVictimDetailPage extends StatelessWidget {
  final List<VictimDetailDto>? victimDetailsDto;
  const ViewVictimDetailPage({super.key, this.victimDetailsDto});

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
                      "View Individual Victims Details",
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
                    if (victimDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: victimDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (victimDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Victim Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Victim Name : ${victimDetailsDto![index].personDto?.firstName} ${victimDetailsDto![index].personDto?.lastName}'),
                                    subtitle: Text(
                                        'Occupation : ${victimDetailsDto![index].victimOccupation}.'
                                        ' Address : ${victimDetailsDto![index].addressLine1} ${victimDetailsDto![index].addressLine2} ${victimDetailsDto![index].postalCode}',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: const Icon(Icons.edit,
                                        color: Colors.green));
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(thickness: 1);
                              },
                            ),
                          ),
                        ],
                      )
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
