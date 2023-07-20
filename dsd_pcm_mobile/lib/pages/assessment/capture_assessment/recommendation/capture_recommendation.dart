import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/placement_type_dto.dart';
import '../../../../model/intake/recommendation_type_dto.dart';

// ignore: must_be_immutable
class CaptureRecommendationPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final addNewRecommandation;
  final List<RecommendationTypeDto> recommendationTypesDto;
  final List<PlacementTypeDto> placementTypesDto;

  CaptureRecommendationPage(
      {super.key,
      required this.recommendationTypesDto,
      required this.placementTypesDto,
      this.addNewRecommandation});
//controls
  final TextEditingController commentsForRecommendationController =
      TextEditingController();
  int? recommendationTypeDropdownButtonFormField;
  int? placementTypeDropdownButtonFormField;

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
                      "Capture Recommandation",
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Recommandation',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                            fontSize: 21),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  value:
                                      recommendationTypeDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Recommandation Type',
                                    labelText: 'Recommandation Type',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  items: recommendationTypesDto
                                      .map((recommandationType) {
                                    return DropdownMenuItem(
                                        value: recommandationType
                                            .recommendationTypeId,
                                        child: Text(recommandationType
                                            .description
                                            .toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    recommendationTypeDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Recommandation Type is required';
                                    }
                                    return null;
                                  },
                                ))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  value: placementTypeDropdownButtonFormField,
                                  decoration: const InputDecoration(
                                    hintText: 'Placement Type',
                                    labelText: 'Placement Type',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.green),
                                    ),
                                  ),
                                  items: placementTypesDto.map((placementType) {
                                    return DropdownMenuItem(
                                        value: placementType.placementTypeId,
                                        child: Text(placementType.description
                                            .toString()));
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    placementTypeDropdownButtonFormField =
                                        selectedValue;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Placement Type is required';
                                    }
                                    return null;
                                  },
                                ))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: commentsForRecommendationController,
                              enableInteractiveSelection: false,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Comments',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 70,
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
                        )),
                        Expanded(
                            child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 23, 22, 22),
                                    shape: const StadiumBorder(),
                                    side: const BorderSide(
                                        width: 2, color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    addNewRecommandation(
                                      recommendationTypeDropdownButtonFormField,
                                      placementTypeDropdownButtonFormField,
                                      commentsForRecommendationController.text
                                          .toString(),
                                    );
                                  },
                                  child: const Text('Add Recommandation'),
                                ))),
                      ],
                    ),
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
