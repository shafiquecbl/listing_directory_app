import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_widgets/header_widget.dart';
import '../configs/app_config.dart';
import '../models/export.dart';
import '../screens/home_screen/widgets/ad_slider_banners/ad_slider_banner_index.dart';
import '../screens/home_screen/widgets/list_category/list_category_index.dart';
import '../screens/home_screen/widgets/list_listing_item/list_listing_item_index.dart';
import '../screens/home_screen/widgets/slider_banners/slider_banner_index.dart';
import '../screens/item_list_screen/item_list_screen_v1.dart';

class WidgetGenerate {
  static Widget getBackButton() {
    Widget backBtn = const Icon(Icons.arrow_back);
    if (!AppConfig.webPlatform) {
      if (Platform.isIOS) {
        backBtn = const Icon(Icons.arrow_back_ios_sharp);
      }
    }
    return backBtn;
  }

  static Widget getAppBar(String title, ThemeData theme) {
    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headline6,
      ),
      brightness: theme.brightness,
      centerTitle: true,
      backgroundColor: theme.backgroundColor,
      iconTheme: theme.iconTheme,
    );
  }

  static List<Widget> buildHomeLayout(
      HomeScreenModel model, Map appConfig, BuildContext context) {
    final homeScreenConfig = appConfig['homeScreen']['layout'];
    var list = <Widget>[];

    for (Map item in homeScreenConfig) {
      /// Add category list
      if (item.containsKey('listCategory')) {
        list.add(const SizedBox(height: 10.0));
        list.add(ListCategoryIndex(
          list: item['listCategory']['list'],
          categories: model.categories,
          version: item['listCategory']['version'],
        ));
        list.add(const SizedBox(height: 10.0));
      }

      /// Add category layout
      if (item.containsKey('category')) {
        if (item['category']['headerText'] != null) {
          list.add(const SizedBox(height: 10.0));
          list.add(
            HeaderWidget(
              title: item['category']['headerText'],
              onTap: () => item['category']['showSeeAll']
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemListScreenV1(
                                categoryIds: item['category']['ids'],
                              )))
                  : null,
              onTapTitle: item['category']['showSeeAll'] ? 'seeAll'.tr() : null,
            ),
          );
        }
        list.add(const SizedBox(height: 10.0));
        list.add(ListListingItemIndex(
            isEmpty: model.listCategoryLayout.isEmpty,
            version: item['category']['version'],
            limit: item['category']['limit'],
            list: model.listCategoryLayout['${item['category']['ids']}']));
      }

      /// Add Header Text
      if (item.containsKey('headerText')) {
        list.add(const SizedBox(height: 10.0));
        list.add(
          HeaderWidget(
            title: item['headerText']['title'],
            onTap: () => item['headerText']['showSeeAll']
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemListScreenV1(
                              categoryIds: item['headerText']['ids'],
                            )))
                : null,
            onTapTitle: item['headerText']['showSeeAll'] ? 'See All' : null,
          ),
        );
      }

      /// Add banners
      if (item.containsKey('sliderBanner')) {
        list.add(const SizedBox(height: 10.0));
        list.add(SliderBannerIndex(
          version: item['sliderBanner']['version'],
          configListingLayout: model.listListingLayout,
          list: item['sliderBanner']['list'],
          config: item['sliderBanner'],
        ));
      }

      /// Add ads banner
      if (item.containsKey('adSliderBanner')) {
        list.add(const SizedBox(height: 10.0));
        list.add(AdSliderBannerIndex(
            config: item['adSliderBanner'],
            version: item['adSliderBanner']['version'],
            list: model.listAdSlider[item['adSliderBanner']['uniqueId']]));
      }
    }
    return list;
  }
}
