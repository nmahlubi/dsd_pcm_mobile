import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/development_assessment_dto.dart';

class ViewDevelopmentAssessmentPage extends StatelessWidget {
  final List<DevelopmentAssessmentDto>? developmentAssessmentsDto;
  const ViewDevelopmentAssessmentPage(
      {super.key, this.developmentAssessmentsDto});

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
                      "View Development Assessment",
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
                    if (developmentAssessmentsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: developmentAssessmentsDto!.length,
                              itemBuilder: (context, int index) {
                                if (developmentAssessmentsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No Comments Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'Date : ${developmentAssessmentsDto![index].dateCreated ?? ''}'),
                                  subtitle: Text(
                                      'Belonging : ${developmentAssessmentsDto![index].belonging ?? ''}. '
                                      'Mastery : ${developmentAssessmentsDto![index].mastery ?? ''}. '
                                      'Independence : ${developmentAssessmentsDto![index].independence ?? ''}. '
                                      'Generosity : ${developmentAssessmentsDto![index].generosity ?? ''}'
                                      'Evaluation : ${developmentAssessmentsDto![index].evaluation ?? ''}',
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
