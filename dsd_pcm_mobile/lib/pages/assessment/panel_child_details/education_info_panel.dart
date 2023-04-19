import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../model/intake/person_education_query_dto.dart';

class EducationInfoPanel extends StatelessWidget {
  final List<PersonEducationQueryDto>? personEducationsQueryDto;
  const EducationInfoPanel({super.key, required this.personEducationsQueryDto});

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
                      "Education Information",
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
                    if (personEducationsQueryDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: personEducationsQueryDto!.length,
                              itemBuilder: (context, int index) {
                                if (personEducationsQueryDto!.isEmpty) {
                                  return const Center(
                                      child:
                                          Text('No education qualification.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'School Name : ${personEducationsQueryDto![index].schoolName}'),
                                    subtitle: Text(
                                        'Highest grade completed : ${personEducationsQueryDto![index].gradeName}.'
                                        ' Year completed :  ${personEducationsQueryDto![index].yearCompleted}',
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
