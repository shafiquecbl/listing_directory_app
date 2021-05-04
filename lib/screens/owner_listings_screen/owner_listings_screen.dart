import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/authentication_model.dart';
import 'owner_listings_screen_model.dart';
import 'widgets/owner_listing_item.dart';
import 'widgets/owner_listing_loading_item.dart';

class OwnerListingsScreen extends StatefulWidget {
  @override
  _OwnerListingsScreenState createState() => _OwnerListingsScreenState();
}

class _OwnerListingsScreenState extends State<OwnerListingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    final theme = Theme.of(context);
    return ChangeNotifierProvider<OwnerListingsModel>(
      create: (_) => OwnerListingsModel(user),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          title: Text(
            'myListings'.tr(),
            style: theme.textTheme.headline6,
          ),
          brightness: theme.brightness,
          centerTitle: true,
          backgroundColor: theme.backgroundColor,
          iconTheme: theme.iconTheme,
        ),
        body: Consumer<OwnerListingsModel>(builder: (_, model, __) {
          if (model.state == OwnerListingsState.loading) {
            return SingleChildScrollView(
                child: Column(
              children: List.generate(5, (index) => OwnerListingLoadingItem()),
            ));
          }

          if (model.state == OwnerListingsState.noData) {
            return SmartRefresher(
              controller: model.refreshController,
              enablePullUp: false,
              enablePullDown: true,
              onRefresh: () => model.getListings(user),
              child: Center(child: Text('noData'.tr())),
            );
          }
          return SmartRefresher(
            controller: model.refreshController,
            enablePullUp: true,
            enablePullDown: true,
            onLoading: () => model.loadMoreListings(user),
            onRefresh: () => model.getListings(user),
            child: ListView.builder(
              itemBuilder: (context, index) => OwnerListingItem(
                listing: model.listings[index],
                onFinish: () => model.getListings(user),
              ),
              itemCount: model.listings.length,
            ),
          );
        }),
      ),
    );
  }
}
