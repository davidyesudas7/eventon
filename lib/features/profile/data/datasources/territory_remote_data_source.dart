import 'package:dio/dio.dart';
import '../models/location_models.dart';

abstract interface class TerritoryRemoteDataSource {
  Future<PincodeDetails?> getPincodeDetails(String pincode);
  Future<List<LsgDetails>> searchLsg(String query, {String state = 'Kerala'});
}

class TerritoryRemoteDataSourceImpl implements TerritoryRemoteDataSource {
  final Dio _dio;

  TerritoryRemoteDataSourceImpl(this._dio);

  @override
  Future<PincodeDetails?> getPincodeDetails(String pincode) async {
    try {
      final response = await _dio.get('/territories/reference/pincodes/$pincode');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return PincodeDetails.fromJson(data);
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<List<LsgDetails>> searchLsg(String query, {String state = 'Kerala'}) async {
    try {
      final response = await _dio.get(
        '/territories/reference/lsg-search',
        queryParameters: {
          'state': state,
          'q': query,
        },
      );
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => LsgDetails.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
