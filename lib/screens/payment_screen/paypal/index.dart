import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../common_widgets/skeleton.dart';
import '../../../tools/tools.dart';
import '../../../tools/widget_generate.dart';
import 'services.dart';

class PaypalPayment extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final String title;
  final String noteToPayer;
  final Function(String, String) onFinish;
  PaypalPayment(
      {@required this.onFinish,
      @required this.paymentData,
      this.title,
      this.noteToPayer = 'contactUs'});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services = PaypalServices();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        final transactions = getOrderParams();

        final res =
            await services.createPayPalPayment(transactions, accessToken);
        if (res != null) {
          isLoading = false;
          setState(() {
            checkoutUrl = res['approvalUrl'];
            executeUrl = res['executeUrl'];
          });
        }
      } catch (e) {
        log(e);
      }
    });
  }

  String formatPrice(String price) {
    if (isNotBlank(price)) {
      final formatCurrency = NumberFormat('#,##0.00', 'en_US');
      return formatCurrency.format(double.parse(price));
    } else {
      return '0';
    }
  }

  Map<String, dynamic> getOrderParams() {
    var temp = <String, dynamic>{
      'intent': 'sale',
      'payer': {'payment_method': 'paypal'},
      'transactions': [
        {
          'amount': {
            'total': formatPrice(widget.paymentData['total'].toString()),
            'currency': widget.paymentData['currency'],
          },
          'description': widget.title,
          'payment_options': {
            'allowed_payment_method': 'INSTANT_FUNDING_SOURCE'
          },
          'item_list': {
            'items': [
              {
                'name': widget.title,
                'quantity': 1,
                'price': formatPrice(widget.paymentData['total'].toString()),
                'currency': widget.paymentData['currency'],
              }
            ],
          }
        }
      ],
      'note_to_payer': widget.noteToPayer.tr(),
      'redirect_urls': {
        'return_url': 'http://return.example.com',
        'cancel_url': 'http://cancel.example.com'
      }
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 1.0,
          leading: GestureDetector(
            onTap: () {
              widget.onFinish(null, null);
              Navigator.pop(context);
            },
            child: WidgetGenerate.getBackButton(),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) async {
            if (request.url.startsWith('http://return.example.com')) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              final token = uri.queryParameters['token'];
              if (payerID != null) {
                await services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) async {
                  var transactionId = await services.getTransactionId(id);
                  widget.onFinish(token, transactionId);
                  Navigator.of(context).pop();
                });
              }
            }
            if (request.url.startsWith('http://cancel.example.com')) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.onFinish(null, null);
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Skeleton(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
