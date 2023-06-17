import 'package:hive/hive.dart';

part 'offence_schedule.model.g.dart';

@HiveType(typeId: 24)
class OffenceScheduleModel {
  @HiveField(0)
  final int? offenceScheduleId;
  @HiveField(1)
  final String? description;

  OffenceScheduleModel({this.offenceScheduleId, this.description});
}
