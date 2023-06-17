import 'package:hive/hive.dart';

import '../lookup/health_status.model.dart';

part 'medical_health_detail.model.g.dart';

@HiveType(typeId: 20)
class MedicalHealthDetailModel {
  @HiveField(0)
  final int? healthDetailsId;
  @HiveField(1)
  final int? healthStatusId;
  @HiveField(2)
  final String? injuries;
  @HiveField(3)
  final String? medication;
  @HiveField(4)
  final String? allergies;
  @HiveField(5)
  final String? medicalAppointments;
  @HiveField(6)
  final int? intakeAssessmentId;
  @HiveField(7)
  final int? createdBy;
  @HiveField(8)
  final String? dateCreated;
  @HiveField(9)
  final int? modifiedBy;
  @HiveField(10)
  final String? dateModified;
  @HiveField(11)
  final HealthStatusModel? healthStatusModel;

  MedicalHealthDetailModel(
      {this.healthDetailsId,
      this.healthStatusId,
      this.injuries,
      this.medication,
      this.allergies,
      this.medicalAppointments,
      this.intakeAssessmentId,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.healthStatusModel});
}
