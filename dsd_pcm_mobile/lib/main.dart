import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsd_pcm_mobile/connectivity_check/network_controller.dart';
import 'package:dsd_pcm_mobile/sessions/session.dart';
import 'package:dsd_pcm_mobile/sessions/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
//import 'package:hive_flutter/hive_flutter.dart';

import 'background_job/background_job_offline.dart';
import 'domain/repository/assessment/assesment_register_repository.dart';
import 'domain/repository/assessment/care_giver_detail_repository.dart';
import 'domain/repository/assessment/development_assessment_repository.dart';
import 'domain/repository/assessment/family_information_repository.dart';
import 'domain/repository/assessment/family_member_repository.dart';
import 'domain/repository/assessment/general_detail_repository.dart';
import 'domain/repository/assessment/medical_health_detail_repository.dart';
import 'domain/repository/assessment/offence_detail_repository.dart';
import 'domain/repository/assessment/recommandation_repository.dart';
import 'domain/repository/assessment/socio_economic_repository.dart';
import 'domain/repository/assessment/victim_detail_repository.dart';
import 'domain/repository/assessment/victim_organisation_repository.dart';
import 'domain/repository/authenticate/authenticate_repository.dart';
import 'domain/repository/dashboard/dashboard_repository.dart';
import 'domain/repository/intake/address_repository.dart';
import 'domain/repository/intake/address_type_repository.dart';
import 'domain/repository/intake/offence_category_repository.dart';
import 'domain/repository/intake/offence_schedule_repository.dart';
import 'domain/repository/intake/offence_type_repository.dart';
import 'domain/repository/intake/person_address_repository.dart';
import 'domain/repository/intake/person_education_repository.dart';
import 'domain/repository/intake/person_repository.dart';
import 'domain/repository/lookup/disability_type_repository.dart';
import 'domain/repository/lookup/form_of_notification_repository.dart';
import 'domain/repository/lookup/gender_repository.dart';
import 'domain/repository/lookup/identification_type_repository.dart';
import 'domain/repository/lookup/language_repository.dart';
import 'domain/repository/lookup/marital_status_repository.dart';
import 'domain/repository/lookup/nationality_repository.dart';
import 'domain/repository/lookup/placement_type_repository.dart';
import 'domain/repository/lookup/preferred_contact_type_repository.dart';
import 'domain/repository/lookup/recommendation_type_repository.dart';
import 'domain/repository/lookup/relationship_type_repository.dart';
import 'domain/repository/school/grade_repository.dart';
import 'domain/repository/school/school_repository.dart';
import 'domain/repository/school/school_type_repository.dart';
import 'domain/repository/worklist/accepted_worklist_repository.dart';
import 'domain/repository/lookup/health_status_repository.dart';
import 'pages/authenticate/login_authenticate.dart';
import 'pages/home_based_diversion/home_based_diversion.dart';
import 'pages/preliminary_inquery/preliminary.dart';
import 'pages/probation_officer/accepted_worklist.dart';
import 'pages/probation_officer/allocated_case.dart';
import 'pages/supervisor/notification_cases.dart';
import 'pages/supervisor/overdue_cases.dart';
import 'pages/supervisor/re_assign/re_assigned_cases.dart';
import 'pages/syncing_offline/syncing_offline_manual.dart';
import 'pages/welcome/dashboard.dart';
import 'util/palette.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

const fetchBackground = "fetchBackground";

final _authenticateRepository = AuthenticateRepository();
final _dashboardRepository = DashboardRepository();
final _genderRepository = GenderRepository();
final _acceptedWorklistRepository = AcceptedWorklistRepository();
final _relationshipTypeRepository = RelationshipTypeRepository();
final _healthStatusRepository = HealthStatusRepository();
final _disabilityTypeRepository = DisabilityTypeRepository();
final _languageRepository = LanguageRepository();
final _nationalityRepository = NationalityRepository();
final _maritalStatusRepository = MaritalStatusRepository();
final _identificationTypeRepository = IdentificationTypeRepository();
final _preferredContactTypeRepository = PreferredContactTypeRepository();
final _placementTypeRepository = PlacementTypeRepository();
final _recommendationTypeRepository = RecommendationTypeRepository();
final _recommendationRepository = RecommendationRepository();
final _personRepository = PersonRepository();
final _addressTypeRepository = AddressTypeRepository();
final _familyInformationRepository = FamilyInformationRepository();
final _familyMemberRepository = FamilyMemberRepository();
final _medicalHealthDetailRepository = MedicalHealthDetailRepository();
final _socioEconomicRepository = SocioEconomicRepository();
final _offenceTypeRepository = OffenceTypeRepository();
final _offenceCategoryRepository = OffenceCategoryRepository();
final _offenceScheduleRepository = OffenceScheduleRepository();
final _careGiverDetailRepository = CareGiverDetailRepository();
final _addressRepository = AddressRepository();
final _personAddressRepository = PersonAddressRepository();
final _offenceDetailRepository = OffenceDetailRepository();
final _generalDetailRepository = GeneralDetailRepository();
final _victimOrganisationDetailRepository =
    VictimOrganisationDetailRepository();
final _victimDetailRepository = VictimDetailRepository();
final _developmentAssessmentRepository = DevelopmentAssessmentRepository();
final _gradeRepository = GradeRepository();
final _schoolTypeRepository = SchoolTypeRepository();
final _schoolRepository = SchoolRepository();
final _personEducationRepository = PersonEducationRepository();
final _formOfNotificationRepository = FormOfNotificationRepository();
final _assesmentRegisterRepository = AssesmentRegisterRepository();

///
///
final _backgroundJobOffline = BackgroundJobOffline();

/*
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        // Code to run in background
        log('run test backgroud');
        break;
    }
    return Future.value(true);
  });
}
*/

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print(
        "Native called background task: $fetchBackground"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

Future<void> main() async {
  // var appDocDir = await getApplicationDocumentsDirectory();
  WidgetsFlutterBinding.ensureInitialized();
  await _authenticateRepository.initialize(); //1
  await _genderRepository.initialize(); //2
  await _dashboardRepository.initialize(); //3
  await _acceptedWorklistRepository.initialize(); //4
  await _relationshipTypeRepository.initialize(); //5
  await _healthStatusRepository.initialize(); //6
  await _disabilityTypeRepository.initialize(); //7
  await _languageRepository.initialize(); //8
  await _nationalityRepository.initialize(); //9
  await _maritalStatusRepository.initialize(); //10
  await _identificationTypeRepository.initialize(); //11
  await _preferredContactTypeRepository.initialize(); //12
  await _placementTypeRepository.initialize(); //13
  await _recommendationTypeRepository.initialize(); //14
  await _recommendationRepository.initialize(); //15
  await _personRepository.initialize(); //16
  await _addressTypeRepository.initialize(); //17
  await _familyInformationRepository.initialize(); //18
  await _familyMemberRepository.initialize(); //19
  await _medicalHealthDetailRepository.initialize(); //20
  await _socioEconomicRepository.initialize(); //21
  await _offenceTypeRepository.initialize(); //22
  await _offenceCategoryRepository.initialize(); //23
  await _offenceScheduleRepository.initialize(); //24
  await _careGiverDetailRepository.initialize(); //25
  await _addressRepository.initialize(); //31
  await _personAddressRepository.initialize(); //32
  await _offenceDetailRepository.initialize(); //33
  await _generalDetailRepository.initialize(); //34
  await _victimOrganisationDetailRepository.initialize(); //35
  await _victimDetailRepository.initialize(); //36
  await _developmentAssessmentRepository.initialize(); //38
  await _gradeRepository.initialize(); //39
  await _schoolTypeRepository.initialize(); //40
  await _schoolRepository.initialize(); //41
  await _formOfNotificationRepository.initialize(); //43
  await _assesmentRegisterRepository.initialize(); //44
  await _personEducationRepository.initialize(); //45

/*
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
*/
  // await _backgroundJobOffline.startRunningBackgroundSyncJob();
/*
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    fetchBackground,
    frequency: const Duration(minutes: 20),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );*/

/*
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  Workmanager().registerOneOffTask("1", "simpleTask",
      constraints: Constraints(networkType: NetworkType.connected
          /*,
          requiresBatteryNotLow: true,
          requiresCharging: true,
          requiresDeviceIdle: true,
          requiresStorageNotLow: true
          */
          ));

          */

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  Session session = Session();
  StreamController streamController = StreamController();

  void redirectToLoginPage() {
    if (globalNavigatorKey.currentContext != null) {
      Navigator.pop(globalNavigatorKey.currentContext!);
      Navigator.push(
          globalNavigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) =>
                  LoginAuthenticatePage(title: "Login Page")));
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (globalNavigatorKey.currentContext != null) {
      session.startListener(
          streamController: streamController,
          context: globalNavigatorKey.currentContext!);
    }

    return SessionManager(
      onSessionTimeExpired: () {
        if (globalNavigatorKey.currentContext != null &&
            session.enableLoginPage == true) {
          ScaffoldMessenger.of(globalNavigatorKey.currentContext!)
              .showSnackBar(SnackBar(
                  content: Container(
            color: Colors.black,
            child: const Text(
              'Session Expired',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )));
          redirectToLoginPage();
        }
      },
      //active time 5000= 5 minutes
      duration: const Duration(seconds: 1000),
      streamController: streamController,
      child: MaterialApp(
        title: 'PCM',
        navigatorKey: globalNavigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Palette.kToDark),
        routes: {
          '/': (context) =>
              const LoginAuthenticatePage(title: 'Authentification'),
          '/dashboard': (context) =>
              DashboardPage(session: session, title: 'Dashboard'),
          '/notification-cases': (context) => const NotificationCasesPage(),
          '/allocated-cases': (context) => const AllocatedCasesPage(),
          '/accepted-worklist': (context) => const AcceptedWorklistPage(),
          '/re-assigned-cases': (context) => const ReAssignedCasesPage(),
          '/overdue-cases': (context) => const OverdueCasesPage(),
          '/sync-manual-offline': (context) => const SyncingOfflineManualPage(),
          '/preliminary': (context) => const PreliminaryPage(),
          '/home-based': (context) => const HomeBasedDiversionPage()
        },
      ),
    );
  }
}
