import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/authentication_model.dart';
import '../../tools/tools.dart';
import '../../tools/widget_generate.dart';
import 'reset_password_screen.dart';

class RegistrationOTPScreen extends StatefulWidget {
  final String email;
  final Function onCallBack;

  const RegistrationOTPScreen(
      {Key key, @required this.email, @required this.onCallBack})
      : super(key: key);
  @override
  _RegistrationOTPScreenState createState() => _RegistrationOTPScreenState();
}

class _RegistrationOTPScreenState extends State<RegistrationOTPScreen> {
  String otp = '';
  int seconds = 300;
  void _setTime() {
    seconds--;

    setState(() {});
    if (seconds == 0) {
      return;
    }
    EasyDebounce.debounce('setTime', const Duration(seconds: 1), _setTime);
  }

  void _requestCode() {
    seconds = 300;
    final model = Provider.of<AuthenticationModel>(context, listen: false);
    _setTime();
    model.sendOTP(widget.email);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestCode();
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancel('setTime');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WidgetGenerate.getAppBar('emailOTP'.tr(), theme),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: OTPPage(
                otp: otp,
                nextPage: () => Navigator.pop(context),
              ),
            ),
            Text(
              'didNotReceiveCode'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w800, fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            if (seconds == 0)
              InkWell(
                onTap: _requestCode,
                child: Text(
                  'requestNewCode'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.blue, fontSize: 15.0),
                ),
              ),
            if (seconds != 0)
              Text(
                'requestNewCodeIn'.tr(args: [
                  Tools.convertSecondsToTime(Duration(seconds: seconds))
                ]),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.grey, fontSize: 15.0),
              ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
