import 'package:hive/hive.dart';

import '../intake/person.model.dart';
import '../lookup/relationship_type.model.dart';

part 'family_member.model.g.dart';

@HiveType(typeId: 19)
class FamilyMemberModel {
  @HiveField(0)
  final int? familyMemberId;
  @HiveField(1)
  final int? intakeAssessmentId;
  @HiveField(2)
  final int? personId;
  @HiveField(3)
  final int? relationshipTypeId;
  @HiveField(4)
  final int? createdBy;
  @HiveField(5)
  final RelationshipTypeModel? relationshipTypeModel;
  @HiveField(6)
  final PersonModel? personModel;

  FamilyMemberModel(
      {this.familyMemberId,
      this.intakeAssessmentId,
      this.personId,
      this.relationshipTypeId,
      this.createdBy,
      this.relationshipTypeModel,
      this.personModel});
}
