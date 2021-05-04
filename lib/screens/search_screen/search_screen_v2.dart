import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/search_input.dart';
import '../../tools/tools.dart';
import '../item_list_screen/item_list_screen_v1.dart';
import 'search_screen_model.dart';
import 'widgets/add_location.dart';
import 'widgets/search_item_v2.dart';
import 'widgets/search_loading_item_v2.dart';

class SearchScreenV2 extends StatefulWidget {
  @override
  _SearchScreenV2State createState() => _SearchScreenV2State();
}

class _SearchScreenV2State extends State<SearchScreenV2> {
  int location = -1;

  void _updateLocation(int locationId) {
    location = locationId;
    setState(() {});
  }

  void _onSubmit(String term) {
    if (!Tools.checkEmptyString(term)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemListScreenV1(
                    searchTerm: term,
                    locationIds: location == -1 ? [] : [location],
                  )));
    }
  }

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchInput(
                  autoFocus: true,
                  enabledInput: true,
                  controller: searchModel.searchController,
                  onChanged: (val) => searchModel.searchSuggestedListing(),
                  onClear: searchModel.clearListing,
                  onSubmitted: _onSubmit,
                  hintText: 'Ex:food,service,barber,...'.tr(),
                ),
                const SizedBox(height: 10.0),
                AddLocation(
                  onCallBack: _updateLocation,
                ),
                if (searchModel.state == SearchState.searching)
                  ...List.generate(5, (index) => SearchLoadingItemV2()),
                if (searchModel.state == SearchState.noResult) ...[
                  SizedBox(height: size.height / 3),
                  Center(
                    child: Text(
                      'noData'.tr(),
                      style: theme.textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                if (searchModel.state == SearchState.searched) ...[
                  if (searchModel.suggestedSearch == null &&
                      searchModel.searchController.text.trim().isEmpty) ...[
                    SizedBox(height: size.height / 3),
                    Center(
                      child: Text(
                        'searchForSomething'.tr(),
                        style: theme.textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (searchModel.suggestedSearch != null) ...[
                    Text(
                        'Matches: ${searchModel.suggestedSearch?.suggestions?.matches ?? 0}'),
                    const SizedBox(height: 20.0),
                    Column(
                      children: List.generate(
                          searchModel.suggestedSearch.suggestions.cats.length,
                          (index) => SearchItemV2(
                                cat: searchModel
                                    .suggestedSearch.suggestions.cats[index],
                                locationId: location,
                              )),
                    ),
                    Column(
                      children: List.generate(
                          searchModel.suggestedSearch.suggestions.tags.length,
                          (index) => SearchItemV2(
                                tag: searchModel
                                    .suggestedSearch.suggestions.tags[index],
                                locationId: location,
                              )),
                    ),
                    Column(
                      children: List.generate(
                          searchModel
                              .suggestedSearch.suggestions.tagsNCats.length,
                          (index) => SearchItemV2(
                                tagsNCats: searchModel.suggestedSearch
                                    .suggestions.tagsNCats[index],
                                locationId: location,
                              )),
                    ),
                    Column(
                      children: List.generate(
                          searchModel.suggestedSearch.suggestions.titles.length,
                          (index) => SearchItemV2(
                                titles: searchModel
                                    .suggestedSearch.suggestions.titles[index],
                                locationId: location,
                              )),
                    ),
                  ]
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
