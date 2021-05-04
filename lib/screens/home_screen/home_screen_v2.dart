import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/search_input.dart';
import '../../models/app_model.dart';
import '../../models/home_screen_model.dart';
import '../../models/item_list_screen_model.dart';
import '../../tools/widget_generate.dart';
import '../search_screen/search_screen_index.dart';
import 'widgets/home_banner_gallery.dart';

class HomeScreenV2 extends StatefulWidget {
  @override
  _HomeScreenV2State createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2>
    with AutomaticKeepAliveClientMixin<HomeScreenV2> {
  final _scrollController = ScrollController();
  var currentPosition = 0;
  bool isSearchBarRebuilt = false;
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
    _scrollController.addListener(() {
      if (_scrollController.offset >
          MediaQuery.of(context).size.height * 0.25) {
        if (!isSearchBarRebuilt) {
          isSearchBarRebuilt = true;
          setState(() {});
        }
      } else {
        if (isSearchBarRebuilt) {
          isSearchBarRebuilt = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Consumer2<HomeScreenModel, AppModel>(
      builder: (context, model, model2, _) => Scaffold(
        backgroundColor: theme.backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return [
              SliverPersistentHeader(
                delegate: MySliverAppBar(
                    expandedHeight: size.height * 0.4,
                    images: model2.appConfig['homeScreen']['images'] ?? []),
                pinned: true,
              ),
            ];
          },
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              padding: const EdgeInsets.only(top: 0.0),
              shrinkWrap: true,
              children: [
                InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreenIndex(
                                  version: model2.appConfig['other']
                                      ['searchScreen']['version'],
                                ))),
                    child: Container(
                      height: 20.0,
                      width: size.width,
                    )),
                ...WidgetGenerate.buildHomeLayout(
                    model, model2.appConfig, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<dynamic> images;
  MySliverAppBar({@required this.expandedHeight, this.images});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var searchBarOffset = expandedHeight - shrinkOffset - 20;

    return Consumer<AppModel>(
      builder: (context, model, _) => Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          HomeBannerGallery(
            expandedHeight: expandedHeight,
            imageGallery: images ?? [],
          ),
          (shrinkOffset < expandedHeight - 60)
              ? Positioned(
                  top: searchBarOffset,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreenIndex(
                                version: model.appConfig['other']
                                    ['searchScreen']['version']))),
                    child: Center(
                      child: Container(
                        height: 40.0,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                          left: 60 / 2,
                          right: 60 / 2,
                        ),
                        child: const SearchInput(
                          height: 40.0,
                        ),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreenIndex(
                              version: model.appConfig['other']['searchScreen']
                                  ['version']))),
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 60 / 2, right: 60 / 2, top: 20.0),
                    color: Theme.of(context).backgroundColor,
                    child: const Center(
                      child: SearchInput(
                        height: 40.0,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 45.0 + kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
