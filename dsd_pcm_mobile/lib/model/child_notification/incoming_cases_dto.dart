class IncomingCasesDto {
  IncomingCasesDto({
    int? newIncomingCasesInbox,
  }) {
    _newIncomingCasesInbox = newIncomingCasesInbox;
  }

  IncomingCasesDto.fromJson(dynamic json) {
    _newIncomingCasesInbox = json['newIncomingCasesInbox'];
  }

  int? _newIncomingCasesInbox;

  int? get newIncomingCasesInbox => _newIncomingCasesInbox;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['newIncomingCasesInbox'] = _newIncomingCasesInbox;
    return map;
  }
}
