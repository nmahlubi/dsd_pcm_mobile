import 'package:hive/hive.dart';

part 'victim_organisation_detail.model.g.dart';

@HiveType(typeId: 35)
class VictimOrganisationDetailModel {
  @HiveField(0)
  final int? victimOrganisationId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final String? organisationName;
  @HiveField(3)
  final String? contactPersonFirstName;
  @HiveField(4)
  final String? contactPersonLastName;
  @HiveField(5)
  final String? telephone;
  @HiveField(6)
  final String? cellNo;
  @HiveField(7)
  final String? interventionserviceReferrals;
  @HiveField(8)
  final String? otherContacts;
  @HiveField(9)
  final String? contactPersonOccupation;
  @HiveField(10)
  final String? addressLine1;
  @HiveField(11)
  final String? addressLine2;
  @HiveField(12)
  final int? townId;
  @HiveField(13)
  final String? postalCode;
  @HiveField(14)
  final int? createdBy;
  @HiveField(15)
  final String? dateCreated;
  @HiveField(16)
  final int? modifiedBy;
  @HiveField(17)
  final String? dateModified;

  VictimOrganisationDetailModel(
      {this.victimOrganisationId,
      this.intakeAssessmentId,
      this.organisationName,
      this.contactPersonFirstName,
      this.contactPersonLastName,
      this.telephone,
      this.cellNo,
      this.interventionserviceReferrals,
      this.otherContacts,
      this.contactPersonOccupation,
      this.addressLine1,
      this.addressLine2,
      this.townId,
      this.postalCode,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified});
}
