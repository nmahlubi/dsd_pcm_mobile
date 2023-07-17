import 'syncing/lookup_sync/lookup_sync.dart';

class BackgroundJobOfflineLookUp {
  final _lookupSync = LookupSync();

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
  }
}
