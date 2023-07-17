class FormOfNotificationDto {
  FormOfNotificationDto({
    int? formOfNotificationId,
    String? description,
  }) {
    _formOfNotificationId = formOfNotificationId;
    _description = description;
  }

  FormOfNotificationDto.fromJson(dynamic json) {
    _formOfNotificationId = json['formOfNotificationId'];
    _description = json['description'];
  }
  int? _formOfNotificationId;
  String? _description;

  int? get formOfNotificationId => _formOfNotificationId;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formOfNotificationId'] = _formOfNotificationId;
    map['description'] = _description;
    return map;
  }
}
