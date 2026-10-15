import '../../domain/repositories/territory_repository.dart';
import '../datasources/territory_local_data_source.dart';
import '../datasources/territory_remote_data_source.dart';
import '../models/location_models.dart';

class TerritoryRepositoryImpl implements TerritoryRepository {
  final TerritoryRemoteDataSource remoteDataSource;
  final TerritoryLocalDataSource localDataSource;

  TerritoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<PincodeDetails?> getPincodeDetails(String pincode) {
    if (pincode.length != 6) return Future.value(null);
    return remoteDataSource.getPincodeDetails(pincode);
  }

  @override
  Future<List<LsgDetails>> searchLsg(String query, {String state = 'Kerala'}) {
    if (query.trim().length < 2) return Future.value([]);
    return remoteDataSource.searchLsg(query, state: state);
  }

  @override
  Future<HomeLocation?> getSavedLocation() async {
    final raw = await localDataSource.getSavedLocationRaw();
    if (raw == null) return null;

    try {
      final pincode = raw['pincode'] as String?;
      final lsgJson = raw['lsgDetails'] as Map<String, dynamic>?;

      LsgDetails? lsgDetails;
      if (lsgJson != null) {
        lsgDetails = LsgDetails.fromJson(lsgJson);
      }

      if (pincode != null && pincode.length == 6) {
        final pinDetails = await remoteDataSource.getPincodeDetails(pincode);
        if (pinDetails != null) {
          return HomeLocation(pincodeDetails: pinDetails, lsgDetails: lsgDetails);
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg) {
    return localDataSource.saveLocation(pin, lsg);
  }

  @override
  Future<void> saveFromLogin(String? pincode, String? lsgId) {
    return localDataSource.saveFromLogin(pincode, lsgId);
  }

  @override
  Future<void> clearLocation() {
    return localDataSource.clearLocation();
  }
}
