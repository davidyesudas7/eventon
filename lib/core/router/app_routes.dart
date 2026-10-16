abstract final class AppRoutes {
  // --- Route Names (used for context.goNamed and context.pushNamed) ---
  static const String home = 'home';
  static const String allServices = 'allServices';
  static const String occasion = 'occasion';
  static const String homeListingDetails = 'homeListingDetails';
  static const String homeVendorProfile = 'homeVendorProfile';

  static const String explore = 'explore';
  static const String exploreSearch = 'exploreSearch';
  static const String exploreLocation = 'exploreLocation';
  static const String exploreListingDetails = 'exploreListingDetails';
  static const String exploreVendorProfile = 'exploreVendorProfile';

  static const String bookings = 'bookings';
  static const String bookingDetails = 'bookingDetails';

  static const String chats = 'chats';
  static const String chatDetails = 'chatDetails';

  static const String profile = 'profile';

  static const String signInMobile = 'signInMobile';
  static const String signInEmail = 'signInEmail';
  static const String signUpEmail = 'signUpEmail';
  static const String otpVerify = 'otpVerify';
  static const String completeProfile = 'completeProfile';

  static const String requestQuotes = 'requestQuotes';
  static const String quoteRequests = 'quoteRequests';
  static const String quoteRequestDetails = 'quoteRequestDetails';

  static const String vendorProfile = 'vendorProfile';

  // --- Path Constants (used in GoRouter route definitions & redirects) ---
  static const String homePath = '/home';
  static const String allServicesPath = 'all-services';
  static const String occasionPath = 'occasion/:slug';
  static const String listingDetailsPath = 'listing/:id';
  static const String vendorDetailsPath = 'vendor/:id';

  static const String explorePath = '/explore';
  static const String exploreSearchPath = 'search';
  static const String exploreLocationPath = 'location';

  static const String bookingsPath = '/bookings';
  static const String bookingDetailsSubPath = ':id';

  static const String chatsPath = '/chats';
  static const String chatDetailsSubPath = ':id';

  static const String profilePath = '/profile';

  static const String signInMobilePath = '/sign-in-mobile';
  static const String signInEmailPath = '/sign-in-email';
  static const String signUpEmailPath = '/sign-up-email';
  static const String otpVerifyPath = '/otp-verify';
  static const String completeProfilePath = '/complete-profile';

  static const String requestQuotesPath = '/request-quotes';
  static const String quoteRequestsPath = '/quote-requests';
  static const String quoteRequestDetailsSubPath = ':id';

  static const String vendorProfilePath = '/vendors/:id';
}
