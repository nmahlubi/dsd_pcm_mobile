import 'package:dsd_pcm_mobile/model/pcm/preliminary_detail_dto.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class ViewFinalCourtDecisionPage extends StatelessWidget {
  final List<PreliminaryDetailDto>? preliminaryDetailsDto;
  const ViewFinalCourtDecisionPage({super.key, this.preliminaryDetailsDto});

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
                      "View Final Recommandation Assessment Details",
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
                    if (preliminaryDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: preliminaryDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (preliminaryDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text(
                                          'No Assessment recommendation Found.'));
                                }

                                return ListTile(
                                    title: Text(
                                        'Preliminary Details Recommendation. ${preliminaryDetailsDto![index].intakeAssessmentId}'),
                                    subtitle: Text(
                                        // 'Preliminary Status: ${preliminaryDetailsDto![index].preliminaryStatusDto?.description ?? ''}.'
                                        // 'Reason Outcome : ${preliminaryDetailsDto![index].pCMOutcomeReason ?? ''}.'
                                        // 'Recommendation Type : ${preliminaryDetailsDto![index].recommendationTypeDto?.description ?? ''}.'
                                        // 'Placement Type: ${preliminaryDetailsDto![index].placementTypeDto?.description ?? ''}.'
                                        'Modified Date : ${preliminaryDetailsDto![index].dateModified ?? ''}.'
                                        'Modified by : ${preliminaryDetailsDto![index].modifiedBy ?? ''}.'
                                        'Preliminary Date : ${preliminaryDetailsDto![index].pCMPreliminaryDate ?? ''}.',
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
