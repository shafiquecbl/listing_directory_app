import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../entities/category.dart';
import '../entities/features.dart';
import '../entities/listing.dart';
import '../entities/location.dart';
import '../services/api_service.dart';
import '../tools/tools.dart';

enum ItemListScreenState { loading, loaded, loadMore }

class ItemListScreenModel extends ChangeNotifier {
  final ApiServices _services = ApiServices();
  var state = ItemListScreenState.loading;
  List<Listing> listings = [];
  List<Category> categories = [];
  List<Location> locations = [];
  List<Feature> features = [];
  String searchTerm;
  final int _perPage = 10;
  final RefreshController controller = RefreshController();
  int _page = 1;
  Map<String, List<int>> options = {
    'selectedCategories': [],
    'selectedLocations': [],
    'selectedFeatures': [],
  };

  void updateOption(Map<String, List<int>> filterOptions) {
    options = filterOptions;
    getListings();
  }

  void clearOption() {
    options = {
      'selectedCategories': [],
      'selectedLocations': [],
      'selectedFeatures': [],
    };
  }

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  void initGetAll() {
    getAllCategories();
    getAllFeatures();
    getAllLocations();
  }

  Future<void> getAllCategories() async {
    var page = 1;
    while (true) {
      var list = await _services.getCategories(page: page, perPage: 100);
      if (list.isEmpty) {
        return;
      }
      page++;
      categories.addAll(list);
    }
  }

  Future<void> getAllLocations() async {
    var page = 1;
    while (true) {
      var list = await _services.getLocations(page: page, perPage: 100);
      if (list.isEmpty) {
        return;
      }
      page++;
      locations.addAll(list);
    }
  }

  Future<void> getAllFeatures() async {
    var page = 1;
    while (true) {
      var list = await _services.getFeatures(page: page, perPage: 100);
      if (list.isEmpty) {
        return;
      }
      page++;
      features.addAll(list);
    }
  }

  Future<void> getListings(
      {List<int> categories,
      List<int> features,
      List<int> locations,
      List<int> tags,
      String searchTerm}) async {
    _updateState(ItemListScreenState.loading);
    _page = 1;
    if (categories != null && categories.isNotEmpty) {
      for (var cat in categories) {
        if (!options['selectedCategories'].contains(cat)) {
          options['selectedCategories'].add(cat);
        }
      }
    }

    if (features != null && features.isNotEmpty) {
      for (var fea in features) {
        if (!options['selectedFeatures'].contains(fea)) {
          options['selectedFeatures'].add(fea);
        }
      }
    }

    if (locations != null && locations.isNotEmpty) {
      for (var loc in locations) {
        if (!options['selectedLocations'].contains(loc)) {
          options['selectedLocations'].add(loc);
        }
      }
    }

    if (!Tools.checkEmptyString(searchTerm)) {
      this.searchTerm = searchTerm;
    }
    listings = await _services.getAdListings(
        perPage: 2,
        page: 1,
        adType: 'sidebar',
        categories: options['selectedCategories'],
        locations: options['selectedLocations'],
        features: options['selectedFeatures']);

    var adList = await _services.getListings(
        perPage: 10,
        page: 1,
        categories: options['selectedCategories'],
        locations: options['selectedLocations'],
        features: options['selectedFeatures'],
        tags: tags,
        searchTerm: this.searchTerm);
    for (var item in adList) {
      var tmp = listings.where((element) => element.id == item.id);
      if (tmp.isEmpty) {
        listings.add(item);
      }
    }
    controller.refreshCompleted();
    controller.loadComplete();
    _updateState(ItemListScreenState.loaded);
  }

  void loadMore() async {
    _updateState(ItemListScreenState.loadMore);
    _page++;

    var _list = await _services.getListings(
        perPage: _perPage,
        page: _page,
        categories: options['selectedCategories'],
        locations: options['selectedLocations'],
        features: options['selectedFeatures'],
        searchTerm: searchTerm);
    if (_list.isEmpty) {
      controller.loadNoData();
    } else {
      for (var item in _list) {
        var tmp = listings.where((element) => element.id == item.id);
        if (tmp.isEmpty) {
          listings.add(item);
        }
      }

      controller.loadComplete();
    }
    _updateState(ItemListScreenState.loaded);
  }
}
