class AuthToken {
  AuthToken({
    int? userId,
    String? username,
    String? firstname,
    bool? success,
    String? message,
    String? token,
    bool? supervisor,
  }) {
    _userId = userId;
    _username = username;
    _firstname = firstname;
    _success = success;
    _username = username;
    _token = token;
    _supervisor = supervisor;
  }

  AuthToken.fromJson(dynamic json) {
    _userId = json['userId'];
    _username = json['username'];
    _firstname = json['firstname'];
    _success = json['success'];
    _message = json['message'];
    _token = json['token'];
    _supervisor = json['supervisor'];
  }
  int? _userId;
  String? _username;
  String? _firstname;
  bool? _success;
  String? _message;
  String? _token;
  bool? _supervisor;

  int? get userId => _userId;
  String? get username => _username;
  String? get firstname => _firstname;
  bool? get success => _success;
  String? get message => _message;
  String? get token => _token;
  bool? get supervisor => _supervisor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['username'] = _username;
    map['firstname'] = _firstname;
    map['success'] = _success;
    map['message'] = _message;
    map['token'] = _token;
    map['supervisor'] = _supervisor;
    return map;
  }
}
