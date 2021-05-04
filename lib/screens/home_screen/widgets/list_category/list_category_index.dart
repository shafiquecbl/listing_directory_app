import 'package:flutter/material.dart';

import 'list_category_v1.dart';
import 'list_category_v2.dart';

class ListCategoryIndex extends StatelessWidget {
  final List<dynamic> list;
  final Map categories;
  final String version;

  const ListCategoryIndex({Key key, this.categories, this.version, this.list})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (version == 'v2') {
      return ListCategoryV2(
        list: list,
        categories: categories,
      );
    }

    ///Default v1
    return ListCategoryV1(
      list: list,
      categories: categories,
    );
  }
}
