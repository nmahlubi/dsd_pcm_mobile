import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/care_giver_details_dto.dart';

class ViewCareGiverDetailPage extends StatelessWidget {
  final List<CareGiverDetailsDto>? careGiverDetailsDto;
  const ViewCareGiverDetailPage({super.key, this.careGiverDetailsDto});

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
                      "View Care Giver Details",
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
                    if (careGiverDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: careGiverDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (careGiverDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Accused Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Name : ${careGiverDetailsDto![index].personDto!.firstName ?? ''} '
                                        ' ${careGiverDetailsDto![index].personDto!.lastName ?? ''}'),
                                    subtitle: Text(
                                        'Identity Number : ${careGiverDetailsDto![index].personDto!.identificationNumber ?? ''} ',
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
