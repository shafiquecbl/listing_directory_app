import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/app_constants.dart';
import '../configs/layout_config.dart';
import '../services/api_service.dart';

class AppModel extends ChangeNotifier {
  bool isDarkTheme = kDefaultDarkTheme;
  bool notificationOn = false;
  bool isFirstTime = false;
  Map<dynamic, dynamic> appConfig = LayoutConfig.data;

  final _services = ApiServices();

  AppModel() {
    getAppConfig();
    getThemeLocal();
    getFirstTimeConfig();
  }

  void getAppConfig() async {
    appConfig = await _services.getAppConfig();
    notifyListeners();
  }

  void setFirstTime(bool value) async {
    isFirstTime = value;
    var _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setBool('isFirstTime', isFirstTime);
  }

  void getFirstTimeConfig() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    isFirstTime =
        await _sharedPreferences.getBool('isFirstTime') ?? kDefaultDarkTheme;
  }

  void getThemeLocal() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    isDarkTheme =
        await _sharedPreferences.getBool('isDarkTheme') ?? kDefaultDarkTheme;
    notifyListeners();
  }

  void setThemeLocal() async {
    var _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.setBool('isDarkTheme', isDarkTheme);
  }

  void setTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
    setThemeLocal();
  }

  /// TODO: CHANGE DEFAULT THEME COLORS (OPTIONAL)
  ThemeData getTheme(BuildContext context) {
    const kBackgroundColor = Color(0xFF252B3B);
    //final kButtonColor = Color(0xFF50E3C2);
    const kButtonColor = Colors.red;
    const kAccentColor = Colors.red;
    const kButtonTextColor = Colors.white;
    const kCardColor = Colors.black12;
    if (isDarkTheme) {
      /// DARK THEME
      return ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        backgroundColor: kBackgroundColor,
        accentColor: kAccentColor,
        cardColor: kCardColor,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: kButtonColor,
          textTheme: ButtonTextTheme.accent,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                secondary: kButtonTextColor,
              ),
        ),
      );
    }

    /// LIGHT THEME
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      primaryColor: const Color(0xFFF0F8FF),
      accentColor: kAccentColor,
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: kButtonColor,
        textTheme: ButtonTextTheme.accent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              secondary: Colors.white,
            ),
      ),
      cardColor: kCardColor,
    );
  }
}
