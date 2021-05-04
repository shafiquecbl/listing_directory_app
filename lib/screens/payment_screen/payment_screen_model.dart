import 'package:flutter/cupertino.dart';

import '../../entities/user.dart';
import '../../services/api_service.dart';

enum PaymentState { loading, loaded, makingPayment }

class PaymentScreenModel extends ChangeNotifier {
  final _services = ApiServices();
  var state = PaymentState.loading;
  var paymentMethods = {};
  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  PaymentScreenModel(User user, String planId) {
    getPaymentMethods(user, planId);
  }

  Future<int> makePayment(User user,
      {String transactionId,
      String paymentToken,
      String method,
      String listingId,
      String planId}) async {
    _updateState(PaymentState.makingPayment);
    final code = await _services.makePayment(user,
        transactionId: transactionId,
        paymentToken: paymentToken,
        method: method,
        listingId: listingId,
        planId: planId);

    _updateState(PaymentState.loaded);
    return code;
  }

  Future<void> getPaymentMethods(User user, String planId) async {
    paymentMethods = await _services.getPaymentMethods(user, planId);
    _updateState(PaymentState.loaded);
  }
}
