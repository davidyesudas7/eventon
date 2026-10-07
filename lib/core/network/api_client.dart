import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/auth/data/models/auth_request_dtos.dart';
import '../../features/auth/data/models/auth_response_model.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/categories/data/models/category_model.dart';
import '../../features/categories/data/models/occasion_detail_model.dart';
import '../../features/categories/data/models/occasion_model.dart';
import '../../features/explore/data/models/search_result_model.dart';
import '../../features/listings/data/models/listing_detail_model.dart';
import '../../features/listings/data/models/package_model.dart';
import '../../features/listings/data/models/review_model.dart';
import '../../features/listings/data/models/vendor_profile_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.eventongo.in")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/categories")
  Future<List<CategoryModel>> getCategories();

  @GET("/categories/{id}")
  Future<CategoryModel> getCategory(@Path("id") String id);

  @GET("/occasions")
  Future<List<OccasionModel>> getOccasions();

  @GET("/occasions/{slug}")
  Future<OccasionDetailModel> getOccasion(@Path("slug") String slug);

  @GET("/discovery/search")
  Future<SearchResultModel> search(@Queries() Map<String, dynamic> queries);

  @GET("/listings/{id}")
  Future<ListingDetailModel> getListing(@Path("id") String id);

  @GET("/vendors/{id}")
  Future<VendorProfileModel> getVendor(@Path("id") String id);

  @GET("/reviews/listing/{listingId}")
  Future<PaginatedReviewsModel> getListingReviews(
    @Path("listingId") String id, {
    @Query("page") int page = 1,
    @Query("limit") int limit = 20,
  });

  @GET("/listings/{listingId}/packages")
  Future<List<PackageModel>> getListingPackages(@Path("listingId") String id);

  @POST("/auth/login")
  Future<AuthResponseModel> login(@Body() LoginDto dto);

  @POST("/auth/register")
  Future<AuthResponseModel> register(@Body() RegisterDto dto);

  @POST("/auth/firebase")
  Future<AuthResponseModel> firebaseSignIn(@Body() FirebaseSignInDto dto);

  @POST("/auth/refresh")
  Future<AuthResponseModel> refreshToken(@Body() RefreshTokenDto dto);

  @POST("/auth/logout")
  Future<void> logout();

  @GET("/auth/me")
  Future<UserModel> getMe();

  @POST("/auth/forgot-password")
  Future<void> forgotPassword(@Body() ForgotPasswordDto dto);
}
