import 'package:hive/hive.dart';

import 'school_type.model.dart';

part 'school.model.g.dart';

@HiveType(typeId: 41)
class SchoolModel {
  @HiveField(0)
  int? schoolId;
  @HiveField(1)
  int? schoolTypeId;
  @HiveField(2)
  String? schoolName;
  @HiveField(3)
  String? contactPerson;
  @HiveField(4)
  String? telephoneNumber;
  @HiveField(5)
  String? cellphoneNumber;
  @HiveField(6)
  String? faxNumber;
  @HiveField(7)
  String? emailAddress;
  @HiveField(8)
  String? dateCreated;
  @HiveField(9)
  String? createdBy;
  @HiveField(10)
  String? dateLastModified;
  @HiveField(11)
  String? modifiedBy;
  @HiveField(12)
  bool? isActive;
  @HiveField(13)
  bool? isDeleted;
  @HiveField(14)
  String? natEmis;
  @HiveField(15)
  final SchoolTypeModel? schoolTypeModel;

  SchoolModel(
      {this.schoolId,
      this.schoolTypeId,
      this.schoolName,
      this.contactPerson,
      this.telephoneNumber,
      this.cellphoneNumber,
      this.faxNumber,
      this.emailAddress,
      this.dateCreated,
      this.createdBy,
      this.dateLastModified,
      this.modifiedBy,
      this.isActive,
      this.isDeleted,
      this.natEmis,
      this.schoolTypeModel});
}
