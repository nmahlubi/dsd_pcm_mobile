import 'package:hive/hive.dart';

part 'accepted_worklist.model.g.dart';

@HiveType(typeId: 4)
class AcceptedWorklistModel {
  @HiveField(0)
  final String? assessmentStatus;
  @HiveField(1)
  final int? assessmentRegisterId;
  @HiveField(2)
  final int? caseId;
  @HiveField(3)
  final int? worklistId;
  @HiveField(4)
  final int? intakeAssessmentId;
  @HiveField(5)
  final int? personId;
  @HiveField(6)
  final String? childName;
  @HiveField(7)
  final String? dateAccepted;
  @HiveField(8)
  final String? childNameAbbr;
  @HiveField(9)
  final int? clientId;
  @HiveField(10)
  final int? userId;

  AcceptedWorklistModel(
      {this.assessmentStatus,
      this.assessmentRegisterId,
      this.caseId,
      this.worklistId,
      this.intakeAssessmentId,
      this.personId,
      this.childName,
      this.dateAccepted,
      this.childNameAbbr,
      this.clientId,
      this.userId});
}
