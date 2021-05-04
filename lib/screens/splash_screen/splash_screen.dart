import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/app_constants.dart';
import '../../configs/dynamic_link_config.dart';
import '../../enums/enums.dart';
import '../../models/app_model.dart';
import '../on_boarding_screen/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDone = false;
  bool isEnd = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        setState(() => isDone = true);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          DynamicLinkService.initDynamicLinks(context, AppState.closed);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isFirstTime =
        Provider.of<AppModel>(context, listen: false).isFirstTime;
    return Stack(
      children: [
        if (isFirstTime) OnBoardingScreen(),
        isEnd
            ? Container()
            : Container(
                width: size.width,
                height: size.height,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: isDone ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: CachedNetworkImage(
                      imageUrl: kLogo,
                      width: 100.0,
                      height: 100.0,
                    ),
                    onEnd: () => setState(() => isEnd = true),
                  ),
                ),
              ),
      ],
    );
  }
}
