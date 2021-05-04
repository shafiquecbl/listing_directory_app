import 'dart:convert';
import 'dart:math';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/app_config.dart';
import '../configs/app_constants.dart';
import '../entities/user.dart';
import '../services/api_service.dart';
import '../tools/tools.dart';

enum AuthenticationState { notLogin, loggedIn, loading }

class AuthenticationModel extends ChangeNotifier {
  User user;
  var state = AuthenticationState.notLogin;
  final _services = ApiServices();
  final Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData locationData;
  var tmpLoc = LocationData.fromMap({
    'latitude': kGoogleMapConfig['initLatitude'],
    'longitude': kGoogleMapConfig['initLongitude']
  });

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController userNameRegisterController =
      TextEditingController();
  final TextEditingController passwordRegisterController =
      TextEditingController();
  final TextEditingController emailRegisterController = TextEditingController();
  final TextEditingController firstNameRegisterController =
      TextEditingController();
  final TextEditingController lastNameRegisterController =
      TextEditingController();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final PageController controller = PageController();

  AuthenticationModel() {
    _getUserFromLocal();
    _getLocation();
  }

  void _clearLoginDetails() {
    userNameController.clear();
    passwordController.clear();
  }

  void _clearRegistrationDetails() {
    emailRegisterController.clear();
    firstNameRegisterController.clear();
    lastNameRegisterController.clear();
    passwordRegisterController.clear();
    userNameRegisterController.clear();
  }

  void _initController() {
    _clearLoginDetails();
    _clearRegistrationDetails();
    displayNameController.text = user.displayName;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
  }

  void _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    /// For Testing Mode
    locationData = tmpLoc;
    location.onLocationChanged.listen((LocationData currentLocation) {
      if (AppConfig.enableDebugMode) {
        locationData = tmpLoc;
      } else {
        locationData = currentLocation;
      }
    });
  }

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> login() async {
    _updateState(AuthenticationState.loading);
    user = await _services.login(
        username: userNameController.text, password: passwordController.text);
    if (user == null) {
      showToast('loginFailed'.tr());
      _updateState(AuthenticationState.notLogin);
      return;
    }
    _saveUserToLocal();
    _initController();
    _updateState(AuthenticationState.loggedIn);
    showToast('loginSuccess'.tr());
  }

  void logout() {
    FacebookAuth.instance.isLogged.then((value) {
      if (value != null) {
        FacebookAuth.instance.logOut();
      }
    });

    GoogleSignIn().isSignedIn().then((value) {
      if (value) {
        GoogleSignIn().signOut();
      }
    });

    user = null;
    _clearUserFromLocal();
    _updateState(AuthenticationState.notLogin);
    showToast('logoutSuccess'.tr());
  }

  Future<void> facebookLogin() async {
    _updateState(AuthenticationState.loading);
    if (AppConfig.enableDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
      user = AppConfig.testSocialUser;
      _updateState(AuthenticationState.loggedIn);
      _saveUserToLocal();
      _initController();
      showToast('loginSuccess'.tr());
      return;
    }
    try {
      final accessToken = await FacebookAuth.instance.login();

      user = await _services.facebookLogin(token: accessToken.token);
      if (user == null) {
        showToast('loginFailed'.tr());
        _updateState(AuthenticationState.notLogin);
        return;
      }

      _saveUserToLocal();
      _initController();
      _updateState(AuthenticationState.loggedIn);
      showToast('loginSuccess'.tr());
    } on FacebookAuthException catch (e) {
      _updateState(AuthenticationState.notLogin);
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          // print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          // print("login cancelled");
          break;
        case FacebookAuthErrorCode.FAILED:
          // print("login failed ${e.message}");
          break;
      }
    }
  }

  Future<void> googleLogin() async {
    _updateState(AuthenticationState.loading);

    if (AppConfig.enableDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
      user = AppConfig.testSocialUser;
      _updateState(AuthenticationState.loggedIn);
      _saveUserToLocal();
      _initController();
      showToast('loginSuccess'.tr());
      return;
    }

    try {
      final _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      final res = await _googleSignIn.signIn();

      final auth = await res.authentication;

      user = await _services.googleLogin(token: auth.accessToken);
      if (user == null) {
        showToast('loginFailed'.tr());
        _updateState(AuthenticationState.notLogin);
        return;
      }
      _saveUserToLocal();
      _initController();
      _updateState(AuthenticationState.loggedIn);
      showToast('loginSuccess'.tr());
    } catch (e) {
      _updateState(AuthenticationState.notLogin);
    }
  }

  Future<void> appleLogin() async {
    _updateState(AuthenticationState.loading);
    final result = await AppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        {
          user = await _services.appleLogin(
              token: String.fromCharCodes(result.credential.identityToken));

          if (user == null) {
            showToast('loginFailed'.tr());
            _updateState(AuthenticationState.notLogin);
            return;
          }
          _saveUserToLocal();
          _initController();
          _updateState(AuthenticationState.loggedIn);
          showToast('loginSuccess'.tr());
        }
        break;
      case AuthorizationStatus.error:
        {
          showToast('loginFailed'.tr());
          _updateState(AuthenticationState.notLogin);
        }
        break;
      case AuthorizationStatus.cancelled:
        _updateState(AuthenticationState.notLogin);
        break;
    }
  }

  Future<void> register() async {
    _updateState(AuthenticationState.loading);
    try {
      user = await _services.register(
          username: userNameRegisterController.text,
          password: passwordRegisterController.text,
          firstName: firstNameRegisterController.text,
          lastName: lastNameRegisterController.text,
          email: emailRegisterController.text);
      if (user == null) {
        showToast('loginFailed'.tr());
        _updateState(AuthenticationState.notLogin);
        return;
      }
      _saveUserToLocal();
      _initController();
      _updateState(AuthenticationState.loggedIn);
      showToast('loginSuccess'.tr());
    } catch (e) {
      _updateState(AuthenticationState.notLogin);
    }
  }

  Future<void> updateProfile({avatar}) async {
    _updateState(AuthenticationState.loading);
    final _tmpUser = User();
    _tmpUser.copyWith(user);
    user.displayName = displayNameController.text;
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;
    if (avatar is Asset) {
      var byteData = await avatar.getByteData(quality: 100);
      var bytes = byteData.buffer.asUint8List();
      var unit = await Tools.compressList(list: bytes);
      var img64 = base64Encode(unit);
      user = await _services.updateProfile(user, img64: img64);
    } else {
      user = await _services.updateProfile(user);
    }

    if (user == null) {
      user = _tmpUser;
      showToast('updateFailed'.tr());
    } else {
      _saveUserToLocal();
      showToast('updateSuccessfully'.tr());
    }
    _updateState(AuthenticationState.loggedIn);
  }

  void _saveUserToLocal() async {
    final _sharePreferences = await SharedPreferences.getInstance();
    await _sharePreferences.setString('user', jsonEncode(user.toJson()));
  }

  void _clearUserFromLocal() async {
    final _sharePreferences = await SharedPreferences.getInstance();
    await _sharePreferences.remove('user');
  }

  void _getUserFromLocal() async {
    final _sharePreferences = await SharedPreferences.getInstance();
    final value = await _sharePreferences.getString('user');
    if (value == null) {
      _updateState(AuthenticationState.notLogin);
      return;
    }

    user = User.fromJson(jsonDecode(value));
    _initController();
    _updateState(AuthenticationState.loggedIn);
  }

  Future<Asset> pickImages() async {
    try {
      var list =
          await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);
      return list.first;
    } on Exception {
      rethrow;
    }
  }

  Future<int> sendPassOTP(String email) async {
    if (email.trim().isEmpty) {
      return 0;
    }
    final rand = Random();
    var otp = 100000 + rand.nextInt(999999 - 100000);
    var val = await _services.resetPassword(email, otp: otp.toString());
    if (val == 3) {
      showToast('invalidUsername'.tr());
    }
    if (val == 2) {
      showToast('accountNotFound'.tr());
    }
    if (val == 0) {
      showToast('sentEmailFailed'.tr());
    }
    if (val == 1) {
      showToast('checkEmail'.tr());
    } else {
      otp = val;
    }

    return otp;
  }

  Future<int> sendOTP(String email) async {
    if (email.trim().isEmpty) {
      return 0;
    }
    final rand = Random();
    var otp = 100000 + rand.nextInt(999999 - 100000);
    var val = await _services.resetPassword(email, otp: otp.toString());
    if (val == 0) {
      showToast('sentEmailFailed'.tr());
    }
    if (val == 4) {
      showToast('existUser'.tr());
    }
    if (val == 1) {
      showToast('checkEmail'.tr());
    } else {
      otp = val;
    }

    return otp;
  }

  Future<int> resetPassword(String email, String pass) async {
    if (email.trim().isEmpty) {
      return 0;
    }
    var val = await _services.resetPassword(
      email,
      pass: pass,
    );
    if (val == 3) {
      showToast('invalidUsername'.tr());
    }
    if (val == 2) {
      showToast('accountNotFound'.tr());
    }
    if (val == 1) {
      showToast('changePassSuccess'.tr());
    }

    return val;
  }
}
