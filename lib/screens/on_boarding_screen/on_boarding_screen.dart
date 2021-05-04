import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_model.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isDone = false;
  bool isEnd = false;
  final _pageController = PageController();
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3))
          .then((value) => setState(() => isDone = true));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    return isEnd
        ? Container()
        : Container(
            width: size.width,
            height: size.height,
            color: Theme.of(context).backgroundColor,
            child: Stack(
              children: [
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  allowImplicitScrolling: true,
                  children: List.generate(
                    appConfig['onBoarding']['data'].length,
                    (index) => Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: CachedNetworkImage(
                            imageUrl: appConfig['onBoarding']['data'][index]
                                ['url'],
                            width: size.width,
                            height: size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentIndex ==
                          appConfig['onBoarding']['data'].length - 1) {
                        Provider.of<AppModel>(context, listen: false)
                            .setFirstTime(false);
                        setState(() => isEnd = true);
                      } else {
                        _currentIndex++;
                        _pageController.jumpToPage(_currentIndex);
                      }
                    },
                    child: Text(_currentIndex ==
                            appConfig['onBoarding']['data'].length - 1
                        ? 'Done'
                        : 'Next'),
                  ),
                ),
              ],
            ),
          );
  }
}
