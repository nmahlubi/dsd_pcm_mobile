import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/family_information_dto.dart';

class ViewFamilyInformationPage extends StatelessWidget {
  final List<FamilyInformationDto>? familyInformationsDto;
  const ViewFamilyInformationPage({super.key, this.familyInformationsDto});

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
                      "View Family Information",
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
                    if (familyInformationsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: familyInformationsDto!.length,
                              itemBuilder: (context, int index) {
                                if (familyInformationsDto!.isEmpty) {
                                  return const Center(
                                      child:
                                          Text('No Family Information Found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Date : ${familyInformationsDto![index].dateCreated}.'),
                                    subtitle: Text(
                                        'Information : ${familyInformationsDto![index].familyBackground}.',
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
