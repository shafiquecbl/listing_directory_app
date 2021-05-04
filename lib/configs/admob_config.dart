import 'dart:io';

class AdMobConfigs {
  // TODO: CHANGE THIS TO YOUR ANDROID ADMOB APP ID
  static const String _adMobAndroidId =
      'ca-app-pub-3940256099942544~4354546703';
  // TODO: CHANGE THIS TO YOUR IOS ADMOB APP ID
  static const String _adMobIOSId = 'ca-app-pub-3940256099942544/2247696110';
  // TODO: CHANGE THIS TO YOUR ANDROID ADMOB NATIVE ID
  static const String _adMobAndroidNativeId =
      'ca-app-pub-3940256099942544/2247696110';
  // TODO: CHANGE THIS TO YOUR IOS ADMOB NATIVE ID
  static const String _adMobIOSBannerId =
      'ca-app-pub-3940256099942544/2247696110';
  static String get appId {
    if (Platform.isAndroid) {
      return _adMobAndroidId;
    } else if (Platform.isIOS) {
      return _adMobIOSId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return _adMobAndroidNativeId;
    } else if (Platform.isIOS) {
      return _adMobIOSBannerId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static const double adDefaultHeight = 80;
}
