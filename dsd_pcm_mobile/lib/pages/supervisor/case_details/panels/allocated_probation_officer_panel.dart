import 'package:flutter/material.dart';
import '../../../../model/pcm/allocated_case_supervisor_dto.dart';

class AllocatedProbationOfficerPanel extends StatelessWidget {
  final AllocatedCaseSupervisorDto? allocatedCaseSupervisorDto;
  const AllocatedProbationOfficerPanel(
      {super.key, this.allocatedCaseSupervisorDto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
              title: Text(
            'Current Probation Officer',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w200, fontSize: 21),
          )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 1,
              controller: TextEditingController(
                  text: allocatedCaseSupervisorDto!.allocateTo),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Probation Officer Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              maxLines: 1,
              controller: TextEditingController(
                  text: allocatedCaseSupervisorDto!.dateAllocated),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date Allocated',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
