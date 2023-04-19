class ProbationOfficerDto {
  ProbationOfficerDto({
    int? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? persalNo,
  }) {
    _userId = userId;
    _username = username;
    _firstName = firstName;
    _lastName = lastName;
    _persalNo = persalNo;
  }

  ProbationOfficerDto.fromJson(dynamic json) {
    _userId = json['userId'];
    _username = json['username'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _persalNo = json['persalNo'];
  }

  int? _userId;
  String? _username;
  String? _firstName;
  String? _lastName;
  String? _persalNo;

  int? get userId => _userId;
  String? get username => _username;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get persalNo => _persalNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = _userId;
    map['username'] = _username;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['persalNo'] = _persalNo;
    return map;
  }

  isEqual(ProbationOfficerDto s) {}
}
