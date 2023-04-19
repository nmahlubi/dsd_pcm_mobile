class ForgetUserPassword {
  ForgetUserPassword({
    String? username,
  }) {
    _username = username;
  }

  ForgetUserPassword.fromJson(dynamic json) {
    _username = json['username'];
  }

  String? _username;

  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    return map;
  }
}
