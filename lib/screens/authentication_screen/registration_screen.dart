import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/authentication_model.dart';
import '../../tools/tools.dart';
import 'registration_otp_screen.dart';
import 'widgets/authentication_input.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  void _checkEmpty() {
    final authModel = Provider.of<AuthenticationModel>(context, listen: false);
    if (Tools.checkEmptyString(authModel.firstNameRegisterController.text) ||
        Tools.checkEmptyString(authModel.lastNameRegisterController.text) ||
        Tools.checkEmptyString(authModel.emailRegisterController.text) ||
        Tools.checkEmptyString(authModel.passwordRegisterController.text) ||
        Tools.checkEmptyString(authModel.userNameRegisterController.text)) {
      showToast('insufficientInfo'.tr());
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => RegistrationOTPScreen(
                email: authModel.emailRegisterController.text,
                onCallBack: () {
                  authModel.register().then((value) {
                    if (authModel.state == AuthenticationState.loggedIn) {
                      Navigator.of(context).pop();
                    }
                  });
                })));
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthenticationModel>(context, listen: false);
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AuthenticationInput(
                hintText: 'firstName'.tr(),
                controller: authModel.firstNameRegisterController,
                icon: FontAwesomeIcons.user,
              ),
            ),
            Expanded(
              child: AuthenticationInput(
                hintText: 'lastName'.tr(),
                controller: authModel.lastNameRegisterController,
                icon: FontAwesomeIcons.userAlt,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        AuthenticationInput(
          hintText: 'username'.tr(),
          controller: authModel.userNameRegisterController,
          icon: Icons.account_circle_outlined,
        ),
        const SizedBox(height: 10.0),
        AuthenticationInput(
          hintText: 'email'.tr(),
          controller: authModel.emailRegisterController,
          icon: Icons.email,
        ),
        const SizedBox(height: 10.0),
        AuthenticationInput(
          hintText: 'password'.tr(),
          controller: authModel.passwordRegisterController,
          icon: FontAwesomeIcons.key,
          isObscure: true,
        ),
        const SizedBox(height: 30.0),
        ElevatedButton(
          onPressed: () {
            _checkEmpty();
          },
          child: const Text('signUp').tr(),
          style: ElevatedButton.styleFrom(
            primary: theme.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            elevation: 10.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          'alreadyHaveAnAccount?'.tr(),
          style: theme.textTheme.bodyText2.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 10.0),
        InkWell(
          onTap: () => authModel.controller.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn),
          child: Text(
            'signIn'.tr(),
            style: theme.textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
