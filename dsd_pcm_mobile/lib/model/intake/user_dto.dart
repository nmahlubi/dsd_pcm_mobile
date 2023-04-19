class UserDto {
  UserDto({
    int? userId,
    String? firstName,
    String? lastName,
    String? initials,
    String? userName,
    String? emailAddress,
  }) {
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _initials = initials;
    _userName = userName;
    _emailAddress = emailAddress;
  }

  UserDto.fromJson(dynamic json) {
    _userId = json['user_Id'];
    _firstName = json['first_Name'];
    _lastName = json['last_Name'];
    _initials = json['initials'];
    _userName = json['user_Name'];
    _emailAddress = json['email_Address'];
  }
  int? _userId;
  String? _firstName;
  String? _lastName;
  String? _initials;
  String? _userName;
  String? _emailAddress;

  int? get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get initials => _initials;
  String? get userName => _userName;
  String? get emailAddress => _emailAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['initials'] = _initials;
    map['userName'] = _userName;
    map['emailAddress'] = _emailAddress;
    return map;
  }
}
