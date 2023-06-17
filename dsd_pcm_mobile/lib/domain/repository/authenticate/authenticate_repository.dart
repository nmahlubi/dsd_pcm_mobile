import 'package:hive_flutter/adapters.dart';

import '../../../model/intake/auth_token.dart';
import '../../db_model_hive/authenticate/auth_token.model.dart';

const String _authTokenBox = 'authTokenHiveBox';

class AuthenticateRepository {
  AuthenticateRepository._constructor();

  static final AuthenticateRepository _instance =
      AuthenticateRepository._constructor();

  factory AuthenticateRepository() => _instance;

  late Box<AuthTokenModel> _authTokensBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter<AuthTokenModel>(AuthTokenModelAdapter());
    _authTokensBox = await Hive.openBox<AuthTokenModel>(_authTokenBox);
  }

  Future<void> saveAuthToken(AuthToken authToken, String? password) async {
    await _authTokensBox.put(
        authToken.userId,
        AuthTokenModel(
            userId: authToken.userId,
            username: authToken.username,
            firstname: authToken.firstname,
            password: password,
            supervisor: authToken.supervisor));
  }

  Future<void> deleteAuthToken(int id) async {
    await _authTokensBox.delete(id);
  }

  Future<void> deleteAllAuthTokens() async {
    await _authTokensBox.clear();
  }

  Future<List<AuthToken>> getAllAuthTokens() async {
    return await _authTokensBox.values.map(_genderFromDb).toList();
  }

  AuthToken? getAuthTokenByUsername(String? username, String? password) {
    var authTokenItems = _authTokensBox.values
        .where((userToken) =>
            userToken.username!.toLowerCase() == username!.toLowerCase() &&
            userToken.password == password)
        .toList();
    if (authTokenItems.isNotEmpty) {
      return _genderFromDb(authTokenItems.first);
    }
    return null;
  }

  AuthToken? getAuthTokenById(int id) {
    final bookDb = _authTokensBox.get(id);
    if (bookDb != null) {
      return _genderFromDb(bookDb);
    }
    return null;
  }

  AuthToken _genderFromDb(AuthTokenModel authTokenModel) => AuthToken(
      userId: authTokenModel.userId,
      username: authTokenModel.username,
      firstname: authTokenModel.firstname,
      supervisor: authTokenModel.supervisor,
      token: "9b4ca593-5f28-4802-b2f7-b234220d05a3");
}
