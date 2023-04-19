class ApiError {
  ApiError({String? error}) {
    _error = error;
  }

  ApiError.fromJson(dynamic json) {
    _error = json['message'];
  }
  String? _error;

  String? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _error;
    return map;
  }
}
