import 'package:hive/hive.dart';

import '../intake/person.model.dart';

part 'victim_detail.model.g.dart';

@HiveType(typeId: 36)
class VictimDetailModel {
  @HiveField(0)
  final int? victimId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? isVictimIndividual;
  @HiveField(3)
  final int? personId;
  @HiveField(4)
  final String? victimOccupation;
  @HiveField(5)
  final String? victimCareGiverNames;
  @HiveField(6)
  final String? addressLine1;
  @HiveField(7)
  final String? addressLine2;
  @HiveField(8)
  final int? townId;
  @HiveField(9)
  final String? postalCode;
  @HiveField(10)
  final int? createdBy;
  @HiveField(11)
  final String? dateCreated;
  @HiveField(12)
  final int? modifiedBy;
  @HiveField(13)
  final String? dateModified;
  @HiveField(14)
  final PersonModel? personModel;

  VictimDetailModel(
      {this.victimId,
      this.intakeAssessmentId,
      this.isVictimIndividual,
      this.personId,
      this.victimOccupation,
      this.victimCareGiverNames,
      this.addressLine1,
      this.addressLine2,
      this.townId,
      this.postalCode,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.personModel});
}
