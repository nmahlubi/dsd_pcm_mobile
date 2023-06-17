import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/socio_economic_dto.dart';

class ViewSocioEconomicPage extends StatelessWidget {
  final List<SocioEconomicDto>? socioEconomicsDto;
  const ViewSocioEconomicPage({super.key, this.socioEconomicsDto});

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
                      "View Socio Economics",
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
                    if (socioEconomicsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: socioEconomicsDto!.length,
                              itemBuilder: (context, int index) {
                                if (socioEconomicsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Socio Economic Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'Date : ${socioEconomicsDto![index].dateCreated}'),
                                  subtitle: Text(
                                      'Family Background Comments - ${socioEconomicsDto![index].familyBackgroundComment}. '
                                      'Finance Work Record - ${socioEconomicsDto![index].financeWorkRecord}. '
                                      'Peer Presure - ${socioEconomicsDto![index].peerPresure}. '
                                      'Religious Involve - ${socioEconomicsDto![index].religiousInvolve}. '
                                      'Substance Abuse - ${socioEconomicsDto![index].substanceAbuse}.',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                );
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
