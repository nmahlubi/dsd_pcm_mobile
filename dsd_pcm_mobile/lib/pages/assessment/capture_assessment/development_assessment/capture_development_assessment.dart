import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CaptureDevelopmentAssessmentPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final addDevelopmentAssessment;
  CaptureDevelopmentAssessmentPage({super.key, this.addDevelopmentAssessment});
//controls
  final TextEditingController belongingController = TextEditingController();
  final TextEditingController masteryController = TextEditingController();
  final TextEditingController independenceController = TextEditingController();
  final TextEditingController generosityController = TextEditingController();
  final TextEditingController evaluationController = TextEditingController();
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
                        "Capture Development Assessment",
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
                          'Development Assessment',
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
                                controller: belongingController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Belonging',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Belonging';
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
                                controller: masteryController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Mastery',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Mastery';
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
                                controller: independenceController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Independence',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Independence';
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
                                controller: generosityController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Generosity',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Generosity';
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
                                controller: evaluationController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Evaluation',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Evaluation';
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
                                      if (_captureGeneralDetailFormKey
                                          .currentState!
                                          .validate()) {
                                        addDevelopmentAssessment(
                                            belongingController.text.toString(),
                                            masteryController.text.toString(),
                                            independenceController.text
                                                .toString(),
                                            generosityController.text
                                                .toString(),
                                            evaluationController.text
                                                .toString());

                                        /*
                                                
    */
                                      }
                                    },
                                  ))),
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
