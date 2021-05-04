import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../entities/user_appointment.dart';
import '../../services/api_service.dart';

enum AppointmentListState { loading, loaded, loadMore }

class AppointmentListScreenModel extends ChangeNotifier {
  List<UserAppointment> appointments = [];
  final _services = ApiServices();
  final _user;
  final _perPage = 10;
  var _page = 1;
  final RefreshController refreshController = RefreshController();
  var state = AppointmentListState.loaded;
  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  AppointmentListScreenModel(this._user) {
    getAppointments();
  }

  Future<void> getAppointments() async {
    _updateState(AppointmentListState.loading);
    _page = 1;
    appointments = await _services.getUserAppointments(_user,
        page: _page, perPage: _perPage);
    if (appointments.isEmpty) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    refreshController.refreshCompleted();
    _updateState(AppointmentListState.loaded);
  }

  Future<void> loadAppointments() async {
    _updateState(AppointmentListState.loadMore);
    _page++;
    var list = await _services.getUserAppointments(_user,
        page: _page, perPage: _perPage);
    if (list.isEmpty) {
      refreshController.loadNoData();
    } else {
      appointments.addAll(list);
      refreshController.loadComplete();
    }
    _updateState(AppointmentListState.loaded);
  }
}
