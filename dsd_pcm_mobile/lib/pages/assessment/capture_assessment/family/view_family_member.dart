import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/family_member_dto.dart';

class ViewFamilyMemberPage extends StatelessWidget {
  final List<FamilyMemberDto>? familyMembersDto;
  const ViewFamilyMemberPage({super.key, this.familyMembersDto});

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
                      "View Family Members",
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
                    if (familyMembersDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: familyMembersDto!.length,
                              itemBuilder: (context, int index) {
                                if (familyMembersDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Family Member Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Name : ${familyMembersDto![index].personDto?.firstName} ${familyMembersDto![index].personDto?.lastName}'),
                                    subtitle: Text(
                                        'Relationship : ${familyMembersDto![index].relationshipTypeDto?.description}.',
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
