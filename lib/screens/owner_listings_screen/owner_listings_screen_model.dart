import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../entities/export.dart';
import '../../services/api_service.dart';

enum OwnerListingsState { loading, loaded, noData, loadMore }

class OwnerListingsModel extends ChangeNotifier {
  var listings = <Listing>[];
  var pricePlans = <PricePlan>[];
  final int _perPage = 10;
  var _page = 1;
  final _services = ApiServices();
  var state = OwnerListingsState.loading;
  final RefreshController refreshController = RefreshController();

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  OwnerListingsModel(User user) {
    getListings(user);
  }

  Future<void> getListings(User user) async {
    _updateState(OwnerListingsState.loading);
    _page = 1;
    listings = await _services.getOwnerListing(
        user: user, page: _page, perPage: _perPage);
    refreshController.refreshCompleted();
    if (listings.isEmpty) {
      _updateState(OwnerListingsState.noData);
      return;
    }
    refreshController.loadComplete();
    _updateState(OwnerListingsState.loaded);
  }

  Future<void> loadMoreListings(User user) async {
    _updateState(OwnerListingsState.loadMore);
    _page++;
    var list = await _services.getOwnerListing(
        user: user, page: _page, perPage: _perPage);
    if (list.isEmpty) {
      refreshController.loadNoData();
      return;
    }
    refreshController.loadComplete();
    _updateState(OwnerListingsState.loaded);
  }
}
