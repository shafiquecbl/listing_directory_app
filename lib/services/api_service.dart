import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../configs/app_config.dart';
import '../configs/layout_config.dart';
import '../configs/site_config.dart';
import '../entities/export.dart';
import '../entities/prediction.dart';
import '../entities/suggested_search.dart';
import '../entities/user_appointment.dart';
import '../tools/tools.dart';
import 'base_services.dart';

class ApiServices implements BaseServices {
  @override
  Future<User> appleLogin({String token}) async {
    try {
      var endPoint =
          '${SiteConfig.siteUrl}/wp-json/authentication/apple-login?access_token=$token';
      var response = await http.post(endPoint);
      var json = jsonDecode(response.body);
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> facebookLogin({String token}) async {
    try {
      var endPoint =
          '${SiteConfig.siteUrl}/wp-json/authentication/facebook-login?&access_token=$token';

      var response = await http.post(endPoint);

      var json = jsonDecode(response.body);

      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> googleLogin({String token}) async {
    try {
      var endPoint =
          '${SiteConfig.siteUrl}/wp-json/authentication/google-login?access_token=$token';

      var response = await http.post(endPoint);

      var json = jsonDecode(response.body);

      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> login({String username, String password}) async {
    try {
      final response = await http
          .post('${SiteConfig.siteUrl}/wp-json/authentication/login', body: {
        'username': username,
        'password': password,
      });

      var json = jsonDecode(response.body);

      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> register(
      {String username,
      String password,
      String firstName,
      String lastName,
      String email}) async {
    try {
      final response = await http
          .post('${SiteConfig.siteUrl}/wp-json/authentication/register', body: {
        'user_email': email,
        'user_login': username,
        'user_pass': password,
        'first_name': firstName,
        'last_name': lastName
      });
      var json = jsonDecode(response.body);

      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> updateProfile(User user, {String img64}) async {
    final _user = user;
    try {
      var data = {
        'display_name': _user.displayName,
        'user_firstname': _user.firstName,
        'user_lastname': _user.lastName,
        'user_id': _user.id.toString(),
        'cookie': _user.cookie,
      };
      if (img64 != null) {
        data['img64'] = img64;
      }
      final response = await http.put(
          '${SiteConfig.siteUrl}/wp-json/authentication/profile',
          body: data);
      var body = jsonDecode(response.body);

      return User.fromJson(body);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Listing>> getListings(
      {int page,
      int perPage,
      List<dynamic> categories,
      List<dynamic> locations,
      List<dynamic> features,
      List<dynamic> include,
      List<dynamic> tags,
      String searchTerm}) async {
    var list = <Listing>[];
    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing?page=$page&per_page=$perPage';
    if (categories != null && categories.isNotEmpty) {
      var category = '';
      for (var cat in categories) {
        category += '$cat,';
      }
      endpoint += '&listing-category=$category';
    }
    if (locations != null && locations.isNotEmpty) {
      var location = '';
      for (var loc in locations) {
        location += '$loc,';
      }
      endpoint += '&location=$location';
    }
    if (features != null && features.isNotEmpty) {
      var feature = '';
      for (var fea in features) {
        feature += '$fea,';
      }
      endpoint += '&features=$feature';
    }
    if (tags != null && tags.isNotEmpty) {
      var listTag = '';
      for (var tag in tags) {
        listTag += '$tag,';
      }
      endpoint += '&list-tags=$listTag';
    }

    if (include != null && include.isNotEmpty) {
      var includes = '';
      for (var inc in include) {
        includes += '$inc,';
      }
      endpoint += '&include=$includes';
    }
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      endpoint += '&search=$searchTerm&orderby=relevance&tax_relation=OR';
    } else {
      endpoint += '&tax_relation=AND';
    }
    log(endpoint);
    var response = await http.get(endpoint);
    var result = jsonDecode(response.body);
    if (result is List) {
      for (var item in result) {
        try {
          list.add(Listing.fromJson(item));
        } catch (e) {
          continue;
        }
      }
    }

    return list;
  }

  @override
  Future<List<Category>> getCategories(
      {int page, int perPage, List<int> categories}) async {
    var list = <Category>[];

    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing-category?page=$page&per_page=$perPage';
    if (categories != null && categories.isNotEmpty) {
      var category = '';
      for (var cat in categories) {
        category += '$cat,';
      }
      endpoint += '&include=$category';
    }
    var response = await http.get(endpoint);
    var result = jsonDecode(response.body);
    for (var item in result) {
      list.add(Category.fromJson(item));
    }

    return list;
  }

  @override
  Future<List<Feature>> getFeatures(
      {int page, int perPage, List<int> features}) async {
    var features = <Feature>[];

    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/features?page=$page&per_page=$perPage';
    if (features != null && features.isNotEmpty) {
      var feature = '';
      for (var f in features) {
        feature += '$f,';
      }
      endpoint += '&include=$feature';
    }

    var response = await http.get(endpoint);
    var result = jsonDecode(response.body);
    for (var item in result) {
      features.add(Feature.fromJson(item));
    }

    return features;
  }

  @override
  Future<List<Location>> getLocations(
      {int page, int perPage, List<int> locations}) async {
    var list = <Location>[];

    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/location?page=$page&per_page=$perPage';
    if (locations != null && locations.isNotEmpty) {
      var location = '';
      for (var loc in locations) {
        location += '$loc,';
      }
      endpoint += '&include=$location';
    }
    var response = await http.get(endpoint);
    var result = jsonDecode(response.body);
    for (var item in result) {
      list.add(Location.fromJson(item));
    }

    return list;
  }

  @override
  Future<List<Review>> getReviews({int id, int page, int perPage}) async {
    var list = <Review>[];

    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/getReviews/$id?page=$page&per_page=$perPage';
    log(endpoint);
    var response = await http.get(endpoint);

    var result = jsonDecode(response.body);
    for (var item in result) {
      list.add(Review.fromJson(item));
    }

    return list;
  }

  @override
  Future<int> createReview(
      {User user, Map<dynamic, dynamic> data, Function updateProgress}) async {
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/reviews';
    data['cookie'] = user.cookie;
    try {
      var result = await Dio().post(
        endPoint,
        data: data,
        onSendProgress: (int sent, int total) {
          updateProgress(sent, total);
        },
      );
      return result.data['code'];
    } catch (e) {
      log('createReview $e');
      return -1;
    }
  }

  @override
  Future<int> deleteReview({User user, int reviewId}) async {
    try {
      var endPoint =
          '${SiteConfig.siteUrl}/wp-json/wp/v2/reviews?id=$reviewId&cookie=${user.cookie}';
      var result = await Dio().delete(endPoint);
      return result.data['code'];
    } catch (e) {
      log('deleteReview $e');
      return -1;
    }
  }

  @override
  Future<int> editReview(
      {User user, Map<dynamic, dynamic> data, Function updateProgress}) async {
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/reviews';
    var token = Tools.stringBase64Encode(user.cookie);
    data['token'] = token;
    try {
      var result = await Dio().put(
        endPoint,
        data: data,
        onSendProgress: (int sent, int total) {
          updateProgress(sent, total);
        },
      );
      return result.data['code'];
    } catch (e) {
      log('editReview $e');
      return -1;
    }
  }

  @override
  Future<void> addOrRemoveUserFavorite(User user, {int listingId}) async {
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/favorites';
    var token = Tools.stringBase64Encode(user.cookie);
    await http.post(endPoint,
        body: {'listing_id': listingId.toString(), 'token': token});
  }

  @override
  Future<List<Listing>> getUserFavorites(
      {User user, int page, int perPage}) async {
    var list = <Listing>[];
    var token = Tools.stringBase64Encode(user.cookie);
    var endPoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/favorites?page=$page&per_page=$perPage&token=$token';

    var response = await http.get(endPoint);
    for (var item in jsonDecode(response.body)) {
      try {
        list.add(Listing.fromJson(item));
      } catch (e) {
        continue;
      }
    }
    return list;
  }

  @override
  Future<List<Listing>> getNearestListing(
      {int page,
      int perPage,
      double lat,
      double long,
      String option,
      double distance = 10}) async {
    final list = <Listing>[];

    var endPoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing-v2?lat=$lat&long=$long&option=$option&page=$page&per_page=$perPage&distance=$distance';
    var response = await http.get(endPoint);

    if (response.statusCode == 200) {
      for (var item in jsonDecode(response.body)) {
        try {
          final tmp = Listing.fromJson(item);
          if (tmp.lpListingproOptions.longitude != null &&
              tmp.lpListingproOptions.latitude != null) {
            list.add(tmp);
          }
        } catch (e) {
          continue;
        }
      }
    }
    return list;
  }

  @override
  Future<List<Appointment>> getAppointments(
      {String fullDate, int listingId}) async {
    var list = <Appointment>[];
    var endPoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/get-booking?dataFullDate=$fullDate&lid=$listingId';
    log(endPoint);
    var response = await http.get(endPoint);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      if (jsonDecode(response.body) is String) {
        list.add(Appointment(true));
        return list;
      }
      for (var item in jsonDecode(response.body)) {
        try {
          final tmp = Appointment.fromJson(item);
          list.add(tmp);
        } catch (e) {
          continue;
        }
      }
    }
    return list;
  }

  @override
  Future<bool> submitBooking({data}) async {
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/bookings';
    try {
      await Dio().post(endPoint, data: data);
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<List<Booking>> getBookings({int userId}) async {
    var list = <Booking>[];
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/bookings?id=$userId';
    log(endPoint);
    var response = await http.get(endPoint);
    for (var item in jsonDecode(response.body)) {
      list.add(Booking.fromJson(item));
    }
    return list;
  }

  @override
  void updateView(int listingId, {bool isAd = false}) {
    var endPoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/view?id=$listingId&is_ad=$isAd';
    http.post(endPoint);
  }

  @override
  Future<List<Listing>> getAdListings({
    int page,
    int perPage,
    String adType,
    List<int> categories,
    List<int> locations,
    List<int> features,
    String searchTerm,
  }) async {
    var list = <Listing>[];
    var endpoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/ads?skip_cache=1&page=$page&per_page=$perPage&ad_type=$adType';
    if (categories != null && categories.isNotEmpty) {
      var category = '';
      for (var cat in categories) {
        category += '$cat,';
      }
      endpoint += '&listing-category=$category';
    }
    if (locations != null && locations.isNotEmpty) {
      var location = '';
      for (var loc in locations) {
        location += '$loc,';
      }
      endpoint += '&location=$location';
    }
    if (features != null && features.isNotEmpty) {
      var feature = '';
      for (var fea in features) {
        feature += '$fea,';
      }
      endpoint += '&features=$feature';
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      endpoint += '&search=$searchTerm';
    }
    log(endpoint);
    var response = await http.get(endpoint);
    var result = jsonDecode(response.body);
    for (var item in result) {
      list.add(Listing.fromJson(item));
    }
    return list;
  }

  @override
  Future<List<PricePlan>> getPricePlans() async {
    var list = <PricePlan>[];
    try {
      var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/price_plan';
      log(endPoint);
      var response = await http.get(endPoint);
      var result = jsonDecode(response.body);
      for (var item in result) {
        list.add(PricePlan.fromJson(item));
      }
    } catch (e) {
      log('getPricePlans $e');
      rethrow;
    }
    return list;
  }

  @override
  Future<int> submitListing({data}) async {
    var endPoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/submit';
    log(endPoint);
    try {
      await Dio().post(
        endPoint,
        data: data,
        onSendProgress: (int sent, int total) {},
      );
    } catch (e) {
      log('submitListing $e');
      return 0;
    }
    return 1;
  }

  @override
  Future<List<Listing>> getOwnerListing(
      {User user, int page, int perPage}) async {
    var list = <Listing>[];
    var token = Tools.stringBase64Encode(user.cookie);
    var endPoint =
        '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/mine?skip_cache=1&token=$token&page=$page&per_page=$perPage';
    log(endPoint);
    try {
      var response = await Dio().get(
        endPoint,
      );

      for (var item in response.data) {
        list.add(Listing.fromJson(item));
      }
    } catch (e) {
      log('getOwnerListing $e');
    }
    return list;
  }

  @override
  Future<List<Prediction>> getAutoCompletePlaces(
      String term, String sessionToken) async {
    final isIOS = Platform.isIOS;
    var list = <Prediction>[];
    try {
      var endpoint =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$term&key=${isIOS ? AppConfig.googleIOSMapApi : AppConfig.googleAndroidMapApi}&sessiontoken=$sessionToken';
      if (AppConfig.restrictedCountries != null &&
          AppConfig.restrictedCountries.isNotEmpty) {
        endpoint += '&components=';
        for (var country in AppConfig.restrictedCountries) {
          endpoint += 'country:$country|';
        }
        endpoint = endpoint.substring(0, endpoint.length - 1);
      }
      log(endpoint);
      var response = await Dio().get(endpoint);
      for (var item in response.data['predictions']) {
        list.add(Prediction.fromJson(item));
      }
      return list;
    } catch (e) {
      log('getAutoCompletePlaces - $e');
    }
    return list;
  }

  @override
  Future<Prediction> getPlaceDetail(
      Prediction prediction, String sessionToken) async {
    final isIOS = Platform.isIOS;

    try {
      var endpoint =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&fields=geometry&key=${isIOS ? AppConfig.googleIOSMapApi : AppConfig.googleAndroidMapApi}&sessiontoken=$sessionToken';
      var response = await Dio().get(endpoint);
      var lat =
          response.data['result']['geometry']['location']['lat'].toString();
      var long =
          response.data['result']['geometry']['location']['lng'].toString();
      prediction.lat = lat;
      prediction.long = long;
    } catch (e) {
      log('getPlaceDetail - $e');
    }
    return prediction;
  }

  @override
  Future<Listing> getListingWithLink(String link) async {
    try {
      var endpoint =
          '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/post-with-link?link=$link';
      var response = await Dio().get(endpoint);
      return Listing.fromJson(response.data);
    } catch (e) {
      log('getPlaceDetail - $e');
    }
    return null;
  }

  @override
  Future<List<dynamic>> uploadImages(List<dynamic> images64, User user,
      String conversationId, String documentId) async {
    try {
      var token = Tools.stringBase64Encode(user.cookie);
      var endpoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/images';
      var response = await Dio()
          .post(endpoint, data: {'token': token, 'gallery': images64});
      final _fireStore = FirebaseFirestore.instance;
      await _fireStore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(documentId)
          .update({'images': response.data});
      return response.data;
    } catch (e) {
      log('uploadImages - $e');
    }
    return [];
  }

  @override
  Future<void> submitMessage(
      {data, List<dynamic> images64, User user, String conversationId}) async {
    final _fireStore = FirebaseFirestore.instance;
    var document = await _fireStore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(data);
    if (data['message'].toString().trim().isNotEmpty) {
      await _fireStore
          .collection('conversations')
          .doc(conversationId)
          .update({'lastMessage': data['message']});
    }
    var response;
    if (images64.isNotEmpty) {
      var token = Tools.stringBase64Encode(user.cookie);
      var endpoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/images';
      response = await Dio()
          .post(endpoint, data: {'token': token, 'gallery': images64});
      await _fireStore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(document.id)
          .update({'images': response.data});
    }
  }

  @override
  Future<List<UserAppointment>> getUserAppointments(User user,
      {int page = 1, int perPage = 10}) async {
    try {
      var list = <UserAppointment>[];
      var token = Tools.stringBase64Encode(user.cookie);
      var endpoint =
          '${SiteConfig.siteUrl}/wp-json/wp/v2/bookings/appt?token=$token&page=$page&per_page=$perPage';
      log(endpoint);
      var response = await Dio().get(endpoint);
      for (var item in response.data) {
        list.add(UserAppointment.fromJson(item));
      }
      return list;
    } catch (e) {
      log('getUserAppointments - $e');
    }
    return [];
  }

  @override
  Future<int> changeUserAppointmentStatus(
      User user, bookingID, String status) async {
    try {
      var token = Tools.stringBase64Encode(user.cookie);

      var endpoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/bookings/appt';
      var response = await Dio().put(endpoint,
          data: {'token': token, 'booking_id': bookingID, 'status': status});

      if (response.statusCode == 200) {
        return 1;
      }
      return -1;
    } catch (e) {
      log('changeUserAppointmentStatus - $e');
    }
    return -1;
  }

  @override
  Future<int> makePayment(User user,
      {String transactionId,
      String paymentToken,
      String method,
      String listingId,
      String planId}) async {
    try {
      var token = Tools.stringBase64Encode(user.cookie);

      var endpoint = '${SiteConfig.siteUrl}/wp-json/wp/v2/payments';
      var response = await Dio().post(endpoint, data: {
        'token': token,
        'paymentToken': paymentToken,
        'tID': transactionId,
        'listing_id': listingId,
        'plan_id': planId,
        'method': method,
      });

      if (response.statusCode == 200) {
        return response.data['code'];
      }
    } catch (e) {
      log('makePayment - $e');
    }
    return 0;
  }

  @override
  Future<Map<String, dynamic>> getPaymentMethods(
      User user, String planId) async {
    try {
      var token = Tools.stringBase64Encode(user.cookie);

      var endpoint =
          '${SiteConfig.siteUrl}/wp-json/wp/v2/payments?token=$token&plan_id=$planId';
      var response = await Dio().get(endpoint);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('getPaymentMethods - $e');
    }
    return {};
  }

  @override
  Future<int> resetPassword(String userLogin, {String otp, String pass}) async {
    try {
      var endpoint = '${SiteConfig.siteUrl}/wp-json/authentication/reset';
      var data = {
        'user_login': userLogin,
      };
      if (otp != null) {
        data['otp'] = otp;
        data['time_string'] = '5';
      }
      if (pass != null) {
        data['password'] = pass;
      }
      var response = await Dio().post(endpoint, data: data);

      if (response.statusCode == 200) {
        return response.data['code'];
      }
    } catch (e) {
      log('resetPassword - $e');
    }
    return 0;
  }

  @override
  Future<int> sendOTP(String userLogin, String otp) async {
    try {
      var endpoint = '${SiteConfig.siteUrl}/wp-json/authentication/otp';
      var data = {'user_login': userLogin, 'otp': otp, 'time_string': '5'};

      var response = await Dio().post(endpoint, data: data);

      if (response.statusCode == 200) {
        return response.data['code'];
      }
    } catch (e) {
      log('sendOTP - $e');
    }
    return 0;
  }

  @override
  Future<SuggestedSearch> searchSuggestedListing({String searchTerm}) async {
    try {
      var endpoint =
          '${SiteConfig.siteUrl}/wp-json/wp/v2/listing/suggested_search?tagID=$searchTerm';

      var response = await Dio().get(
        endpoint,
      );

      log(endpoint);

      if (response.statusCode == 200) {
        return SuggestedSearch.fromJson(response.data);
      }
    } catch (e) {
      log('searchSuggestedListing - $e');
    }
    return null;
  }

  @override
  Future<Map<dynamic, dynamic>> getAppConfig() async {
    try {
      return LayoutConfig.data;
      // var endpoint = '${SiteConfig.siteUrl}/wp-json/config/get';
      // var response = await Dio().get(endpoint);
      // log(endpoint);
      // if (response.data.isNotEmpty) {
      //   return response.data;
      // }
    } catch (e) {
      log('getAppConfig - $e');
    }
    return LayoutConfig.data;
  }

  @override
  Future<void> uploadAppConfig() async {
    try {
      var endpoint = '${SiteConfig.siteUrl}/wp-json/config/upload';
      await Dio().post(
        endpoint,
        data: {'json': LayoutConfig.data},
      );
      log(endpoint);
    } catch (e) {
      log('uploadAppConfig - $e');
    }
  }
}
