import 'package:dsd_pcm_mobile/model/pcm/programme_module_dto.dart';
import 'package:dsd_pcm_mobile/pages/probation_officer/diversion_childrenlist.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class ViewProgrammeModulePage extends StatelessWidget {
  final List<ProgrammeModuleDto>? programmeModulesDto;
  const ViewProgrammeModulePage({super.key, this.programmeModulesDto});

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
                      "View Programme Modules",
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
                    if (programmeModulesDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: programmeModulesDto!.length,
                              itemBuilder: (context, int index) {
                                if (programmeModulesDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Program Modules Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'Module Name : ${programmeModulesDto![index].programmeModuleId}'),
                                  subtitle: Text(
                                      'Session : ${programmeModulesDto![index].numberofSessions}.'
                                      'Session Date : ${programmeModulesDto![index].sessionStartDate}.'
                                      'Session Outcomes : ${programmeModulesDto![index].source}.',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  trailing: const Icon(Icons.add,
                                      color: Colors.green),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DiversionChildrenListPage(), ////////////////////////////////////
                                        settings: RouteSettings(
                                          arguments: programmeModulesDto![index]
                                              .programmeId,
                                        ),
                                      ),
                                    ),
                                  },
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
