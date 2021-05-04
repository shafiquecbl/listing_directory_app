import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common_widgets/ad_mob_widget.dart';
import '../../models/item_list_screen_model.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/item_list_loading_v1.dart';
import 'widgets/item_list_v1.dart';

class ItemListScreenV1 extends StatefulWidget {
  final List<int> categoryIds;
  final List<int> featureIds;
  final List<int> locationIds;
  final List<int> tagIds;
  final String searchTerm;

  const ItemListScreenV1(
      {Key key,
      this.categoryIds,
      this.featureIds,
      this.locationIds,
      this.tagIds,
      this.searchTerm})
      : super(key: key);
  @override
  _ItemListScreenV1State createState() => _ItemListScreenV1State();
}

class _ItemListScreenV1State extends State<ItemListScreenV1> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ItemListScreenModel>(context, listen: false);
      provider.clearOption();
      provider.getListings(
          categories: widget.categoryIds,
          features: widget.featureIds,
          locations: widget.locationIds,
          tags: widget.tagIds,
          searchTerm: widget.searchTerm);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    void _showBottomOptions(ItemListScreenModel model) {
      showModalBottomSheet(
        context: (context),
        builder: (subContext) => FilterBottomSheet(
          categories: model.categories,
          locations: model.locations,
          features: model.features,
          options: model.options,
          updateOption: model.updateOption,
        ),
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
      );
    }

    return Consumer<ItemListScreenModel>(
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme.backgroundColor,
          title: Text(
            'findListing'.tr(),
            style: theme.textTheme.headline6,
          ),
          elevation: 0.0,
          actions: [
            IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _showBottomOptions(model)),
          ],
          iconTheme: theme.iconTheme,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          color: theme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10.0),
              if (model.state == ItemListScreenState.loading)
                Flexible(
                  child: ListView.builder(
                    itemBuilder: (context, index) => ItemListLoadingV1(),
                    itemCount: 5,
                  ),
                ),
              if (model.state == ItemListScreenState.loaded ||
                  model.state == ItemListScreenState.loadMore)
                model.listings.isEmpty
                    ? Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              'noData',
                              style: theme.textTheme.headline6,
                            ).tr(),
                          ),
                        ),
                      )
                    : Flexible(
                        child: SmartRefresher(
                          controller: model.controller,
                          onLoading: model.loadMore,
                          onRefresh: model.getListings,
                          enablePullUp: true,
                          child: ListView.builder(
                            itemBuilder: (context, index) => ItemListV1(
                              listing: model.listings[index],
                            ),
                            itemCount: model.listings.length,
                            cacheExtent: 1000,
                          ),
                        ),
                      ),
              AdMobWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
