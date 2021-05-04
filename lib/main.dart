import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'configs/app_config.dart';
import 'models/export.dart';
import 'screens/screen_index.dart';
import 'screens/screen_index_model.dart';
import 'screens/search_screen/search_screen_model.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  var supportedLocales = <Locale>[];
  AppConfig.supportedLocales.forEach((locale) {
    supportedLocales.add(locale[locale.keys.first]['locale']);
  });

  runApp(EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppConfig.defaultLocale,
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onMessage: (message) async {},
        onResume: (message) async {},
        onLaunch: (message) async {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>(
      create: (context) => AppModel(),
      lazy: false,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeScreenModel>(
            create: (_) => HomeScreenModel(),
          ),
          ChangeNotifierProvider<ItemListScreenModel>(
            create: (_) => ItemListScreenModel(),
          ),
          ChangeNotifierProvider<ScreenIndexModel>(
            create: (_) => ScreenIndexModel(),
          ),
          ChangeNotifierProvider<AuthenticationModel>(
            create: (_) => AuthenticationModel(),
          ),
          ChangeNotifierProvider<SearchScreenModel>(
            create: (_) => SearchScreenModel(),
          ),
          ChangeNotifierProvider<WishListScreenModel>(
            create: (_) => WishListScreenModel(),
          ),
          ChangeNotifierProvider<DiscoveryScreenModel>(
            create: (_) => DiscoveryScreenModel(),
          ),
        ],
        child: Consumer<AppModel>(
          builder: (_, model, __) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: model.isDarkTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: MaterialApp(
                theme: model.getTheme(context),
                debugShowCheckedModeBanner: false,
                home: ScreenIndex(),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
