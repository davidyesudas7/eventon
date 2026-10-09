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
import '../../features/chat/data/models/conversation_model.dart';
import '../../features/chat/data/models/message_model.dart';
import '../../features/quotes/data/models/quote_request_model.dart';
import '../../features/bookings/data/models/booking_model.dart';
import '../../features/bookings/data/models/payment_order_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

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

  @GET("/conversations")
  Future<List<ConversationModel>> getConversations();

  @POST("/conversations")
  Future<ConversationModel> createConversation(
    @Body() Map<String, dynamic> body,
  );

  @GET("/conversations/{id}")
  Future<ConversationModel> getConversation(@Path("id") String id);

  @GET("/conversations/{id}/messages")
  Future<PaginatedMessagesModel> getMessages(
    @Path("id") String id, {
    @Query("limit") int limit = 100,
  });

  @POST("/conversations/{id}/messages")
  Future<MessageModel> sendMessage(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @POST("/conversations/{id}/messages/{messageId}/accept")
  Future<MessageModel> acceptQuote(
    @Path("id") String id,
    @Path("messageId") String messageId,
  );

  @POST("/conversations/{id}/messages/{messageId}/reject")
  Future<MessageModel> rejectQuote(
    @Path("id") String id,
    @Path("messageId") String messageId,
  );

  // @PATCH("/conversations/{id}/read")
  // Future<void> markConversationAsRead(@Path("id") String id);

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

  @POST("/quote-requests")
  Future<QuoteRequestModel> createQuoteRequest(
    @Body() Map<String, dynamic> body,
  );

  @GET("/quote-requests")
  Future<List<QuoteRequestModel>> getQuoteRequests();

  @GET("/quote-requests/{id}")
  Future<QuoteRequestModel> getQuoteRequestById(@Path("id") String id);

  @POST("/quote-requests/{id}/close")
  Future<void> closeQuoteRequest(@Path("id") String id);

  @POST("/bookings/direct")
  Future<BookingModel> createDirectBooking(@Body() Map<String, dynamic> body);

  @GET("/bookings")
  Future<List<BookingModel>> getBookings();

  @GET("/bookings/{id}")
  Future<BookingModel> getBookingById(@Path("id") String id);

  @POST("/bookings/{id}/pay")
  Future<BookingModel> payBooking(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @POST("/reviews")
  Future<ReviewModel> createReview(@Body() Map<String, dynamic> body);

  @POST("/bookings/{id}/dispute")
  Future<BookingModel> disputeBooking(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @POST("/payments/orders")
  Future<PaymentOrderModel> createPaymentOrder(
    @Body() Map<String, dynamic> body,
  );

  @POST("/bookings/{id}/cancel")
  Future<BookingModel> cancelBooking(
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
