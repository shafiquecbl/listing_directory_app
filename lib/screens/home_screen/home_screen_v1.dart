import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/search_input.dart';
import '../../configs/app_constants.dart';
import '../../models/app_model.dart';
import '../../models/authentication_model.dart';
import '../../models/home_screen_model.dart';
import '../../models/item_list_screen_model.dart';
import '../../tools/widget_generate.dart';
import '../search_screen/search_screen_index.dart';

class HomeScreenV1 extends StatefulWidget {
  @override
  _HomeScreenV1State createState() => _HomeScreenV1State();
}

class _HomeScreenV1State extends State<HomeScreenV1>
    with AutomaticKeepAliveClientMixin<HomeScreenV1> {
  @override
  void initState() {
    super.initState();
    final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
    final homeScreenConfig = appConfig['homeScreen']['layout'];
    final homeScreenProvider =
        Provider.of<HomeScreenModel>(context, listen: false);
    final itemListScreenProvider =
        Provider.of<ItemListScreenModel>(context, listen: false);
    homeScreenProvider.initLayout(homeScreenConfig);
    itemListScreenProvider.initGetAll();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Consumer2<HomeScreenModel, AppModel>(
      builder: (context, model, model2, _) => Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: theme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('homeTitle1'.tr()),
                          Text('homeTitle2'.tr()),
                        ],
                      ),
                      const Expanded(child: SizedBox(width: 1)),
                      Consumer<AuthenticationModel>(
                        builder: (context, authModel, _) => authModel.user !=
                                null
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                    authModel.user.avatar.isNotEmpty
                                        ? authModel.user.avatar
                                        : kDefaultImage),
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 20.0,
                                backgroundImage: NetworkImage(kDefaultImage),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreenIndex(
                                  version: model2.appConfig['other']
                                      ['searchScreen']['version']))),
                      child: const SearchInput()),
                  const SizedBox(height: 10.0),
                  Column(
                    children: WidgetGenerate.buildHomeLayout(
                        model, model2.appConfig, context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
