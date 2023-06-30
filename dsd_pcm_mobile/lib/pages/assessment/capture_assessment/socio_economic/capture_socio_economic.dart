import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CaptureSocioEconomicPage extends StatelessWidget {
  final addNewSocioEconomic;
  CaptureSocioEconomicPage({super.key, this.addNewSocioEconomic});
//controls
  final TextEditingController familyBackgroundCommentController =
      TextEditingController();
  final TextEditingController financeWorkRecordController =
      TextEditingController();
  final TextEditingController housingController = TextEditingController();
  final TextEditingController socialCircumsancesController =
      TextEditingController();
  final TextEditingController previousInterventionController =
      TextEditingController();
  final TextEditingController interPersonalRelationshipController =
      TextEditingController();
  final TextEditingController peerPresureController = TextEditingController();
  final TextEditingController substanceAbuseController =
      TextEditingController();
  final TextEditingController religiousInvolveController =
      TextEditingController();
  final TextEditingController childBehaviorController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final _captureGeneralDetailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(2),
      child: Form(
        key: _captureGeneralDetailFormKey,
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
                        "Capture Socio Economic",
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
                          'Socio Economic',
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
                              child: TextFormField(
                                controller: familyBackgroundCommentController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Family Background Comments',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Family Background Comments';
                                  }
                                  return null;
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
                                controller: financeWorkRecordController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Finance Work Record',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Finance Work Record';
                                  }
                                  return null;
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
                                controller: housingController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Housing',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Housing';
                                  }
                                  return null;
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
                                controller: socialCircumsancesController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Social Circumsances',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Social Circumsances';
                                  }
                                  return null;
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
                                controller: previousInterventionController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Previous Intervention',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Previous Intervention';
                                  }
                                  return null;
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
                                controller: interPersonalRelationshipController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'InterPersonal Relationship',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter InterPersonal Relationship';
                                  }
                                  return null;
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
                                controller: peerPresureController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Peer Presure',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Peer Presure';
                                  }
                                  return null;
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
                                controller: substanceAbuseController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Substance Abuse',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Substance Abuse';
                                  }
                                  return null;
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
                                controller: religiousInvolveController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Religious Involve',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Religious Involve';
                                  }
                                  return null;
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
                                controller: childBehaviorController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Child Behavior',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Child Behavior';
                                  }
                                  return null;
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
                                controller: otherController,
                                enableInteractiveSelection: false,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Other',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Other';
                                  }
                                  return null;
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
                                      addNewSocioEconomic(
                                          familyBackgroundCommentController.text
                                              .toString(),
                                          financeWorkRecordController.text
                                              .toString(),
                                          housingController.text.toString(),
                                          socialCircumsancesController.text
                                              .toString(),
                                          previousInterventionController.text
                                              .toString(),
                                          interPersonalRelationshipController
                                              .text
                                              .toString(),
                                          peerPresureController.text.toString(),
                                          substanceAbuseController.text
                                              .toString(),
                                          religiousInvolveController.text
                                              .toString(),
                                          childBehaviorController.text
                                              .toString(),
                                          otherController.text.toString());
                                    },
                                    child: const Text('Add Socio'),
                                  )
                                  /*child: ElevatedButton(
                                    child: const Text('Add'),
                                    onPressed: () {
                                      if (_captureGeneralDetailFormKey
                                          .currentState!
                                          .validate()) {
                                        addNewSocioEconomic(
                                            familyBackgroundCommentController
                                                .text
                                                .toString(),
                                            financeWorkRecordController.text
                                                .toString(),
                                            housingController.text.toString(),
                                            socialCircumsancesController.text
                                                .toString(),
                                            previousInterventionController.text
                                                .toString(),
                                            interPersonalRelationshipController
                                                .text
                                                .toString(),
                                            peerPresureController.text
                                                .toString(),
                                            substanceAbuseController.text
                                                .toString(),
                                            religiousInvolveController.text
                                                .toString(),
                                            childBehaviorController.text
                                                .toString(),
                                            otherController.text.toString());
                                      }
                                    },
                                  )*/
                                  )),
                        ],
                      ),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
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
      ),
    ));
  }
}
