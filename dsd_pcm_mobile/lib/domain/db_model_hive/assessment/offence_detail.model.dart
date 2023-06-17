import 'package:hive/hive.dart';

import '../intake/offence_category.model.dart';
import '../intake/offence_schedule.model.dart';
import '../intake/offence_type.model.dart';

part 'offence_detail.model.g.dart';

@HiveType(typeId: 33)
class OffenceDetailModel {
  @HiveField(0)
  final int? pcmOffenceId;
  @HiveField(1)
  final int? pcmCaseId;
  @HiveField(2)
  final int? intakeAssessmentId;
  @HiveField(3)
  final int? offenceTypeId;
  @HiveField(4)
  final int? offenceCategoryId;
  @HiveField(5)
  final int? offenceScheduleId;
  @HiveField(6)
  final String? offenceCircumstance;
  @HiveField(7)
  final String? valueOfGoods;
  @HiveField(8)
  final String? valueRecovered;
  @HiveField(9)
  final String? isChildResponsible;
  @HiveField(10)
  final String? responsibilityDetails;
  @HiveField(11)
  final int? createdBy;
  @HiveField(12)
  final String? dateCreated;
  @HiveField(13)
  final int? modifiedBy;
  @HiveField(14)
  final String? dateModified;
  @HiveField(15)
  final OffenceTypeModel? offenceTypeModel;
  @HiveField(16)
  final OffenceCategoryModel? offenceCategoryModel;
  @HiveField(17)
  final OffenceScheduleModel? offenceScheduleModel;

  OffenceDetailModel(
      {this.pcmOffenceId,
      this.pcmCaseId,
      this.intakeAssessmentId,
      this.offenceTypeId,
      this.offenceCategoryId,
      this.offenceScheduleId,
      this.offenceCircumstance,
      this.valueOfGoods,
      this.valueRecovered,
      this.isChildResponsible,
      this.responsibilityDetails,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.offenceTypeModel,
      this.offenceCategoryModel,
      this.offenceScheduleModel});
}
