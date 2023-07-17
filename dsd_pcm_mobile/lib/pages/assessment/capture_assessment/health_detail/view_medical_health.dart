import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/pcm/medical_health_detail_dto.dart';

class ViewMedicalHealth extends StatelessWidget {
  final List<MedicalHealthDetailDto>? medicalHealthDetailsDto;
  const ViewMedicalHealth({super.key, this.medicalHealthDetailsDto});

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
                      "View Medical Health",
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
                    if (medicalHealthDetailsDto!.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: medicalHealthDetailsDto!.length,
                              itemBuilder: (context, int index) {
                                if (medicalHealthDetailsDto!.isEmpty) {
                                  return const Center(
                                      child: Text('No medical health Found.'));
                                }
                                return ListTile(
                                  title: Text(
                                      'Health Status : ${medicalHealthDetailsDto![index].healthStatusDto?.description}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      'Allergy : ${medicalHealthDetailsDto![index].allergies}. '
                                      'Injuries : ${medicalHealthDetailsDto![index].injuries}. '
                                      'Medication : ${medicalHealthDetailsDto![index].medication}.',
                                      style:
                                          const TextStyle(color: Colors.black)),
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
