import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common_widgets/search_input.dart';
import 'search_screen_model.dart';
import 'widgets/search_item_v1.dart';
import 'widgets/search_loading_item_v1.dart';

class SearchScreenV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final searchModel = Provider.of<SearchScreenModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        elevation: 0.0,
        iconTheme: theme.iconTheme,
        brightness: theme.brightness,
        title: Text(
          'search'.tr(),
          style: theme.textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: Consumer<SearchScreenModel>(
        builder: (context, model, _) => Container(
          width: size.width,
          height: size.height,
          color: theme.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SearchInput(
                autoFocus: true,
                enabledInput: true,
                controller: searchModel.searchController,
                onChanged: (val) => searchModel.getListing(),
                onClear: searchModel.clearListing,
                onSubmitted: (val) => searchModel.addLocalSearchTerm(),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    switch (model.state) {
                      case SearchState.searched:
                        return Column(
                          children: [
                            if (model.searchedListings.isEmpty &&
                                model.recentSearches.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                            child: Text('Recent searches')),
                                        InkWell(
                                            onTap: () =>
                                                model.clearLocalSearchTerm(),
                                            child: const Text('Clear')),
                                      ],
                                    ),
                                    Column(
                                      children: List.generate(
                                        model.recentSearches.length,
                                        (index) => InkWell(
                                          onTap: () => searchModel.getListing(
                                              recentSearchTerm:
                                                  model.recentSearches[index]),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.history),
                                                const SizedBox(width: 10.0),
                                                Text(model
                                                    .recentSearches[index]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (model.searchedListings.isEmpty &&
                                model.recentSearches.isEmpty)
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'searchForSomething'.tr(),
                                    style: theme.textTheme.headline4,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: SmartRefresher(
                                controller: model.refreshController,
                                enablePullUp: true,
                                onLoading: model.loadMoreSearchListings,
                                onRefresh: model.getListing,
                                child: ListView.builder(
                                  itemBuilder: (context, index) => SearchItemV1(
                                    listing: model.searchedListings[index],
                                  ),
                                  itemCount: model.searchedListings.length,
                                ),
                              ),
                            ),
                          ],
                        );
                      case SearchState.noResult:
                        return Container(
                          child: const Text('No results'),
                        );
                      case SearchState.searching:
                        return SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                5, (index) => SearchLoadingItemV1()),
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
