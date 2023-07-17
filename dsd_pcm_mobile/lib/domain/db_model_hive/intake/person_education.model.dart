import 'package:hive/hive.dart';

import '../school/grade.model.dart';
import '../school/school.model.dart';
import 'person.model.dart';

part 'person_education.model.g.dart';

@HiveType(typeId: 42)
class PersonEducationModel {
  @HiveField(0)
  int? personEducationId;
  @HiveField(1)
  int? personId;
  @HiveField(2)
  int? gradeId;
  @HiveField(3)
  int? schoolId;
  @HiveField(4)
  String? yearCompleted;
  @HiveField(5)
  String? dateLastAttended;
  @HiveField(6)
  String? additionalInformation;
  @HiveField(7)
  String? dateCreated;
  @HiveField(8)
  String? createdBy;
  @HiveField(9)
  String? dateLastModified;
  @HiveField(10)
  String? modifiedBy;
  @HiveField(11)
  bool? isActive;
  @HiveField(12)
  bool? isDeleted;
  @HiveField(13)
  final PersonModel? personModel;
  @HiveField(14)
  final SchoolModel? schoolModel;
  @HiveField(15)
  final GradeModel? gradeModel;

  PersonEducationModel(
      {this.personEducationId,
      this.personId,
      this.gradeId,
      this.schoolId,
      this.yearCompleted,
      this.dateLastAttended,
      this.additionalInformation,
      this.dateCreated,
      this.createdBy,
      this.dateLastModified,
      this.modifiedBy,
      this.isActive,
      this.isDeleted,
      this.personModel,
      this.schoolModel,
      this.gradeModel});
}
