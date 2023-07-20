import 'package:dsd_pcm_mobile/model/pcm/programs_enrolled_dto.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ViewProgramsEnrolled extends StatelessWidget {
 final List<ProgramsEnrolledDto>? programsEnrolledDto;
  const ViewProgramsEnrolled({super.key, required this.programsEnrolledDto});

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
                      "Programs Enrolled",
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
                    if (programsEnrolledDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: programsEnrolledDto!.length,
                              itemBuilder: (context, int index) {
                                if (programsEnrolledDto!.isEmpty) {
                                  return const Center(
                                      child:
                                          Text('No program enrolled detail found.'));
                                }
                                return ListTile(
                                    title: Text(
                                        'Program Name : ${programsEnrolledDto![index].programmesDto?.programmeName}'),
                                        subtitle: Text(
                                        'Start Date : ${programsEnrolledDto![index].startDate}. '
                                        'End Date : ${programsEnrolledDto![index].endDate}',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                    trailing: const Icon(Icons.navigate_next_outlined,
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