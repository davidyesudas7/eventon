import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/repositories/listing_repository_impl.dart';
import '../../domain/entities/listing_details_data.dart';
import '../../domain/repositories/listing_repository.dart';

export '../../domain/entities/listing_details_data.dart';

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ListingRepositoryImpl(apiClient);
});

final listingDetailsProvider =
    FutureProvider.autoDispose.family<ListingDetailsData, String>((ref, id) {
  final repository = ref.watch(listingRepositoryProvider);
  return repository.getListingDetails(id);
});
