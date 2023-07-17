import 'package:hive/hive.dart';

part 'form_of_notification.model.g.dart';

@HiveType(typeId: 43)
class FormOfNotificationModel {
  @HiveField(0)
  final int? formOfNotificationId;
  @HiveField(1)
  final String? description;

  FormOfNotificationModel({this.formOfNotificationId, this.description});
}
