import 'package:flutter/cupertino.dart';

import '../entities/user.dart';

class AppConfig {
  // TODO: CHANGE DEFAULT LOCALE
  static const defaultLocale = Locale('en', 'US');
  // TODO: ENABLE ADMOB
  static const enableAdMob = true;
  // TODO: ADD YOUR ANDROID AND IOS GOOGLE API KEY
  static String googleAndroidMapApi = 'AIzaSyCeBqQhyeuq0X4F_cc_MM-lyfHFnJaPaHU';
  static String googleIOSMapApi = 'AIzaSyCeBqQhyeuq0X4F_cc_MM-lyfHFnJaPaHU';

  /// Countries must be passed as a two character, ISO 3166-1 Alpha-2 compatible country code. For example: fr
  /// 5 COUNTRIES ARE MAXIMUM ALLOWED
  static List<String> restrictedCountries = ['my', 'sg'];

  // TODO: ADD YOUR LANGUAGE. MUST INCLUDE A TRANSLATED FILE IN assets/translations
  static final supportedLocales = [
    {
      'US': {
        'icon': 'https://imgur.com/Wf6PPOP.png',
        'locale': const Locale('en', 'US')
      }
    },
    {
      'VN': {
        'icon': 'https://imgur.com/xBxvBu9.png',
        'locale': const Locale('vi', 'VN')
      }
    },
    {
      'IN': {
        'icon': 'https://imgur.com/4fIh3Xx.png',
        'locale': const Locale('hi', 'IN')
      }
    },
    {
      'DE': {
        'icon': 'https://imgur.com/S8VnoYg.png',
        'locale': const Locale('de', 'DE')
      }
    },
    {
      'UK': {
        'icon': 'https://imgur.com/W1DRe7Z.png',
        'locale': const Locale('en', 'UK')
      }
    },
    {
      'IL': {
        'icon': 'https://imgur.com/T9Ehzjb.png',
        'locale': const Locale('ar', 'IL')
      }
    },
    {
      'FR': {
        'icon': 'https://imgur.com/JLcpOGk.png',
        'locale': const Locale('fr', 'FR')
      }
    },
  ];

  /// USER PLEASE IGNORE THIS
  static const enableDistance = false; // haven't implemented
  static const enableDebugMode = false;
  static const webPlatform = false;
  static final testSocialUser = User(
    id: 11,
    displayName: 'Mino Paw Paw',
    email: 'hainam1991yy@gmail.com',
    firstName: 'Mino Paw',
    lastName: 'Paw',
    username: 'minopaw',
    avatar: 'https://imgur.com/1a2AKp1.png',
    cookie:
        'minopaw|1733327840|QQI4RR7GKg39yp7z5QMimJiD6ATidKE6W0mwKul8Wvn|0450afdfcc64ad7c0ed80f6b5d3cccae56bb7501a19c7fb60e312877b45e53a2',
  );
}
