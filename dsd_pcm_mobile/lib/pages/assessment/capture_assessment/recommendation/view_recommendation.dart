import 'package:dsd_pcm_mobile/model/pcm/recommendations_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ViewRecommendation extends StatelessWidget {
  final List<RecommendationDto>? recommendationsDto;
  const ViewRecommendation({super.key, this.recommendationsDto});

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
                      "Recommendation Details",
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
                    if (recommendationsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: recommendationsDto!.length,
                              itemBuilder: (context, int index) {
                                if (recommendationsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No recommendations.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Type : ${recommendationsDto![index].recommendationTypeDto?.description ?? ''}'),
                                    subtitle: Text(
                                        'Placement Type ${recommendationsDto![index].placementTypeDto?.description ?? ''}'
                                        'Comments  :  ${recommendationsDto![index].commentsForRecommendation ?? ''}',
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
