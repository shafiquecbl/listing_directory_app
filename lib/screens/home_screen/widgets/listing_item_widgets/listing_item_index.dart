import 'package:flutter/material.dart';

import '../../../../entities/listing.dart';
import 'listing_item_loading_v1.dart';
import 'listing_item_loading_v2.dart';
import 'listing_item_loading_v3.dart';
import 'listing_item_v1.dart';
import 'listing_item_v2.dart';
import 'listing_item_v3.dart';

class ListingItemIndex extends StatelessWidget {
  final Listing listing;
  final String version;
  final bool isLoading;

  const ListingItemIndex(
      {Key key,
      @required this.listing,
      @required this.version,
      this.isLoading = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (version == 'v2') {
      if (isLoading) {
        return ListingLoadingItemV2();
      }
      return ListingItemV2(
        listing: listing,
      );
    }
    if (version == 'v3') {
      if (isLoading) {
        return ListingLoadingItemV3();
      }
      return ListingItemV3(
        listing: listing,
      );
    }

    /// Default v1
    if (isLoading) {
      return ListingLoadingItemV1();
    }
    return ListingItemV1(
      listing: listing,
    );
  }
}
