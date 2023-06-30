import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/general_detail_dto.dart';

class ViewGeneralDetailPage extends StatelessWidget {
  final List<GeneralDetailDto>? generalDetailsDto;
  const ViewGeneralDetailPage({super.key, this.generalDetailsDto});

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
                      "View General Details",
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
                    if (generalDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: generalDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (generalDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Comments Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'Date : ${generalDetailsDto![index].dateCreated}'),
                                  subtitle: Text(
                                      'Consulted Sources : ${generalDetailsDto![index].consultedSources}. '
                                      'Trace Efforts : ${generalDetailsDto![index].traceEfforts}. '
                                      'Supervisor Comments : ${generalDetailsDto![index].commentsBySupervisor}. '
                                      'Addional Information : ${generalDetailsDto![index].additionalInfo}',
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
