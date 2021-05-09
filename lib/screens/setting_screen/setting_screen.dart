import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../configs/app_constants.dart';
import '../../models/app_model.dart';
import '../../models/authentication_model.dart';
import '../appointment_list_screen/appointment_list_screen.dart';
import '../authentication_screen/login_screen.dart';
import '../booking_history_screen/booking_history_screen.dart';
import '../owner_listings_screen/owner_listings_screen.dart';
import '../profile_screen/profile_screen_v1.dart';
import '../submit_listing_screen/submit_plan_and_listing/submit_listing_screen.dart';
import 'widgets/select_language.dart';
import 'widgets/setting_item_v1.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appModel = Provider.of<AppModel>(context, listen: false);
    final theme = Theme.of(context);
    return Consumer<AuthenticationModel>(
      builder: (context, authModel, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            'settings'.tr(),
            style: theme.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: theme.backgroundColor,
          brightness: theme.brightness,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          color: theme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: CachedNetworkImageProvider((authModel
                                    ?.user?.avatar !=
                                null &&
                            authModel.user.avatar.isNotEmpty)
                        ? authModel.user.avatar
                        : 'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/nullUser.png?alt=media&token=25dcd49e-5edc-4fb6-8610-c02a5050e25d'),
                    radius: 60),
                const SizedBox(height: 10.0),
                Text(
                  authModel.user?.displayName ?? 'guest'.tr(),
                  style: theme.textTheme.headline4,
                ),
                const SizedBox(height: 20.0),
                if (authModel.state == AuthenticationState.loggedIn)
                  SettingItemV1(
                    icon: FontAwesomeIcons.user,
                    title: 'myProfile'.tr(),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreenV1())),
                  ),
                // if (authModel.state == AuthenticationState.loggedIn)
                //   SettingItemV1(
                //     icon: Icons.add,
                //     title: 'addListing'.tr(),
                //     onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => SubmitListingScreen())),
                //   ),
                // if (authModel.state == AuthenticationState.loggedIn)
                //   SettingItemV1(
                //     icon: Icons.list_sharp,
                //     title: 'myListings'.tr(),
                //     onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => OwnerListingsScreen())),
                //   ),
                if (authModel.state == AuthenticationState.loggedIn)
                  SettingItemV1(
                    icon: FontAwesomeIcons.user,
                    title: 'appointments'.tr(),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentListScreen())),
                  ),
                SettingItemV1(
                  icon: appModel.isDarkTheme
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.sun,
                  title: 'darkTheme'.tr(),
                  onTap: appModel.setTheme,
                  switchValue: appModel.isDarkTheme,
                ),
                SettingItemV1(
                  icon: FontAwesomeIcons.globe,
                  title: 'languages'.tr(),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (subContext) => SelectLanguage());
                  },
                ),
                // if (authModel.state == AuthenticationState.loggedIn)
                //   SettingItemV1(
                //     icon: Icons.history,
                //     title: 'bookingHistory'.tr(),
                //     onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => BookingHistoryScreen())),
                //   ),
                if (authModel.state == AuthenticationState.notLogin)
                  SettingItemV1(
                    icon: FontAwesomeIcons.doorClosed,
                    title: 'login'.tr(),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                  ),
                if (authModel.state == AuthenticationState.loggedIn)
                  SettingItemV1(
                    icon: FontAwesomeIcons.doorOpen,
                    title: 'logout'.tr(),
                    onTap: () => authModel.logout(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
