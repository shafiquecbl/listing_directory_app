import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../entities/category.dart';
import '../../item_list_screen/item_list_screen_v1.dart';

class CategoryCardItemV1 extends StatelessWidget {
  final Category category;
  final bool enableBanner;
  final Color color;
  const CategoryCardItemV1(
      {Key key,
      @required this.category,
      @required this.color,
      this.enableBanner})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemListScreenV1(
                  catName: category.name, categoryIds: [category.id]))),
      child: Container(
        width: size.width,
        height: 125,
        margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        decoration: BoxDecoration(
          color: enableBanner
              ? category.banner.isEmpty
                  ? color
                  : null
              : color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (enableBanner && category.banner.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: category.banner,
                  fit: BoxFit.cover,
                  width: size.width,
                  height: 125,
                ),
              ),
            Center(
              child: Container(
                width: size.width,
                height: 125,
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color:
                            enableBanner ? Colors.black.withOpacity(0.3) : null,
                        borderRadius: BorderRadius.circular(15.0)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: AutoSizeText(
                      category.name,
                      style: theme.textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.white),
                      minFontSize: 1.0,
                      maxFontSize: 20,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
