import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../item_list_screen/item_list_screen_v1.dart';

class CategoryItemV2 extends StatelessWidget {
  final Map categoriesConfig;
  final Map category;

  const CategoryItemV2({
    Key key,
    this.categoriesConfig,
    this.category,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemListScreenV1(
                    catName: category[categoriesConfig['id']].name,
                    categoryIds: categoriesConfig['id'] == -1
                        ? []
                        : [category[categoriesConfig['id']].id],
                  ))),
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: categoriesConfig['icon'],
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            Text(
              categoriesConfig['id'] == -1
                  ? 'more'.tr()
                  : category[categoriesConfig['id']].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
