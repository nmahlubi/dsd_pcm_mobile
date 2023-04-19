import 'package:hive/hive.dart';

part 'login_auth.model.g.dart';

@HiveType(typeId: 0)
class LoginAuthModel {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final bool? complete;

  LoginAuthModel({this.title, this.description, this.complete});
}
