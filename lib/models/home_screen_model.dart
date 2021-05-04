import 'package:flutter/cupertino.dart';

import '../entities/category.dart';
import '../entities/listing.dart';
import '../services/api_service.dart';

class HomeScreenModel extends ChangeNotifier {
  Map<dynamic, List<Listing>> listCategoryLayout = {};
  Map<dynamic, Listing> listListingLayout = {};
  Map<dynamic, Category> categories = {};
  Map<dynamic, List<Listing>> listAdSlider = {};
  final ApiServices _services = ApiServices();

  void initLayout(homeScreenConfig) {
    getCategoryListings(homeScreenConfig);
    getCategories(homeScreenConfig);
    getListings(homeScreenConfig);
    getAdsSlider(homeScreenConfig);
  }

  Future<void> getAdsSlider(homeScreenConfig) async {
    for (Map item in homeScreenConfig) {
      if (item.containsKey('adSliderBanner')) {
        listAdSlider[item['adSliderBanner']['uniqueId']] =
            await _services.getAdListings(
                page: 1,
                perPage: item['adSliderBanner']['count'],
                adType: item['adSliderBanner']['adType']);
      }
    }
    notifyListeners();
  }

  Future<void> getCategoryListings(homeScreenConfig) async {
    for (Map item in homeScreenConfig) {
      if (item.containsKey('category')) {
        if (listCategoryLayout.containsKey(item['category']['ids'])) {
          continue;
        }
        listCategoryLayout['${item['category']['ids']}'] =
            await _services.getListings(
                page: 1,
                perPage: item['category']['limit'] ?? 10,
                categories: item['category']['ids']);
      }
    }
    notifyListeners();
  }

  Future<void> getListings(homeScreenConfig) async {
    var include = <int>[];
    for (Map item in homeScreenConfig) {
      if (item.containsKey('sliderBanner')) {
        for (var banner in item['sliderBanner']['list']) {
          if (banner['type'] == 'listing') {
            if (listListingLayout.containsKey(banner['id'])) {
              continue;
            }
            include.add(banner['id']);
          }
        }
        var list = await _services.getListings(
            page: 1, perPage: include.length, include: include);
        for (var listing in list) {
          listListingLayout[listing.id] = listing;
        }
        notifyListeners();
      }
    }
  }

  Future<void> getCategories(homeScreenConfig) async {
    for (Map item in homeScreenConfig) {
      if (item.containsKey('listCategory')) {
        var categoryIds = <int>[];
        for (var cat in item['listCategory']['list']) {
          categoryIds.add(cat['id']);
        }
        var list = await _services.getCategories(
            page: 1, perPage: 100, categories: categoryIds);
        for (var cat in list) {
          categories[cat.id] = cat;
        }
      }
    }
    notifyListeners();
  }
}
