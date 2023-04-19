class UserAccessRightsDto {
  UserAccessRightsDto({
    bool? supervisor,
    bool? probationOfficer,
  }) {
    _supervisor = supervisor;
    _probationOfficer = probationOfficer;
  }

  UserAccessRightsDto.fromJson(dynamic json) {
    _supervisor = json['supervisor'];
    _probationOfficer = json['probationOfficer'];
  }

  bool? _supervisor;
  bool? _probationOfficer;

  bool? get supervisor => _supervisor;
  bool? get probationOfficer => _probationOfficer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['supervisor'] = _supervisor;
    map['probationOfficer'] = _probationOfficer;
    return map;
  }
}
