import 'package:flutter/material.dart';

import 'category_item_loading_v1.dart';
import 'category_item_v1.dart';
import 'category_item_v2.dart';

class CategoryItemIndex extends StatelessWidget {
  final Map categoriesConfig;
  final Map category;
  final bool isLoading;
  final String version;

  const CategoryItemIndex(
      {Key key,
      @required this.categoriesConfig,
      @required this.category,
      this.isLoading = false,
      @required this.version})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (version == 'v2') {
      if (isLoading) {
        return CategoryItemLoadingV1();
      }
      return CategoryItemV2(
        categoriesConfig: categoriesConfig,
        category: category,
      );
    }

    /// Default version 1
    if (isLoading) {
      return CategoryItemLoadingV1();
    }
    return CategoryItemV1(
      categoriesConfig: categoriesConfig,
      category: category,
    );
  }
}
