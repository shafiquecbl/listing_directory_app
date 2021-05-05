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
    return Container(
      width: size.width,
      height: 125,
      margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith(
              (states) => Colors.deepPurpleAccent),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemListScreenV1(
                      catName: category.name, categoryIds: [category.id])));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: enableBanner && category.banner.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: category.banner,
                        fit: BoxFit.fill,
                        width: 60,
                        height: 60,
                      )
                    : Icon(
                        Icons.image,
                        color: Colors.black54,
                        size: 60,
                      )),
            SizedBox(
              height: 14,
            ),
            AutoSizeText(
              category.name,
              style: theme.textTheme.headline5
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              minFontSize: 1.0,
              maxFontSize: 20,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
