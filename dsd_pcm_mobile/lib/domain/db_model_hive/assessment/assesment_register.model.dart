import 'package:hive/hive.dart';

import '../lookup/form_of_notification.model.dart';

part 'assesment_register.model.g.dart';

@HiveType(typeId: 44)
class AssesmentRegisterModel {
  @HiveField(0)
  final int? assesmentRegisterId;
  @HiveField(1)
  final int? pcmCaseId;
  @HiveField(2)
  final int? intakeAssessmentId;
  @HiveField(3)
  final int? probationOfficerId;
  @HiveField(4)
  final int? assessedBy;
  @HiveField(5)
  final String? assessmentDate;
  @HiveField(6)
  final String? assessmentTime;
  @HiveField(7)
  final int? formOfNotificationId;
  @HiveField(8)
  final int? townId;
  @HiveField(9)
  final int? createdBy;
  @HiveField(10)
  final int? modifiedBy;
  @HiveField(11)
  final String? dateCreated;
  @HiveField(12)
  final String? dateModified;
  @HiveField(13)
  final FormOfNotificationModel? formOfNotificationModel;

  AssesmentRegisterModel(
      {this.assesmentRegisterId,
      this.pcmCaseId,
      this.intakeAssessmentId,
      this.probationOfficerId,
      this.assessedBy,
      this.assessmentDate,
      this.assessmentTime,
      this.formOfNotificationId,
      this.townId,
      this.createdBy,
      this.modifiedBy,
      this.dateCreated,
      this.dateModified,
      this.formOfNotificationModel});
}
