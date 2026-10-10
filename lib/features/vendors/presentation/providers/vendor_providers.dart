import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/datasources/vendor_remote_data_source.dart';
import '../../data/repositories/vendor_repository_impl.dart';
import '../../domain/entities/vendor_listing.dart';
import '../../domain/entities/vendor_profile.dart';
import '../../domain/entities/vendor_review.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../../domain/usecases/get_vendor_listings_usecase.dart';
import '../../domain/usecases/get_vendor_profile_usecase.dart';
import '../../domain/usecases/get_vendor_reviews_usecase.dart';

part 'vendor_providers.g.dart';

// --- Data Source & Repository Providers ---

@riverpod
VendorRemoteDataSource vendorRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VendorRemoteDataSourceImpl(apiClient);
}

@riverpod
VendorRepository vendorRepository(Ref ref) {
  final remoteDataSource = ref.watch(vendorRemoteDataSourceProvider);
  return VendorRepositoryImpl(remoteDataSource);
}

// --- Use Case Providers ---

@riverpod
GetVendorProfileUseCase getVendorProfileUseCase(Ref ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return GetVendorProfileUseCase(repository);
}

@riverpod
GetVendorListingsUseCase getVendorListingsUseCase(Ref ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return GetVendorListingsUseCase(repository);
}

@riverpod
GetVendorReviewsUseCase getVendorReviewsUseCase(Ref ref) {
  final repository = ref.watch(vendorRepositoryProvider);
  return GetVendorReviewsUseCase(repository);
}

// --- Vendor Profile Provider ---

@riverpod
Future<VendorProfile> vendorProfile(Ref ref, String vendorId) async {
  final useCase = ref.watch(getVendorProfileUseCaseProvider);
  final result = await useCase(vendorId);
  return result.fold(
    (failure) => throw failure.message,
    (profile) => profile,
  );
}

// --- Vendor Listings Provider ---

@riverpod
Future<List<VendorListing>> vendorListings(Ref ref, String vendorId) async {
  final useCase = ref.watch(getVendorListingsUseCaseProvider);
  final result = await useCase(vendorId);
  return result.fold(
    (failure) => throw failure.message,
    (listings) => listings,
  );
}

// --- Lazy-Loading Paginated Reviews State & Notifier ---

class VendorReviewsState {
  final List<VendorReview> reviews;
  final int total;
  final int currentPage;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  const VendorReviewsState({
    this.reviews = const [],
    this.total = 0,
    this.currentPage = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  VendorReviewsState copyWith({
    List<VendorReview>? reviews,
    int? total,
    int? currentPage,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return VendorReviewsState(
      reviews: reviews ?? this.reviews,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }

  double? get averageRating {
    if (reviews.isEmpty) return null;
    final sum = reviews.fold<num>(0, (prev, r) => prev + r.rating);
    return sum / reviews.length;
  }
}

@riverpod
class VendorReviewsNotifier extends _$VendorReviewsNotifier {
  static const int _pageSize = 10;

  @override
  VendorReviewsState build(String vendorId) {
    Future.microtask(() => loadInitial(vendorId));
    return const VendorReviewsState(isLoading: true);
  }

  Future<void> loadInitial(String vendorId) async {
    final useCase = ref.read(getVendorReviewsUseCaseProvider);
    state = state.copyWith(isLoading: true, error: null);
    final result = await useCase(
      GetVendorReviewsParams(vendorId: vendorId, page: 1, limit: _pageSize),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (paginated) {
        state = state.copyWith(
          reviews: paginated.items,
          total: paginated.total,
          currentPage: 1,
          isLoading: false,
          hasMore: paginated.items.length < paginated.total,
          error: null,
        );
      },
    );
  }

  Future<void> loadMore(String vendorId) async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final useCase = ref.read(getVendorReviewsUseCaseProvider);

    final result = await useCase(
      GetVendorReviewsParams(
        vendorId: vendorId,
        page: nextPage,
        limit: _pageSize,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false, error: failure.message);
      },
      (paginated) {
        final updatedList = [...state.reviews, ...paginated.items];
        state = state.copyWith(
          reviews: updatedList,
          total: paginated.total,
          currentPage: nextPage,
          isLoadingMore: false,
          hasMore: updatedList.length < paginated.total,
          error: null,
        );
      },
    );
  }

  Future<void> refresh(String vendorId) async {
    await loadInitial(vendorId);
  }
}
