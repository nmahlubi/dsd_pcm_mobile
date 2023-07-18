import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/child_notification/user_access_rights_dto.dart';
import '../../model/intake/auth_token.dart';
import '../../service/intake/authenticate_user.dart';
import '../../sessions/session.dart';
import '../../util/shared/apierror.dart';
import '../../util/shared/apiresponse.dart';
import '../../util/shared/loading_overlay.dart';
import '../welcome/dashboard.dart';

class LoginAuthenticatePage extends StatefulWidget {
  const LoginAuthenticatePage({Key? key, required String title})
      : super(key: key);

  @override
  State<LoginAuthenticatePage> createState() =>
      _LoginAuthenticatePageWidgetState();
}

class _LoginAuthenticatePageWidgetState extends State<LoginAuthenticatePage> {
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  final _authenticateUserClient = AuthenticateUser();
  final _loginFormKey = GlobalKey<FormState>();
  late ApiResponse apiResponse = ApiResponse();
  late ApiResponse accessRightsApiResponse = ApiResponse();
  late AuthToken authToken = AuthToken();
  late UserAccessRightsDto userAccessRightsDto = UserAccessRightsDto();

  //controls
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initializePreference().whenComplete(() {
        // now preferences is accessible
        //print(preferences?.getKeys());
        setState(() {});
      });
      clearFields();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  authenticateUser() async {
    final overlay = LoadingOverlay.of(context);
    final navigator = Navigator.of(context);
    overlay.show();

    apiResponse = await _authenticateUserClient.login(usernameController.text,
        passwordController.text, '00000000000000', 'Model');

    if ((apiResponse.ApiError) == null) {
      authToken = (apiResponse.Data as AuthToken);
      await setTokenPreferenceSession(authToken);
      overlay.hide();
      Session session = Session();

      navigator.push(
        MaterialPageRoute(
            builder: (context) => DashboardPage(session: session, title: '')),
      );
    } else {
      showDialogMessage((apiResponse.ApiError as ApiError));
      overlay.hide();
    }
  }

  showDialogMessage(ApiError apiError) {
    final messageDialog = ScaffoldMessenger.of(context);
    messageDialog.showSnackBar(
      SnackBar(content: Text(apiError.error!), backgroundColor: Colors.red),
    );
  }

  clearFields() async {
    usernameController.clear();
    passwordController.clear();
  }

  setTokenPreferenceSession(AuthToken authToken) async {
    await preferences?.setInt('userId', authToken.userId!);
    await preferences?.setString('firstname', authToken.firstname!);
    await preferences?.setString('username', authToken.username!);
    await preferences?.setString('token', authToken.token!);
    await preferences?.setBool('supervisor', authToken.supervisor!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(0),
                child: Form(
                    key: _loginFormKey,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            child: Image.asset("images/dsd.png",
                                height: 100,
                                width: 280,
                                filterQuality: FilterQuality.high)),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            child: const Text(
                              'PCM',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            child: const Text(
                              'Version : 3.0.0.0',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'Sign in',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            height: 70,
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 2),
                            child: ElevatedButton(
                              child: const Text('SIGN IN'),
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  authenticateUser();
                                }
                              },
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('By signing in, I agree to the'),
                            TextButton(
                              child: const Text(
                                'T&Cs',
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                //signup screen
                              },
                            )
                          ],
                        ),
                      ],
                    )))));
  }
}
