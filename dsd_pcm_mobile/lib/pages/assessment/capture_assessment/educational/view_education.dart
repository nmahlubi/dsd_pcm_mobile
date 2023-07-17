import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/person_education_dto.dart';
import '../../../../model/pcm/medical_health_detail_dto.dart';

class ViewEducation extends StatelessWidget {
  final List<PersonEducationDto>? personEducationsDto;
  const ViewEducation({super.key, this.personEducationsDto});

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
                      "View Educational",
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
                    if (personEducationsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: personEducationsDto!.length,
                              itemBuilder: (context, int index) {
                                if (personEducationsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No education Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'School Name : ${personEducationsDto![index].schoolDto?.schoolName ?? ''}'),
                                  subtitle: Text(
                                      'Highest Grade Passes : ${personEducationsDto![index].gradeDto?.description ?? ''} '
                                      'Year Completed : ${personEducationsDto![index].yearCompleted ?? ''} '
                                      'Last Attended : ${personEducationsDto![index].dateLastAttended ?? ''}',
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
