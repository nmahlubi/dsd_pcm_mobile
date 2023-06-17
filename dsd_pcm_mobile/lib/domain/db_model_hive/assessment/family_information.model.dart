import 'package:hive/hive.dart';

part 'family_information.model.g.dart';

@HiveType(typeId: 18)
class FamilyInformationModel {
  @HiveField(0)
  final int? familyInformationId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? familyBackground;
  @HiveField(3)
  final int? createdBy;
  @HiveField(4)
  final String? dateCreated;
  @HiveField(5)
  final int? modifiedBy;
  @HiveField(6)
  final String? dateModified;

  FamilyInformationModel(
      {this.familyInformationId,
      this.intakeAssessmentId,
      this.familyBackground,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified});
}
