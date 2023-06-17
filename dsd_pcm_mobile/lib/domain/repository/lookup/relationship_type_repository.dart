import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/relationship_type_dto.dart';
import '../../db_model_hive/lookup/relationship_type.model.dart';

const String _relationshipTypeBox = 'relationshipTypeBox';

class RelationshipTypeRepository {
  RelationshipTypeRepository._constructor();

  static final RelationshipTypeRepository _instance =
      RelationshipTypeRepository._constructor();

  factory RelationshipTypeRepository() => _instance;

  late Box<RelationshipTypeModel> _relationshipTypesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<RelationshipTypeModel>(RelationshipTypeModelAdapter());
    _relationshipTypesBox =
        await Hive.openBox<RelationshipTypeModel>(_relationshipTypeBox);
  }

  Future<void> saveRelationshipTypeItems(
      List<RelationshipTypeDto> relationshipTypesDto) async {
    for (var relationshipTypeDto in relationshipTypesDto) {
      await _relationshipTypesBox.put(
          relationshipTypeDto.relationshipTypeId,
          (RelationshipTypeModel(
              relationshipTypeId: relationshipTypeDto.relationshipTypeId,
              description: relationshipTypeDto.description)));
    }
  }

  Future<void> saveRelationshipType(
      RelationshipTypeDto relationshipTypeDto) async {
    await _relationshipTypesBox.put(
        relationshipTypeDto.relationshipTypeId,
        RelationshipTypeModel(
            relationshipTypeId: relationshipTypeDto.relationshipTypeId,
            description: relationshipTypeDto.description));
  }

  Future<void> deleteRelationshipType(int id) async {
    await _relationshipTypesBox.delete(id);
  }

  Future<void> deleteAllRelationshipTypes() async {
    await _relationshipTypesBox.clear();
  }

  List<RelationshipTypeDto> getAllRelationshipTypes() {
    return _relationshipTypesBox.values.map(relationshipTypeFromDb).toList();
  }

  RelationshipTypeDto? getRelationshipTypeById(int id) {
    final bookDb = _relationshipTypesBox.get(id);
    if (bookDb != null) {
      return relationshipTypeFromDb(bookDb);
    }
    return null;
  }

  RelationshipTypeDto relationshipTypeFromDb(
          RelationshipTypeModel? relationshipTypeModel) =>
      RelationshipTypeDto(
          relationshipTypeId: relationshipTypeModel?.relationshipTypeId,
          description: relationshipTypeModel?.description);

  RelationshipTypeModel relationshipTypeToDb(
          RelationshipTypeDto? relationshipTypeDto) =>
      RelationshipTypeModel(
          relationshipTypeId: relationshipTypeDto?.relationshipTypeId,
          description: relationshipTypeDto?.description);
}
