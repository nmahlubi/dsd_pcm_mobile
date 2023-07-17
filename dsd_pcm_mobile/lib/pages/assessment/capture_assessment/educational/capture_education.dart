import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';

import '../../../../model/intake/grade_dto.dart';
import '../../../../model/intake/health_status_dto.dart';
import '../../../../model/intake/school_dto.dart';
import '../../../../model/intake/school_type_dto.dart';

// ignore: must_be_immutable
class CaptureEducationPage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final loadSchoolByTypeId;
  // ignore: prefer_typing_uninitialized_variables
  final addNewMedicalHealth;
  final List<GradeDto> gradesDto;
  final List<SchoolTypeDto> schoolTypesDto;
  final List<SchoolDto> schoolsDto;

  CaptureEducationPage(
      {super.key,
      required this.gradesDto,
      required this.schoolTypesDto,
      required this.schoolsDto,
      this.loadSchoolByTypeId,
      this.addNewMedicalHealth});
//controls
  final TextEditingController injuriesController = TextEditingController();
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController medicalAppointmentsController =
      TextEditingController();
  int? gradeDropdownButtonFormField;
  int? schoolTypeDropdownButtonFormField;
  int? schoolDropdownButtonFormField;

  void dispose() {
    injuriesController.dispose();
    medicationController.dispose();
    allergiesController.dispose();
    medicalAppointmentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(0),
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
                      "Capture Educational",
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
                        'Medical Details',
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
                              controller: allergiesController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Allergies',
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
                              controller: medicationController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Medication',
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
                              controller: injuriesController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Injuries',
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
                              controller: medicalAppointmentsController,
                              enableInteractiveSelection: false,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Medical Appointment',
                              ),
                              readOnly: true, // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now(), //get today's date
                                    firstDate: DateTime(
                                        1800), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  medicalAppointmentsController.text =
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
                              child: DropdownButtonFormField(
                                value: schoolTypeDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'School Type',
                                  labelText: 'School Type',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: schoolTypesDto.map((schoolType) {
                                  return DropdownMenuItem(
                                      value: schoolType.schoolTypeId,
                                      child: Text(
                                          schoolType.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  schoolTypeDropdownButtonFormField =
                                      selectedValue;
                                  loadSchoolByTypeId(selectedValue);
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                value: schoolDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'School',
                                  labelText: 'School',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: schoolsDto.map((school) {
                                  return DropdownMenuItem(
                                      value: school.schoolId,
                                      child:
                                          Text(school.schoolName.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  schoolDropdownButtonFormField = selectedValue;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Shcool is required';
                                  }
                                  return null;
                                },
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              child: DropdownButtonFormField(
                                value: gradeDropdownButtonFormField,
                                decoration: const InputDecoration(
                                  hintText: 'Grade',
                                  labelText: 'Grade',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.green),
                                  ),
                                ),
                                items: gradesDto.map((grade) {
                                  return DropdownMenuItem(
                                      value: grade.gradeId,
                                      child:
                                          Text(grade.description.toString()));
                                }).toList(),
                                onChanged: (selectedValue) {
                                  gradeDropdownButtonFormField = selectedValue;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Health Status is required';
                                  }
                                  return null;
                                },
                              )),
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
                                    addNewMedicalHealth(
                                        injuriesController.text.toString(),
                                        medicationController.text.toString(),
                                        allergiesController.text.toString(),
                                        medicalAppointmentsController.text
                                            .toString(),
                                        gradeDropdownButtonFormField);
                                  },
                                  child: const Text('Add Qualification'),
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
