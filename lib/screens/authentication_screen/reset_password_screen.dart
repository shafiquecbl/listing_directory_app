import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/common_input.dart';
import '../../models/authentication_model.dart';
import '../../tools/tools.dart';
import '../../tools/widget_generate.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _pageController = PageController();
  String _otp = '';
  String email = '';

  void _updateOTP(String otp) {
    _otp = otp;
  }

  void _updateEmail(String email) {
    this.email = email;
  }

  void _nextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WidgetGenerate.getAppBar('resetPassword'.tr(), theme),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            EmailPage(
              nextPage: (val, email) {
                _updateOTP(val);
                _updateEmail(email);
                _nextPage();
              },
            ),
            OTPPage(
              otp: _otp,
              nextPage: _nextPage,
            ),
            ChangePassPage(
              email: email,
            ),
          ],
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  final Function(String, String) nextPage;

  const EmailPage({Key key, @required this.nextPage}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  bool _isLoading = false;
  String email = '';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = Provider.of<AuthenticationModel>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'pleaseEnterEmailOrUsername'.tr(),
              style: theme.textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        CommonInput(
          onChanged: (val) => email = val,
          onSubmitted: (val) {
            _isLoading = true;
            setState(() {});
            model.sendPassOTP(val).then((otp) {
              if (otp.toString().length == 6) {
                widget.nextPage(otp.toString(), val);
              }
              _isLoading = false;
              setState(() {});
            });
          },
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _isLoading = true;
                  setState(() {});
                  model.sendPassOTP(email).then((otp) {
                    if (otp.toString().length == 6) {
                      widget.nextPage(otp.toString(), email);
                    }
                    _isLoading = false;
                    setState(() {});
                  });

                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(_isLoading ? 50.0 : 18.0),
                    color: theme.accentColor,
                  ),
                  width: _isLoading ? 40 : 200,
                  height: 40,
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 0.5,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            'send'.tr(),
                            style: theme.textTheme.headline6,
                          ),
                        ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class OTPPage extends StatefulWidget {
  final String otp;
  final Function nextPage;

  const OTPPage({Key key, @required this.otp, @required this.nextPage})
      : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String otp = '';
  void _checkOTP() {
    if (otp.trim() == widget.otp) {
      widget.nextPage();
    } else {
      showToast('otpNotMatch'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'yourOTP'.tr(),
              style: theme.textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        CommonInput(
          keyboardType: TextInputType.number,
          onChanged: (val) => otp = val,
          onSubmitted: (val) {
            otp = val;
            _checkOTP();
          },
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: theme.accentColor,
                ),
                width: 200,
                height: 40,
                child: Center(
                  child: Text(
                    'check'.tr(),
                    style: theme.textTheme.headline6,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ChangePassPage extends StatefulWidget {
  final String email;

  const ChangePassPage({Key key, this.email}) : super(key: key);
  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  String _firstPassword = '';
  String _secondPassword = '';
  bool _isLoading = false;
  void _checkPass() {
    if (_firstPassword.trim().isEmpty || _secondPassword.trim().isEmpty) {
      return;
    }
    if (_firstPassword.trim() != _secondPassword.trim()) {
      showToast('passNotMatch'.tr());
      return;
    }
    if (_firstPassword.trim() == _secondPassword.trim()) {
      final model = Provider.of<AuthenticationModel>(context, listen: false);
      _isLoading = true;
      setState(() {});
      model.resetPassword(widget.email, _firstPassword).then((value) {
        _isLoading = false;
        setState(() {});
        if (value == 1) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'yourOTP'.tr(),
              style: theme.textTheme.headline6,
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        CommonInput(
          onSubmitted: (val) {
            _firstPassword = val;
          },
          onChanged: (val) => _firstPassword = val,
        ),
        const SizedBox(height: 20.0),
        CommonInput(
          onSubmitted: (val) {
            _secondPassword = val;
          },
          onChanged: (val) => _secondPassword = val,
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _checkPass();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(_isLoading ? 50.0 : 18.0),
                    color: theme.accentColor,
                  ),
                  width: _isLoading ? 40 : 200,
                  height: 40,
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 0.5,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            'send'.tr(),
                            style: theme.textTheme.headline6,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
