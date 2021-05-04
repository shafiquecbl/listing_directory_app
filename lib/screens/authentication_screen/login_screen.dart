import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/logo.dart';
import '../../configs/app_config.dart';
import '../../models/authentication_model.dart';
import '../../tools/tools.dart';
import 'registration_screen.dart';
import 'reset_password_screen.dart';
import 'widgets/authentication_input.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const kSocialIconSize = 30.0;
    final theme = Theme.of(context);
    return Consumer<AuthenticationModel>(
        builder: (context, authModel, _) => Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    backgroundColor: theme.backgroundColor,
                    elevation: 0,
                    iconTheme: theme.iconTheme,
                    leading: IconButton(
                      icon: Icon(Tools.isDirectionRTL(context)
                          ? Icons.arrow_forward_ios_sharp
                          : Icons.arrow_back_ios_sharp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: size.width,
                          height: size.height,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          color: theme.backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      child: const Center(
                                          child: Logo(
                                    width: 100.0,
                                    height: 100.0,
                                  )))),
                              Expanded(
                                flex: 2,
                                child: PageView(
                                  controller: authModel.controller,
                                  children: [
                                    Column(
                                      children: [
                                        AuthenticationInput(
                                          hintText: 'username'.tr(),
                                          controller:
                                              authModel.userNameController,
                                          icon: Icons.account_box,
                                        ),
                                        const SizedBox(height: 10.0),
                                        AuthenticationInput(
                                          hintText: 'password'.tr(),
                                          controller:
                                              authModel.passwordController,
                                          icon: FontAwesomeIcons.key,
                                          isObscure: true,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          ResetPasswordScreen())),
                                              child: Text(
                                                'forgotPassword'.tr(),
                                                style: theme.textTheme.caption
                                                    .copyWith(
                                                        color:
                                                            Colors.blueAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            authModel.login().then((value) {
                                              if (authModel.state ==
                                                  AuthenticationState
                                                      .loggedIn) {
                                                Navigator.of(context).pop();
                                              }
                                            });
                                          },
                                          child: const Text('signIn').tr(),
                                          style: ElevatedButton.styleFrom(
                                            primary: theme.accentColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                            elevation: 10.0,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Text(
                                          'don\'tHaveAnAccount?'.tr(),
                                          style: theme.textTheme.bodyText2
                                              .copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 10.0),
                                        InkWell(
                                          onTap: () => authModel.controller
                                              .nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.easeIn),
                                          child: Text(
                                            'signUp'.tr(),
                                            style: theme.textTheme.headline6,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          'orLoginWith'.tr(),
                                          style: theme.textTheme.bodyText2
                                              .copyWith(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (!AppConfig.webPlatform)
                                              if (Platform.isIOS)
                                                IconButton(
                                                    icon: FaIcon(
                                                      FontAwesomeIcons.apple,
                                                      size: kSocialIconSize,
                                                      color: theme.accentColor,
                                                    ),
                                                    onPressed: () {
                                                      authModel
                                                          .appleLogin()
                                                          .then((value) {
                                                        if (authModel.state ==
                                                            AuthenticationState
                                                                .loggedIn) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      });
                                                    }),
                                            IconButton(
                                              icon: FaIcon(
                                                FontAwesomeIcons
                                                    .googlePlusSquare,
                                                size: kSocialIconSize,
                                                color: theme.accentColor,
                                              ),
                                              onPressed: () {
                                                authModel
                                                    .googleLogin()
                                                    .then((value) {
                                                  if (authModel.state ==
                                                      AuthenticationState
                                                          .loggedIn) {
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: FaIcon(
                                                FontAwesomeIcons.facebookSquare,
                                                size: kSocialIconSize,
                                                color: theme.accentColor,
                                              ),
                                              onPressed: () {
                                                authModel
                                                    .facebookLogin()
                                                    .then((value) {
                                                  if (authModel.state ==
                                                      AuthenticationState
                                                          .loggedIn) {
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    RegistrationScreen(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (authModel.state == AuthenticationState.loading)
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black87.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ));
  }
}
