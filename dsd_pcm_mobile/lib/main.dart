import 'package:flutter/material.dart';

import 'pages/authenticate/login_authenticate.dart';
import 'pages/probation_officer/accepted_worklist.dart';
import 'pages/probation_officer/allocated_case.dart';
import 'pages/supervisor/notification_cases.dart';
import 'pages/supervisor/overdue_cases.dart';
import 'pages/supervisor/re_assign/re_assigned_cases.dart';
import 'pages/welcome/dashboard.dart';
import 'util/palette.dart';
import 'package:workmanager/workmanager.dart';

/*
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print("Task executing :" + taskName);
    return Future.value(true);
  });
}
  */
// Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task:"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

/*
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    print("Native called background task at ${DateTime.now().toString()}");
    getLocation();
    return Future.value(true);
  });
}
*/

Future<void> main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  */
  runApp(const MyApp());
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  runApp(MyApp());
}
*/

/*
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCM',
      theme: ThemeData(primarySwatch: Palette.kToDark),
      routes: {
        '/': (context) =>
            const LoginAuthenticatePage(title: 'Authentification'),
        '/dashboard': (context) => const DashboardPage(title: 'Dashboard'),
        '/notification-cases': (context) => const NotificationCasesPage(),
        '/allocated-cases': (context) => const AllocatedCasesPage(),
        '/accepted-worklist': (context) => const AcceptedWorklistPage(),
        '/re-assigned-cases': (context) => const ReAssignedCasesPage(),
        '/overdue-cases': (context) => const OverdueCasesPage()
      },
      //home: const LoginAuthenticatePage(title: 'Authentification'),
    );
  }
}
