import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/datasources/territory_local_data_source.dart';
import '../../data/datasources/territory_remote_data_source.dart';
import '../../data/models/location_models.dart';
import '../../data/repositories/territory_repository_impl.dart';
import '../../domain/repositories/territory_repository.dart';

part 'home_location_provider.g.dart';

final territoryRepositoryProvider = Provider<TerritoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TerritoryRepositoryImpl(
    remoteDataSource: TerritoryRemoteDataSourceImpl(dio),
    localDataSource: TerritoryLocalDataSourceImpl(),
  );
});

@riverpod
class HomeLocationState extends _$HomeLocationState {
  @override
  Future<HomeLocation?> build() async {
    final repository = ref.watch(territoryRepositoryProvider);
    return repository.getSavedLocation();
  }

  Future<void> saveLocation(PincodeDetails pin, LsgDetails? lsg) async {
    final repository = ref.read(territoryRepositoryProvider);
    await repository.saveLocation(pin, lsg);
    state = AsyncData(HomeLocation(pincodeDetails: pin, lsgDetails: lsg));
  }

  Future<void> saveFromLogin(String? pincode, String? lsgId) async {
    final repository = ref.read(territoryRepositoryProvider);
    await repository.saveFromLogin(pincode, lsgId);
    ref.invalidateSelf();
  }

  Future<void> clearLocation() async {
    final repository = ref.read(territoryRepositoryProvider);
    await repository.clearLocation();
    state = const AsyncData(null);
  }
}

@riverpod
Future<PincodeDetails?> fetchPincode(Ref ref, String pincode) {
  final repository = ref.watch(territoryRepositoryProvider);
  return repository.getPincodeDetails(pincode);
}

@riverpod
Future<List<LsgDetails>> searchLsg(Ref ref, String query) {
  final repository = ref.watch(territoryRepositoryProvider);
  return repository.searchLsg(query);
}
