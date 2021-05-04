import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../entities/user.dart';
import '../../../../entities/user_appointment.dart';
import '../../../../services/api_service.dart';
import '../../../../tools/tools.dart';

enum AppointmentItemState { loading, loaded }

class AppointmentItemModel extends ChangeNotifier {
  final _services = ApiServices();
  var state = AppointmentItemState.loaded;
  bool isOpen = false;
  UserAppointment userAppointment;

  AppointmentItemModel(this.userAppointment);

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> updateStatus(User user, String val) async {
    if (userAppointment.lpBookingStatus != val) {
      _updateState(AppointmentItemState.loading);
      var result = await _services.changeUserAppointmentStatus(
          user, userAppointment.bookingId, val);
      if (result == 1) {
        userAppointment.lpBookingStatus = val;
      } else {
        showToast('failedToChangeAppointmentStatus'
            .tr(args: [userAppointment.bookingId.toString()]));
      }

      _updateState(AppointmentItemState.loaded);
    }
  }

  void updateIsOpen() {
    isOpen = !isOpen;
    _updateState(AppointmentItemState.loaded);
  }
}
