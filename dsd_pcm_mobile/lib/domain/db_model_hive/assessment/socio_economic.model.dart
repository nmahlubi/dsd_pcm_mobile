import 'package:hive/hive.dart';

part 'socio_economic.model.g.dart';

@HiveType(typeId: 21)
class SocioEconomicModel {
  @HiveField(0)
  final int? socioEconomyid;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? familyBackgroundComment;
  @HiveField(3)
  final String? financeWorkRecord;
  @HiveField(4)
  final String? housing;
  @HiveField(5)
  final String? socialCircumsances;
  @HiveField(6)
  final String? previousIntervention;
  @HiveField(7)
  final String? interPersonalRelationship;
  @HiveField(8)
  final String? peerPresure;
  @HiveField(9)
  final String? substanceAbuse;
  @HiveField(10)
  final String? religiousInvolve;
  @HiveField(11)
  final String? childBehavior;
  @HiveField(12)
  final String? other;
  @HiveField(13)
  final int? createdBy;
  @HiveField(14)
  final String? dateCreated;
  @HiveField(15)
  final int? modifiedBy;
  @HiveField(16)
  final String? dateModified;

  SocioEconomicModel(
      {this.socioEconomyid,
      this.intakeAssessmentId,
      this.familyBackgroundComment,
      this.financeWorkRecord,
      this.housing,
      this.socialCircumsances,
      this.previousIntervention,
      this.interPersonalRelationship,
      this.peerPresure,
      this.substanceAbuse,
      this.religiousInvolve,
      this.childBehavior,
      this.other,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified});
}
