import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_model.dart';
import '../../models/item_list_screen_model.dart';
import 'widgets/category_card_item_v1.dart';

class CategoryScreenV1 extends StatefulWidget {
  @override
  _CategoryScreenV1State createState() => _CategoryScreenV1State();
}

class _CategoryScreenV1State extends State<CategoryScreenV1>
    with AutomaticKeepAliveClientMixin<CategoryScreenV1> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    Widget _buildCategoryWidgets() {
      final model = Provider.of<ItemListScreenModel>(context, listen: false);
      final appConfig = Provider.of<AppModel>(context, listen: false).appConfig;
      var widgets = <Widget>[];
      if (!appConfig['categoryScreen']['all']) {
        for (var item in appConfig['categoryScreen']['layout']) {
          final category = model.categories.firstWhere(
              (cate) => cate.id == item['category'],
              orElse: () => null);
          if (category != null) {
            widgets.add(
              CategoryCardItemV1(
                category: category,
                enableBanner: appConfig['categoryScreen']['enableBanner'],
                color: Color(
                  item['color'],
                ),
              ),
            );
          }
        }
      } else {
        for (var category in model.categories) {
          widgets.add(
            CategoryCardItemV1(
              category: category,
              color: Color(
                appConfig['categoryScreen']['allColor'],
              ),
              enableBanner: appConfig['categoryScreen']['enableBanner'],
            ),
          );
        }
      }

      final col = appConfig['categoryScreen']['column'] ?? 1;

      if (col > 1) {
        return GridView.builder(
          itemCount: widgets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: col, crossAxisSpacing: 20.0),
          itemBuilder: (BuildContext context, int index) {
            return widgets[index];
          },
          cacheExtent: 1000,
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'category',
          style: theme.textTheme.headline6,
        ).tr(context: context),
        centerTitle: true,
        backgroundColor: theme.backgroundColor,
        brightness: theme.brightness,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: theme.backgroundColor,
        padding: const EdgeInsets.all(10.0),
        child: _buildCategoryWidgets(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
