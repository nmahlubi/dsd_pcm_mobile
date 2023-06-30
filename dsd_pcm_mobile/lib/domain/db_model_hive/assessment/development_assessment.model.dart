import 'package:hive/hive.dart';

part 'development_assessment.model.g.dart';

@HiveType(typeId: 38)
class DevelopmentAssessmentModel {
  @HiveField(0)
  final int? developmentId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? belonging;
  @HiveField(3)
  final String? mastery;
  @HiveField(4)
  final String? independence;
  @HiveField(5)
  final String? generosity;
  @HiveField(6)
  final String? evaluation;
  @HiveField(7)
  final int? createdBy;
  @HiveField(8)
  final int? modifiedBy;
  @HiveField(9)
  final String? dateCreated;
  @HiveField(10)
  final String? dateModified;

  DevelopmentAssessmentModel(
      {this.developmentId,
      this.intakeAssessmentId,
      this.belonging,
      this.mastery,
      this.independence,
      this.generosity,
      this.evaluation,
      this.createdBy,
      this.modifiedBy,
      this.dateCreated,
      this.dateModified});
}
