import 'package:dsd_pcm_mobile/model/pcm/family_information_dto.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class FamilyInfoPanel extends StatelessWidget {
  final List<FamilyInformationDto>? familyInformationDto;
  const FamilyInfoPanel({super.key, this.familyInformationDto});

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
                      "Family Information",
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
                    if (familyInformationDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: familyInformationDto!.length,
                              itemBuilder: (context, int index) {
                                if (familyInformationDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No family information'));
                                }

                                return ListTile(
                                    title: Text(
                                        'Date : ${familyInformationDto![index].dateCreated}.'),
                                    subtitle: Text(
                                        'Information : ${familyInformationDto![index].familyBackground}.',
                                        style: const TextStyle(
                                            color: Colors.grey)));
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
