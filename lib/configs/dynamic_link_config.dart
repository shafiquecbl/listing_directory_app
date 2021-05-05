import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import '../enums/enums.dart';
import '../screens/item_detail_screen/item_detail_screen.dart';
import '../services/api_service.dart';
import '../tools/tools.dart';

class DynamicLinkService {
  /// TODO: CHANGE THIS TO YOUR FIREBASE DYNAMIC LINK
  static const String _URL_PREFIX = 'https://thelista.page.link';

  /// TODO: CHANGE THIS TO YOUR APP PACKAGE NAME
  static const String _ANDROID_PACKAGE_NAME = 'com.app.thelista';

  /// TODO: CHANGE THIS TO YOUR IOS BUNDLE ID
  static const String _IOS_BUNDLE_ID = 'com.app.thelista';

  /// TODO: CHANGE THIS TO YOUR APPLE STORE ID
  static const String _APP_STORE_ID = '123456789';

  static Future<String> createLink(String link) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: _URL_PREFIX,
      link: Uri.parse(link),
      androidParameters: AndroidParameters(
        packageName: _ANDROID_PACKAGE_NAME,
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: _IOS_BUNDLE_ID,
        minimumVersion: '1.0.1',
        appStoreId: _APP_STORE_ID,
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }

  static void initDynamicLinks(BuildContext context, AppState appState) async {
    if (appState == AppState.closed) {
      final data = await FirebaseDynamicLinks.instance.getInitialLink();
      await _handleDynamicLink(data, context);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      await _handleDynamicLink(dynamicLink, context);
    }, onError: (OnLinkErrorException e) async {
      log('onLinkError: ${e.message}');
    });
  }

  static Future<void> _handleDynamicLink(
      PendingDynamicLinkData data, BuildContext context) async {
    try {
      final deepLink = data?.link;
      if (deepLink == null) {
        return;
      }
      var listing = await ApiServices().getListingWithLink(deepLink.toString());
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(
            listing: listing,
          ),
        ),
      );
    } catch (err) {
      log('${err.toString()}');
    }
  }
}
