import 'package:hive/hive.dart';

import '../intake/person.model.dart';
import '../lookup/relationship_type.model.dart';

part 'care_giver_detail.model.g.dart';

@HiveType(typeId: 25)
class CareGiverDetailModel {
  @HiveField(0)
  final int? clientCaregiverId;
  @HiveField(1)
  final int? clientId;
  @HiveField(2)
  final int? relationshipTypeId;
  @HiveField(3)
  final int? personId;
  @HiveField(4)
  final String? createdBy;
  @HiveField(5)
  final String? dateCreated;
  @HiveField(6)
  final String? modifiedBy;
  @HiveField(7)
  final String? dateModified;
  @HiveField(8)
  final RelationshipTypeModel? relationshipTypeModel;
  @HiveField(9)
  final PersonModel? personModel;

  CareGiverDetailModel(
      {this.clientCaregiverId,
      this.clientId,
      this.relationshipTypeId,
      this.personId,
      this.createdBy,
      this.dateCreated,
      this.modifiedBy,
      this.dateModified,
      this.relationshipTypeModel,
      this.personModel});
}
