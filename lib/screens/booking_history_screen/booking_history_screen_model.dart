import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../entities/booking.dart';
import '../../services/api_service.dart';

enum BookingHistoryState { init, loading, loaded, loadMore }

class BookingHistoryScreenModel extends ChangeNotifier {
  final _services = ApiServices();
  List<Booking> bookings = [];
  var state = BookingHistoryState.loaded;
  final RefreshController refreshController = RefreshController();
  // final _per_page = 10;
  // var _page = 1;

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  BookingHistoryScreenModel(userId) {
    getBookings(userId);
  }

  Future<void> getBookings(int userId) async {
    if (state == BookingHistoryState.loading ||
        state == BookingHistoryState.loadMore) {
      return;
    }
    _updateState(BookingHistoryState.loading);
    //_page = 1;
    bookings = await _services.getBookings(userId: userId);
    refreshController.loadComplete();
    refreshController.refreshCompleted();
    _updateState(BookingHistoryState.loaded);
  }

  Future<void> loadMoreBookings(int userId) async {
    if (state == BookingHistoryState.loading ||
        state == BookingHistoryState.loadMore) {
      return;
    }
  }
}
