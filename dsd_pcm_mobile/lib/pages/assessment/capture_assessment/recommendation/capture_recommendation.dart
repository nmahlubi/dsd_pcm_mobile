import 'package:dropdown_plus/dropdown_plus.dart';

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

import '../../../../model/intake/placement_type_dto.dart';
import '../../../../model/intake/recommendation_type_dto.dart';
import '../../../../widgets/dropdown_widget.dart';

class CaptureRecommendationPage extends StatelessWidget {
  final addNewRecommandation;
  final List<Map<String, dynamic>> recommendationTypeItemsDto;
  final List<Map<String, dynamic>> placementTypeItemsDto;
  CaptureRecommendationPage(
      {super.key,
      required this.recommendationTypeItemsDto,
      required this.placementTypeItemsDto,
      this.addNewRecommandation});
//controls
  final TextEditingController commentsForRecommendationController =
      TextEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      recommendationTypeController = DropdownEditingController();
  final DropdownEditingController<Map<String, dynamic>>?
      placementTypeController = DropdownEditingController();
/*
 int? recommendationId,
    int? recommendationTypeId,
    int? placementTypeId,
    String? commentsForRecommendation,
    int? createdBy,
    String? dateCreated,
    int? modifiedBy,
    String? dateModified,
    int? intakeAssessmentId,
    */
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
                    Row(children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: dynamicDropdownWidget(
                                dropdownEditingName:
                                    recommendationTypeController,
                                labelTextValue: 'Recommandation Type',
                                displayItemFnValue: 'description',
                                itemsCollection: recommendationTypeItemsDto,
                                selectedFnValue: 'recommendationTypeId',
                                filterFnValue: 'description',
                                titleValue: 'description',
                                subtitleValue: '')),
                      ),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: dynamicDropdownWidget(
                                  dropdownEditingName: placementTypeController,
                                  labelTextValue: 'Placement Type',
                                  displayItemFnValue: 'description',
                                  itemsCollection: placementTypeItemsDto,
                                  selectedFnValue: 'placementTypeId',
                                  filterFnValue: 'description',
                                  titleValue: 'description',
                                  subtitleValue: '')),
                        ),
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
                                labelText: 'Comments For Recommendation',
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
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        Expanded(
                            child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 2),
                                child: ElevatedButton(
                                  child: const Text('Add'),
                                  onPressed: () {
                                    addNewRecommandation(
                                      RecommendationTypeDto.fromJson(
                                          recommendationTypeController!.value),
                                      PlacementTypeDto.fromJson(
                                          placementTypeController!.value),
                                      commentsForRecommendationController.text
                                          .toString(),
                                    );
                                  },
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
