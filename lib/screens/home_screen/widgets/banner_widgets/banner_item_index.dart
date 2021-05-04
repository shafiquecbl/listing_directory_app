import 'package:flutter/material.dart';

import '../../../../entities/listing.dart';
import '../../../item_detail_screen/item_detail_screen.dart';
import '../../../item_list_screen/item_list_screen_v1.dart';
import 'banner_item_v1.dart';

class BannerItemIndex extends StatelessWidget {
  final Map<dynamic, dynamic> item;
  final Listing listing;

  const BannerItemIndex({Key key, this.listing, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (listing != null) {
      return BannerItemV1(
        listing: listing,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(
                        listing: listing,
                      )));
        },
      );
    }

    return BannerItemV1(
      imgUrl: item['imageUrl'],
      title: item['title'],
      listing: listing,
      onTap: () {
        if (item['type'] == 'category') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemListScreenV1(
                        categoryIds: item['ids'],
                      )));
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
                      listing: listing,
                    )));
      },
    );
  }
}
