import 'package:flutter/material.dart';

import '../category_widgets/category_item_index.dart';

class ListCategoryV1 extends StatelessWidget {
  final List<dynamic> list;
  final Map categories;
  const ListCategoryV1({Key key, this.list, this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            list.length,
            (index) => const CategoryItemIndex(
              category: null,
              categoriesConfig: null,
              isLoading: true,
              version: 'v1',
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
              categories?.length ?? 0,
              (index) => CategoryItemIndex(
                category: categories,
                categoriesConfig: list[index],
                version: 'v1',
              ),
            ),
            if (categories.isNotEmpty)
              CategoryItemIndex(
                category: categories,
                categoriesConfig: list[list.length - 1],
                version: 'v1',
              ),
          ],
        ),
      );
    }
  }
}
