import 'syncing/school_sync/school_sync.dart';

class BackgroundJobOfflineSchool {
  final _schoolSync = SchoolSync();

  Future<void> startRunningBackgroundSyncSchool() async {
    await _schoolSync.syncGrades();
    await _schoolSync.syncSchoolTypes();
  }
}
