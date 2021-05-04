import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configs/app_config.dart';
import '../configs/dynamic_link_config.dart';
import '../configs/layout_config.dart';
import '../enums/enums.dart';
import '../models/app_model.dart';
import '../models/authentication_model.dart';
import '../models/wish_list_screen_model.dart';
import 'category_screen/category_screen_v1.dart';
import 'discovery_screen/discovery_screen_index.dart';
import 'home_screen/home_index.dart';
import 'messages_screen/messages_screen_v1.dart';
import 'screen_index_model.dart';
import 'search_screen/search_screen_model.dart';
import 'setting_screen/setting_screen.dart';
import 'splash_screen/splash_screen.dart';
import 'wish_list_screen/wish_list_screen_v1.dart';

class ScreenIndex extends StatefulWidget {
  @override
  _ScreenIndexState createState() => _ScreenIndexState();
}

class _ScreenIndexState extends State<ScreenIndex> {
  void _initAllProviders() {
    Provider.of<SearchScreenModel>(context, listen: false);
    Provider.of<WishListScreenModel>(context, listen: false);
    Provider.of<AuthenticationModel>(context, listen: false);
  }

  @override
  void initState() {
    _initAllProviders();
    Firebase.initializeApp();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DynamicLinkService.initDynamicLinks(context, AppState.background);
    });
  }

  Widget _buildTabBar(ScreenIndexModel model) {
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    final tabBarConfig = appConfig['tabBar']['layout'];
    var tabBars = <Widget>[];
    List.generate(
      tabBarConfig.length,
      (index) => tabBars.add(
        Expanded(
          child: GestureDetector(
            onTap: () => model.updateIndex(index),
            child: Container(
              color: Colors.transparent,
              child: (tabBarConfig[index]['icon'] is IconData)
                  ? Icon(
                      tabBarConfig[index]['icon'],
                      color: model.index == index
                          ? Theme.of(context).accentColor
                          : Colors.grey,
                      size: model.index == index ? 24.0 : 18.0,
                    )
                  : Container(
                      padding:
                          EdgeInsets.all(model.index == index ? 8.0 : 10.0),
                      child: CachedNetworkImage(
                        imageUrl: tabBarConfig[index]['icon'],
                        color: model.index == index
                            ? Theme.of(context).accentColor
                            : Colors.grey,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
    return SafeArea(
      top: false,
      bottom: AppConfig.webPlatform ? false : !Platform.isIOS,
      child: Container(
        height: AppConfig.webPlatform
            ? 48.0
            : Platform.isIOS
                ? 68.0
                : 48.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: tabBars,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageView() {
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    final pageViewConfig = appConfig['tabBar']['layout'];
    var list = <Widget>[];
    for (var page in pageViewConfig) {
      if (page['page'] == LayoutConfig.homePage) {
        list.add(HomeIndex());
      }
      if (page['page'] == LayoutConfig.categoryPage) {
        list.add(CategoryScreenV1());
      }
      if (page['page'] == LayoutConfig.settingPage) {
        list.add(SettingScreen());
      }
      if (page['page'] == LayoutConfig.wishListPage) {
        list.add(WishListScreenV1());
      }
      if (page['page'] == LayoutConfig.discoverPage) {
        list.add(DiscoveryScreenIndex(
          version: appConfig['discoverScreen']['version'],
        ));
      }
      if (page['page'] == LayoutConfig.chatPage) {
        list.add(MessagesScreenV1());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ScreenIndexModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: model.pageController,
                  children: _buildPageView(),
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
              Consumer<ScreenIndexModel>(
                builder: (context, model, _) => _buildTabBar(model),
              ),
            ],
          ),
          SplashScreen(),
        ],
      ),
    );
  }
}
