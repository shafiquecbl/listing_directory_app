import 'package:flutter/material.dart';

import '../../../../entities/listing.dart';
import '../listing_item_widgets/listing_item_loading_v1.dart';
import '../listing_item_widgets/listing_item_loading_v2.dart';
import '../listing_item_widgets/listing_item_loading_v3.dart';
import '../listing_item_widgets/listing_item_v1.dart';
import '../listing_item_widgets/listing_item_v2.dart';
import '../listing_item_widgets/listing_item_v3.dart';

class ListListingItemIndex extends StatelessWidget {
  final bool isEmpty;
  final List<Listing> list;
  final String version;
  final int limit;
  const ListListingItemIndex(
      {Key key, this.isEmpty, this.list, this.version, this.limit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      if (version == 'v3') {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              5,
              (index) => ListingLoadingItemV3(),
            ),
          ),
        );
      }

      if (version == 'v2') {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              5,
              (index) => ListingLoadingItemV2(),
            ),
          ),
        );
      }

      /// Default v1
      return Column(
        children: List.generate(
          5,
          (index) => ListingLoadingItemV1(),
        ),
      );
    }

    var count = list?.length;
    if (count == null) {
      count = 0;
    } else {
      if (limit != null && count > limit) {
        count = limit;
      }
    }

    if (version == 'v2') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            count,
            (index) => ListingItemV2(listing: list[index]),
          ),
        ),
      );
    }

    if (version == 'v3') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            count,
            (index) => ListingItemV3(listing: list[index]),
          ),
        ),
      );
    }

    /// Default v1
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          count,
          (index) => ListingItemV1(listing: list[index]),
        ),
      ),
    );
  }
}
