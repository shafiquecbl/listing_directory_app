import '../entities/export.dart';
import '../entities/prediction.dart';
import '../entities/suggested_search.dart';
import '../entities/user_appointment.dart';

abstract class BaseServices {
  /// Authentication
  Future<User> login({String username, String password});
  Future<User> appleLogin({String token});
  Future<User> facebookLogin({String token});
  Future<User> googleLogin({String token});
  Future<User> register(
      {String username,
      String password,
      String firstName,
      String lastName,
      String email});
  Future<User> updateProfile(User user, {String img64});

  /// Getting data
  Future<List<Listing>> getListings(
      {int page,
      int perPage,
      List<int> categories,
      List<int> locations,
      List<int> features,
      List<int> include,
      List<int> tags,
      String searchTerm});
  Future<List<Category>> getCategories(
      {int page, int perPage, List<int> categories});
  Future<List<Location>> getLocations(
      {int page, int perPage, List<int> locations});
  Future<List<Feature>> getFeatures(
      {int page, int perPage, List<int> features});
  Future<List<Review>> getReviews({int id, int page, int perPage});
  Future<List<Listing>> getAdListings({
    int page,
    int perPage,
    String adType,
    List<int> categories,
    List<int> locations,
    List<int> features,
    String searchTerm,
  });

  Future<int> createReview(
      {User user, Map<dynamic, dynamic> data, Function updateProgress});
  Future<int> editReview(
      {User user, Map<dynamic, dynamic> data, Function updateProgress});
  Future<int> deleteReview({User user, int reviewId});

  Future<void> addOrRemoveUserFavorite(User user, {int listingId});
  Future<List<Listing>> getUserFavorites({User user, int page, int perPage});

  Future<List<Listing>> getNearestListing(
      {int page,
      int perPage,
      double lat,
      double long,
      String option,
      double distance});

  Future<List<Appointment>> getAppointments({String fullDate, int listingId});
  Future<List<Booking>> getBookings({int userId});

  Future<bool> submitBooking({data});

  void updateView(int listingId, {bool isAd});

  Future<List<PricePlan>> getPricePlans();
  Future<int> submitListing({data});
  Future<List<Listing>> getOwnerListing({User user, int page, int perPage});
  Future<List<Prediction>> getAutoCompletePlaces(
      String term, String sessionToken);
  Future<Prediction> getPlaceDetail(Prediction prediction, String sessionToken);

  Future<Listing> getListingWithLink(String link);
  Future<List<dynamic>> uploadImages(List<dynamic> images64, User user,
      String conversationId, String documentId);
  Future<void> submitMessage(
      {List<dynamic> images64, User user, String conversationId});

  Future<List<UserAppointment>> getUserAppointments(User user,
      {int page, int perPage});
  Future<int> changeUserAppointmentStatus(User user, bookingID, String status);

  Future<int> makePayment(User user,
      {String transactionId,
      String paymentToken,
      String method,
      String listingId,
      String planId});

  Future<Map<String, dynamic>> getPaymentMethods(User user, String planId);

  Future<int> resetPassword(String userLogin, {String otp, String pass});
  Future<int> sendOTP(String userLogin, String otp);

  Future<SuggestedSearch> searchSuggestedListing({String searchTerm});

  Future<Map<dynamic, dynamic>> getAppConfig();
  Future<void> uploadAppConfig();
}
