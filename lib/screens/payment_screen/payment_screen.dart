import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/skeleton.dart';
import '../../configs/app_constants.dart';
import '../../configs/payment_config.dart';
import '../../entities/listing.dart';
import '../../entities/user.dart';
import '../../models/authentication_model.dart';
import '../../tools/tools.dart';
import 'payment_screen_model.dart';
import 'paypal/index.dart';

class PaymentScreen extends StatefulWidget {
  final Listing listing;
  final Function onFinish;

  const PaymentScreen(
      {Key key, @required this.listing, @required this.onFinish})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentIndex = -1;
  bool isShowWireInfo = false;

  List<Widget> _buildLoadedPaymentMethods(Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    if (data.isEmpty) {
      return [];
    }
    var widgets = List<Widget>.generate(
        kPaymentMethods.length,
        (index) => data[kPaymentMethods[index]['id']]
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _currentIndex = index;
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 1500),
                      width: size.width,
                      height: 100.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? Colors.green
                            : theme.primaryColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    kPaymentMethods[index]['icon'],
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              flex: 4,
                              child: Text(
                                kPaymentMethods[index]['name'],
                                style: theme.textTheme.headline5,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container());
    widgets.add(
      const SizedBox(height: 80.0),
    );
    return widgets;
  }

  List<Widget> _buildLoadingPaymentMethods() {
    final size = MediaQuery.of(context).size;
    return List.generate(
        kPaymentMethods.length,
        (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Skeleton(
                    width: size.width,
                    height: 100.0,
                  ),
                ),
              ],
            ));
  }

  void _makePayment(PaymentScreenModel model, User user) {
    if (kPaymentMethods[_currentIndex]['id'] == 'paypal') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => PaypalPayment(
                    onFinish: (token, transId) {
                      if (token != null && transId != null) {
                        model
                            .makePayment(user,
                                transactionId: transId,
                                paymentToken: token,
                                method: 'paypal',
                                listingId: widget.listing.id.toString(),
                                planId:
                                    widget.listing.lpListingproOptions.planId)
                            .then((code) {
                          if (code != 1) {
                            showToast('makePaymentFailed'.tr());
                          } else {
                            showToast('makePaymentSuccess'.tr());
                            widget.onFinish();
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    paymentData: model.paymentMethods,
                    title: widget.listing.title,
                    noteToPayer: PaymentConfig.payPalPayment['noteToPayer'],
                  )));
      return;
    }
    if (kPaymentMethods[_currentIndex]['id'] == 'wire') {
      model
          .makePayment(user,
              method: 'wire',
              listingId: widget.listing.id.toString(),
              planId: widget.listing.lpListingproOptions.planId)
          .then((code) {
        if (code != 1) {
          showToast('makePaymentFailed'.tr());
        } else {
          isShowWireInfo = true;
          setState(() {});
        }
      });
      return;
    }

    showToast('thisPaymentMethodNotSupported'.tr());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;

    return ChangeNotifierProvider<PaymentScreenModel>(
      create: (_) =>
          PaymentScreenModel(user, widget.listing.lpListingproOptions.planId),
      lazy: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: AppBar(
              title: Text(
                'payment'.tr(),
                style: theme.textTheme.headline6,
              ),
              brightness: theme.brightness,
              centerTitle: true,
              backgroundColor: theme.backgroundColor,
              iconTheme: theme.iconTheme,
            ),
            floatingActionButton: Consumer<PaymentScreenModel>(
              builder: (_, model, __) => ElevatedButton(
                style: ElevatedButton.styleFrom(primary: theme.accentColor),
                onPressed: () => _makePayment(model, user),
                child: Text('chooseThisPayment'.tr()),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Stack(
              children: [
                Consumer<PaymentScreenModel>(
                  builder: (_, model, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      model.state == PaymentState.loading
                          ? Container(
                              width: size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Skeleton(
                                width: size.width,
                                height: 100.0,
                              ),
                            )
                          : Container(
                              width: size.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'plan'.tr(),
                                        style: theme.textTheme.headline6,
                                      )),
                                      Expanded(
                                          child: Text(
                                        model.paymentMethods['plan_title'],
                                        style: theme.textTheme.headline6,
                                        textAlign: TextAlign.end,
                                      ))
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'type'.tr(),
                                        style: theme.textTheme.headline6,
                                      )),
                                      Expanded(
                                          child: Text(
                                        model.paymentMethods['plan_type'],
                                        style: theme.textTheme.headline6,
                                        textAlign: TextAlign.end,
                                      ))
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        model.paymentMethods['lp_tax_label'],
                                        style: theme.textTheme.headline6,
                                      )),
                                      Expanded(
                                          child: Text(
                                        '${model.paymentMethods['currency_symbol']}${model.paymentMethods['lp_tax_amount']}',
                                        style: theme.textTheme.headline6,
                                        textAlign: TextAlign.end,
                                      ))
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'total'.tr(),
                                        style: theme.textTheme.headline6,
                                      )),
                                      Expanded(
                                          child: Text(
                                        '${model.paymentMethods['currency_symbol']}${model.paymentMethods['total']}',
                                        style: theme.textTheme.headline6,
                                        textAlign: TextAlign.end,
                                      ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: model.state == PaymentState.loading
                                ? _buildLoadingPaymentMethods()
                                : _buildLoadedPaymentMethods(
                                    model.paymentMethods),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Consumer<PaymentScreenModel>(
                  builder: (_, model, __) => isShowWireInfo
                      ? Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black87.withOpacity(0.5),
                          child: Center(
                            child: Container(
                              color: Colors.blue,
                              margin: const EdgeInsets.all(10.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'bankDetails'.tr(),
                                    style: theme.textTheme.headline6,
                                  ),
                                  const SizedBox(height: 10.0),
                                  Html(
                                    data: model.paymentMethods[
                                        'direct_payment_instruction'],
                                  ),
                                  Text(
                                    'pleaseTakeNoteOfThisInformation'.tr(),
                                    style: theme.textTheme.subtitle2,
                                  ),
                                  const SizedBox(height: 10.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        primary: theme.accentColor),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      widget.onFinish();
                                    },
                                    child: Text(
                                      'ok'.tr(),
                                      style: theme.textTheme.headline6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ),
          Consumer<PaymentScreenModel>(
            builder: (_, model, __) => model.state == PaymentState.makingPayment
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black87.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
