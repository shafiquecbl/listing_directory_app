import 'package:flutter/material.dart';

import '../category_widgets/category_item_index.dart';

class ListCategoryV2 extends StatelessWidget {
  final List<dynamic> list;
  final Map categories;
  final bool isLoading;

  const ListCategoryV2(
      {Key key, this.categories, this.list, this.isLoading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 10.0,
        runSpacing: 10.0,
        children: [
          ...List.generate(
            list.length,
            (index) => const CategoryItemIndex(
              isLoading: true,
              version: 'v2',
              category: null,
              categoriesConfig: null,
            ),
          ),
        ],
      );
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ...List.generate(
          categories?.length ?? 0,
          (index) => CategoryItemIndex(
            version: 'v2',
            category: categories,
            categoriesConfig: list[index],
          ),
        ),
        // if (categories.isNotEmpty)
        //   CategoryItemIndex(
        //     version: 'v2',
        //     category: categories,
        //     categoriesConfig: list[list.length - 1],
        //   ),
      ],
    );
  }
}
