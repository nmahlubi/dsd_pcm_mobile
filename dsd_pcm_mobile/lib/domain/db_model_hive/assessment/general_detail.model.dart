import 'package:hive/hive.dart';

part 'general_detail.model.g.dart';

@HiveType(typeId: 34)
class GeneralDetailModel {
  @HiveField(0)
  final int? generalDetailsId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? consultedSources;
  @HiveField(3)
  final String? traceEfforts;
  @HiveField(4)
  final String? assessmentDate;
  @HiveField(5)
  final String? additionalInfo;
  @HiveField(6)
  final int? isVerifiedBySupervisor;
  @HiveField(7)
  final String? commentsBySupervisor;
  @HiveField(8)
  final int? createdBy;
  @HiveField(9)
  final int? modifiedBy;
  @HiveField(10)
  final String? dateCreated;
  @HiveField(11)
  final String? dateModified;
  @HiveField(12)
  final String? assessmentTime;

  GeneralDetailModel(
      {this.generalDetailsId,
      this.intakeAssessmentId,
      this.consultedSources,
      this.traceEfforts,
      this.assessmentDate,
      this.additionalInfo,
      this.isVerifiedBySupervisor,
      this.commentsBySupervisor,
      this.createdBy,
      this.modifiedBy,
      this.dateCreated,
      this.dateModified,
      this.assessmentTime});
}
