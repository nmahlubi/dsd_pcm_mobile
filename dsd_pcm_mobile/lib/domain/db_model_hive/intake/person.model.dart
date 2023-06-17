import 'package:hive/hive.dart';

import '../lookup/disability_type.model.dart';
import '../lookup/gender.model.dart';
import '../lookup/identification_type.model.dart';
import '../lookup/language.model.dart';
import '../lookup/marital_status.model.dart';
import '../lookup/placement_type.model.dart';

part 'person.model.g.dart';

@HiveType(typeId: 16)
class PersonModel {
  @HiveField(0)
  int? personId;
  @HiveField(1)
  String? firstName;
  @HiveField(2)
  String? lastName;
  @HiveField(3)
  String? knownAs;
  @HiveField(4)
  int? identificationTypeId;
  @HiveField(5)
  String? identificationNumber;
  @HiveField(6)
  bool? isPivaValidated;
  @HiveField(7)
  String? pivaTransactionId;
  @HiveField(8)
  String? dateOfBirth;
  @HiveField(9)
  int? age;
  @HiveField(10)
  bool? isEstimatedAge;
  @HiveField(11)
  int? sexualOrientationId;
  @HiveField(12)
  int? languageId;
  @HiveField(13)
  int? genderId;
  @HiveField(14)
  int? maritalStatusId;
  @HiveField(15)
  int? preferredContactTypeId;
  @HiveField(16)
  int? religionId;
  @HiveField(17)
  String? phoneNumber;
  @HiveField(18)
  String? mobilePhoneNumber;
  @HiveField(19)
  String? emailAddress;
  @HiveField(20)
  int? populationGroupId;
  @HiveField(22)
  int? nationalityId;
  @HiveField(23)
  int? disabilityTypeId;
  @HiveField(24)
  int? citizenshipId;
  @HiveField(25)
  String? dateLastModified;
  @HiveField(26)
  String? modifiedBy;
  @HiveField(27)
  String? createdBy;
  @HiveField(28)
  int? userId;
  @HiveField(29)
  final DisabilityTypeModel? disabilityTypeModel;
  @HiveField(30)
  final GenderModel? genderModel;
  @HiveField(31)
  final LanguageModel? languageModel;
  @HiveField(32)
  final MaritalStatusModel? maritalStatusModel;
  @HiveField(33)
  final IdentificationTypeModel? identificationTypeModel;
  @HiveField(34)
  final PlacementTypeModel? placementTypeModel;

  PersonModel(
      {this.personId,
      this.firstName,
      this.lastName,
      this.knownAs,
      this.identificationTypeId,
      this.identificationNumber,
      this.isPivaValidated,
      this.pivaTransactionId,
      this.dateOfBirth,
      this.age,
      this.isEstimatedAge,
      this.sexualOrientationId,
      this.languageId,
      this.genderId,
      this.maritalStatusId,
      this.preferredContactTypeId,
      this.religionId,
      this.phoneNumber,
      this.mobilePhoneNumber,
      this.emailAddress,
      this.populationGroupId,
      this.nationalityId,
      this.disabilityTypeId,
      this.citizenshipId,
      this.dateLastModified,
      this.modifiedBy,
      this.createdBy,
      this.userId,
      this.disabilityTypeModel,
      this.genderModel,
      this.languageModel,
      this.maritalStatusModel,
      this.identificationTypeModel,
      this.placementTypeModel});
}
