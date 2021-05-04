import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_model.dart';
import 'home_screen_v1.dart';
import 'home_screen_v2.dart';

class HomeIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    if (appConfig['homeScreen']['version'] == 'v1') {
      return HomeScreenV1();
    }
    return HomeScreenV2();
  }
}
