import 'syncing/lookup_sync/lookup_sync.dart';
import 'syncing/school_sync/school_sync.dart';

class BackgroundJobOfflineLookUp {
  final _lookupSync = LookupSync();
  final _schoolSync = SchoolSync();

  Future<void> startRunningBackgroundSyncLookUpJob() async {
    await _lookupSync.syncGender();
    await _lookupSync.syncDisabilityType();
    await _lookupSync.syncHealthStatuses();
    await _lookupSync.syncIdentificationTypes();
    await _lookupSync.syncLanguages();
    await _lookupSync.syncMaritalStatus();
    await _lookupSync.syncNationalities();
    await _lookupSync.syncPlacementTypes();
    await _lookupSync.syncPreferredContactTypes();
    await _lookupSync.syncRecommendationTypes();
    await _lookupSync.syncRelationshipType();
    await _lookupSync.syncFormOfNotifications();
    await _schoolSync.syncGrades();
    await _schoolSync.syncSchoolTypes();
  }
}
