import 'package:hive/hive.dart';

part 'mobile_dashboard.model.g.dart';

@HiveType(typeId: 2)
class MobileDashboardModel {
  @HiveField(0)
  final int? newPropationOfficerInbox;
  @HiveField(1)
  final int? newWorklist;
  @HiveField(2)
  final int? reAssignedCases;
  MobileDashboardModel(
      {this.newPropationOfficerInbox, this.newWorklist, this.reAssignedCases});
}
