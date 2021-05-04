import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/authentication_model.dart';
import '../../models/wish_list_screen_model.dart';
import 'widgets/wish_list_item_v1.dart';
import 'widgets/wish_list_loading_item_v1.dart';

class WishListScreenV1 extends StatefulWidget {
  @override
  _WishListScreenV1State createState() => _WishListScreenV1State();
}

class _WishListScreenV1State extends State<WishListScreenV1>
    with AutomaticKeepAliveClientMixin<WishListScreenV1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final _user = Provider.of<AuthenticationModel>(context).user;
    Provider.of<WishListScreenModel>(context, listen: false)
        .initWishList(_user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text(
          'wishList'.tr(),
          style: theme.textTheme.headline6,
        ),
        centerTitle: true,
        brightness: theme.brightness,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 10.0),
        color: theme.backgroundColor,
        child: Consumer<WishListScreenModel>(builder: (context, model, _) {
          if (model.state == WishListState.loading) {
            return ListView.builder(
              itemBuilder: (context, index) => WishListLoadingItemV1(),
              itemCount: 5,
            );
          }

          if (model.wishListItems.isEmpty) {
            return Center(
              child: const Text('noData').tr(),
            );
          }

          return SmartRefresher(
            controller: model.refreshController,
            onLoading: () => model.loadMoreWishList(_user),
            onRefresh: () => model.getWishList(_user),
            enablePullUp: true,
            child: ListView.builder(
              itemBuilder: (context, index) => WishListItemV1(
                listing: model.wishListItems[index],
                model: model,
              ),
              itemCount: model.wishListItems.length,
              cacheExtent: 1000,
            ),
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
