import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/form_of_notification_dto.dart';
import '../../db_model_hive/lookup/form_of_notification.model.dart';

const String formOfNotificationBox = 'formOfNotificationBox';

class FormOfNotificationRepository {
  FormOfNotificationRepository._constructor();

  static final FormOfNotificationRepository _instance =
      FormOfNotificationRepository._constructor();

  factory FormOfNotificationRepository() => _instance;

  late Box<FormOfNotificationModel> _formOfNotificationesBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<FormOfNotificationModel>(
        FormOfNotificationModelAdapter());
    _formOfNotificationesBox =
        await Hive.openBox<FormOfNotificationModel>(formOfNotificationBox);
  }

  Future<void> saveFormOfNotificationItems(
      List<FormOfNotificationDto> formOfNotificationsDto) async {
    for (var formOfNotificationDto in formOfNotificationsDto) {
      await _formOfNotificationesBox.put(
          formOfNotificationDto.formOfNotificationId,
          (FormOfNotificationModel(
              formOfNotificationId: formOfNotificationDto.formOfNotificationId,
              description: formOfNotificationDto.description)));
    }
  }

  Future<void> saveFormOfNotification(
      FormOfNotificationDto formOfNotificationDto) async {
    await _formOfNotificationesBox.put(
        formOfNotificationDto.formOfNotificationId,
        FormOfNotificationModel(
            formOfNotificationId: formOfNotificationDto.formOfNotificationId,
            description: formOfNotificationDto.description));
  }

  Future<void> deleteFormOfNotification(int id) async {
    await _formOfNotificationesBox.delete(id);
  }

  Future<void> deleteAllFormOfNotifications() async {
    await _formOfNotificationesBox.clear();
  }

  List<FormOfNotificationDto> getAllFormOfNotifications() {
    return _formOfNotificationesBox.values
        .map(formOfNotificationFromDb)
        .toList();
  }

  FormOfNotificationDto? getFormOfNotificationById(int id) {
    final bookDb = _formOfNotificationesBox.get(id);
    if (bookDb != null) {
      return formOfNotificationFromDb(bookDb);
    }
    return null;
  }

  FormOfNotificationDto formOfNotificationFromDb(
          FormOfNotificationModel formOfNotificationModel) =>
      FormOfNotificationDto(
        formOfNotificationId: formOfNotificationModel.formOfNotificationId,
        description: formOfNotificationModel.description,
      );

  FormOfNotificationModel FormOfNotificationToDb(
          FormOfNotificationDto? formOfNotificationDto) =>
      FormOfNotificationModel(
          formOfNotificationId: formOfNotificationDto?.formOfNotificationId,
          description: formOfNotificationDto?.description);
}
