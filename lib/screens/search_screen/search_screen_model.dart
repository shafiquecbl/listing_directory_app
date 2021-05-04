import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entities/listing.dart';
import '../../entities/suggested_search.dart';
import '../../services/api_service.dart';

enum SearchState { searching, searched, typing, noResult, loadMore }

class SearchScreenModel extends ChangeNotifier {
  List<Listing> searchedListings = [];
  final _services = ApiServices();
  int _page = 1;
  final int _perPage = 10;
  var state = SearchState.searched;
  final TextEditingController searchController = TextEditingController();
  List<String> recentSearches = [];
  final RefreshController refreshController = RefreshController();
  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  SuggestedSearch suggestedSearch;

  SearchScreenModel() {
    getRecentSearches();
  }

  void getListing({String recentSearchTerm}) {
    if (recentSearchTerm != null) {
      searchController.text = recentSearchTerm;
    }
    EasyDebounce.cancel('search');
    if (searchController.text.trim().isNotEmpty) {
      EasyDebounce.debounce('search', const Duration(milliseconds: 500),
          () async {
        _updateState(SearchState.searching);
        _page = 1;
        searchedListings = await _services.getAdListings(
            perPage: 1,
            adType: 'topofsearch',
            searchTerm: searchController.text);
        var _list = <Listing>[];
        _list = await _services.getListings(
            perPage: _perPage, page: _page, searchTerm: searchController.text);
        for (var item in _list) {
          var tmp = searchedListings.where((element) => element.id == item.id);
          if (tmp.isEmpty) {
            searchedListings.add(item);
          }
        }
        if (searchedListings.isEmpty) {
          _updateState(SearchState.noResult);
          refreshController.refreshCompleted();
          return;
        }
        refreshController.refreshCompleted();
        _updateState(SearchState.searched);
      });
    } else {
      searchedListings.clear();
      _updateState(SearchState.searched);
    }
  }

  void clearListing() {
    if (state == SearchState.searching) {
      return;
    }
    EasyDebounce.cancel('search');
    EasyDebounce.cancel('searchSuggestedListing');
    searchController.clear();
    searchedListings.clear();
    suggestedSearch = null;
    _updateState(SearchState.searched);
  }

  void loadMoreSearchListings() async {
    _page++;
    var _list = <Listing>[];
    _list = await _services.getListings(
        perPage: _perPage, page: _page, searchTerm: searchController.text);
    if (_list.isEmpty) {
      _updateState(SearchState.searched);
      refreshController.loadNoData();
      return;
    }
    searchedListings.addAll(_list);
    refreshController.loadComplete();
    _updateState(SearchState.searched);
  }

  void getRecentSearches() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    recentSearches = sharedPreferences.getStringList('recentSearches') ?? [];
  }

  void addLocalSearchTerm() async {
    if (searchController.text.trim().isNotEmpty) {
      var sharedPreferences = await SharedPreferences.getInstance();
      recentSearches.insert(0, searchController.text);
      if (recentSearches.length > 5) {
        recentSearches.removeRange(5, recentSearches.length);
      }
      await sharedPreferences.setStringList('recentSearches', recentSearches);
      _updateState(SearchState.searched);
    }
  }

  void clearLocalSearchTerm() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    recentSearches.clear();
    await sharedPreferences.setStringList('recentSearches', recentSearches);
    _updateState(SearchState.searched);
  }

  /// Search Suggested Location for search_screen_v2
  void searchSuggestedListing({String recentSearchTerm}) {
    if (recentSearchTerm != null) {
      searchController.text = recentSearchTerm;
    }
    EasyDebounce.cancel('searchSuggestedListing');
    if (searchController.text.trim().isNotEmpty) {
      EasyDebounce.debounce(
          'searchSuggestedListing', const Duration(milliseconds: 500),
          () async {
        _updateState(SearchState.searching);
        suggestedSearch = await _services.searchSuggestedListing(
            searchTerm: searchController.text);
        if (suggestedSearch == null ||
            suggestedSearch.suggestions.more.isNotEmpty) {
          _updateState(SearchState.noResult);
          return;
        }
        refreshController.refreshCompleted();
        _updateState(SearchState.searched);
      });
    } else {
      suggestedSearch = null;
      _updateState(SearchState.searched);
    }
  }
}
