import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class CaptureGeneralDetailPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final addNewGeneralDetail;
  CaptureGeneralDetailPage({super.key, this.addNewGeneralDetail});
//controls
  final TextEditingController consultedSourcesController =
      TextEditingController();
  final TextEditingController traceEffortsController = TextEditingController();
  final TextEditingController commentsBySupervisorController =
      TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();
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
                        "Capture General Detail",
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                'Comments',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 21),
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
                                controller: consultedSourcesController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Consulted Sources',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Consulted Sources';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: traceEffortsController,
                                enableInteractiveSelection: false,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Trace Efforts',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Trace Efforts';
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
                                controller: commentsBySupervisorController,
                                enableInteractiveSelection: false,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Supervisor Comments',
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
                              child: TextFormField(
                                controller: additionalInfoController,
                                enableInteractiveSelection: false,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Additional Information',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter Additional Information';
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
                                      addNewGeneralDetail(
                                          consultedSourcesController.text
                                              .toString(),
                                          traceEffortsController.text
                                              .toString(),
                                          commentsBySupervisorController.text
                                              .toString(),
                                          additionalInfoController.text
                                              .toString());
                                    },
                                    child: const Text('Add General Info'),
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
