import '../../data/models/location_models.dart';

abstract interface class TerritoryRepository {
  Future<PincodeDetails?> getPincodeDetails(String pincode);
  Future<List<LsgDetails>> searchLsg(String query, {String state = 'Kerala'});
  Future<HomeLocation?> getSavedLocation();
  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg);
  Future<void> saveFromLogin(String? pincode, String? lsgId);
  Future<void> clearLocation();
}
