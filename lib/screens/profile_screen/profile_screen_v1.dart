import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/common_input.dart';
import '../../configs/app_constants.dart';
import '../../models/authentication_model.dart';

class ProfileScreenV1 extends StatefulWidget {
  @override
  _ProfileScreenV1State createState() => _ProfileScreenV1State();
}

class _ProfileScreenV1State extends State<ProfileScreenV1> {
  dynamic avatar;
  @override
  void initState() {
    avatar =
        Provider.of<AuthenticationModel>(context, listen: false).user.avatar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'profile',
              style: theme.textTheme.headline6,
            ).tr(),
            centerTitle: true,
            backgroundColor: theme.backgroundColor,
            brightness: theme.brightness,
            iconTheme: theme.iconTheme,
          ),
          floatingActionButton: Consumer<AuthenticationModel>(
            builder: (_, model, __) => ElevatedButton(
              style: ElevatedButton.styleFrom(primary: theme.accentColor),
              child: Text('update'.tr()),
              onPressed: () {
                FocusScope.of(context).unfocus();
                model.updateProfile(avatar: avatar);
              },
            ),
          ),
          body: Container(
            width: size.width,
            height: size.height,
            color: theme.backgroundColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Consumer<AuthenticationModel>(
              builder: (_, model, __) => Column(
                children: [
                  InkWell(
                    onTap: () async {
                      avatar = await model.pickImages();
                      setState(() {});
                    },
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (avatar is String)
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      (avatar != null && avatar.isNotEmpty)
                                          ? avatar
                                          : kDefaultImage),
                                  radius: 80),
                            ),
                          if (avatar is Asset)
                            Container(
                              width: 80.0,
                              height: 80.0,
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200.0),
                                child: AssetThumb(
                                  asset: avatar,
                                  width: 300,
                                  height: 300,
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: theme.accentColor.withOpacity(0.7),
                              ),
                              child: const Icon(
                                FontAwesomeIcons.camera,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  CommonInput(
                    controller: model.displayNameController,
                    hintText: 'displayName'.tr(),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                          child: CommonInput(
                        controller: model.firstNameController,
                        hintText: 'firstName'.tr(),
                      )),
                      const SizedBox(width: 10.0),
                      Expanded(
                          child: CommonInput(
                        controller: model.lastNameController,
                        hintText: 'lastName'.tr(),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<AuthenticationModel>(
          builder: (_, model, __) => model.state == AuthenticationState.loading
              ? Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.grey.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
