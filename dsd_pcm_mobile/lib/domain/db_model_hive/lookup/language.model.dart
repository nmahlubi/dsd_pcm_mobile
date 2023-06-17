import 'package:hive/hive.dart';

part 'language.model.g.dart';

@HiveType(typeId: 8)
class LanguageModel {
  @HiveField(0)
  final int? languageId;
  @HiveField(1)
  final String? description;

  LanguageModel({this.languageId, this.description});
}
