import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import '../../../../model/intake/placement_type_dto.dart';
import '../../../../model/intake/recommendation_type_dto.dart';
import '../../../../model/pcm/preliminaryStatus_dto.dart';

class CapturePreliminaryCourtDecisionPage extends StatefulWidget {
  final addNewPreliminaryDetail;
  final List<PreliminaryStatusDto> preliminaryStatusDto;

  final List<PlacementTypeDto> placementTypeDto;
  final List<RecommendationTypeDto> recommendationTypeDto;

  CapturePreliminaryCourtDecisionPage(
      {super.key,
      required this.preliminaryStatusDto,
      required this.recommendationTypeDto,
      required this.placementTypeDto,
      this.addNewPreliminaryDetail});

  @override
  State<CapturePreliminaryCourtDecisionPage> createState() =>
      _CapturePreliminaryCourtDecisionPageState();
}

class _CapturePreliminaryCourtDecisionPageState
    extends State<CapturePreliminaryCourtDecisionPage> {
//controls
  final TextEditingController preliminaryDateController =
      TextEditingController();

  final TextEditingController OutcomeReasonController = TextEditingController();

  int? preliminaryStatusDropdownButtonFormField;

  int? recommendetionTypeDropdownButtonFormField;

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
                      "Capture Preliminary Details",
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
                        'Preliminary Details',
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
                                value: preliminaryStatusDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'Preliminaraly Status Type',
                                  labelText: 'Preliminaraly Status Type',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: widget.preliminaryStatusDto
                                    .map((preliminary) {
                                  return DropdownMenuItem(
                                      value: preliminary.preliminaryStatusId,
                                      child: Text(
                                          preliminary.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  preliminaryStatusDropdownButtonFormField =
                                      selectedValue;
                                },
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: preliminaryDateController,

                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Preliminary Date*',
                              ),
                              readOnly: true, // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        2000), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  preliminaryDateController.text =
                                      formattedDate;
                                  //You can format date as per your need
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller: OutcomeReasonController,
                              maxLines: 3,
                              readOnly: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Reason Outcome',
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
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                value:
                                    recommendetionTypeDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'Recommendation Type',
                                  labelText: 'Recommendation Type',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: widget.recommendationTypeDto
                                    .map((recommendationtype) {
                                  return DropdownMenuItem(
                                      value: recommendationtype
                                          .recommendationTypeId,
                                      child: Text(recommendationtype.description
                                          .toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  recommendetionTypeDropdownButtonFormField =
                                      selectedValue;
                                },
                              )),
                        ),
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                value: placementTypeDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'Placement Recommendation Type',
                                  labelText: 'Placement Recommendation Type',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: widget.placementTypeDto.map((placement) {
                                  return DropdownMenuItem(
                                      value: placement.placementTypeId,
                                      child: Text(
                                          placement.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  placementTypeDropdownButtonFormField =
                                      selectedValue;
                                },
                              )),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                                  child: const Text('Save'),
                                  onPressed: () {
                                    widget.addNewPreliminaryDetail(
                                        preliminaryStatusDropdownButtonFormField,
                                        preliminaryDateController.text
                                            .toString(),
                                        OutcomeReasonController.text.toString(),
                                        recommendetionTypeDropdownButtonFormField,
                                        placementTypeDropdownButtonFormField);
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
