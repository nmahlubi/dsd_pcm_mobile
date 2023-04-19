import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../model/pcm/query/co_accused_details_query_dto.dart';

class CoAccusedDetailsPanel extends StatelessWidget {
  final List<CoAccusedDetailsQueryDto>? coAccusedDetailsQueryDto;
  const CoAccusedDetailsPanel({super.key, this.coAccusedDetailsQueryDto});

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
                      "Co Accused Details",
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
                    if (coAccusedDetailsQueryDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: coAccusedDetailsQueryDto!.length,
                              itemBuilder: (context, int index) {
                                if (coAccusedDetailsQueryDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Accused Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Name : ${coAccusedDetailsQueryDto![index].coAccusedFullName}'),
                                    subtitle: Text(
                                        'DOB : ${coAccusedDetailsQueryDto![index].dateOfBirth}',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: const Icon(
                                        Icons.folder_open_outlined,
                                        color: Colors.orange));
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
