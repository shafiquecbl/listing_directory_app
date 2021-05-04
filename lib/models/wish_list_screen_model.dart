import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../entities/listing.dart';
import '../entities/user.dart';
import '../services/api_service.dart';

enum WishListState { loading, loaded, loadMore }

class WishListScreenModel extends ChangeNotifier {
  List<Listing> wishListItems = [];
  final _services = ApiServices();
  var state = WishListState.loading;
  final RefreshController refreshController = RefreshController();
  final _per_page = 100;
  var _page = 1;
  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  void initWishList(User user) {
    if (user == null) {
      wishListItems.clear();
      Future.delayed(Duration.zero)
          .then((value) => _updateState(WishListState.loaded));
      return;
    }
    _services
        .getUserFavorites(user: user, page: _page, perPage: _per_page)
        .then((value) {
      wishListItems = value.reversed.toList();
      _updateState(WishListState.loaded);
    });
  }

  void getWishList(User user) async {
    if (state == WishListState.loading || state == WishListState.loadMore) {
      return;
    }
    wishListItems.clear();
    _updateState(WishListState.loading);
    _page = 1;
    final list = await _services.getUserFavorites(
        user: user, page: _page, perPage: _per_page);
    if (list.isEmpty) {
      refreshController.loadNoData();
    } else {
      wishListItems.addAll(list.toList());
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    }
    _updateState(WishListState.loaded);
  }

  void loadMoreWishList(User user) async {
    if (state == WishListState.loading || state == WishListState.loadMore) {
      return;
    }
    _updateState(WishListState.loadMore);
    _page++;
    final list = await _services.getUserFavorites(
        user: user, page: _page, perPage: _per_page);
    if (list.isEmpty) {
      refreshController.loadNoData();
    } else {
      wishListItems.addAll(list.toList());
      refreshController.loadComplete();
    }
    _updateState(WishListState.loaded);
  }

  void addOrRemoveWishList(Listing listing, User user) {
    if (user == null) {
      return;
    }
    if (wishListItems.contains(listing)) {
      wishListItems.remove(listing);
    } else {
      wishListItems.add(listing);
    }
    _services.addOrRemoveUserFavorite(user, listingId: listing.id);
    _updateState(WishListState.loaded);
  }
}
