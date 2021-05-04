import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/price_widget.dart';
import '../../../../configs/app_constants.dart';
import '../../../../entities/listing.dart';
import '../../../item_detail_screen/item_detail_screen.dart';

class ListingItemV2 extends StatelessWidget {
  final Listing listing;

  const ListingItemV2({Key key, this.listing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemDetailScreen(
                listing: listing,
              ))),
      child: Container(
        width: 150,
        height: 170,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: theme.splashColor, width: 2.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0)),
              child: CachedNetworkImage(
                imageUrl: listing.featuredImage ?? kDefaultImage,
                fit: BoxFit.cover,
                width: 150,
                height: 100.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      listing.title,
                      style: theme.textTheme.subtitle1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      PriceWidget(listing: listing),
                      const Expanded(child: SizedBox(width: 1)),
                      if (listing.lpListingproOptions.claimedSection)
                        const Icon(
                          Icons.verified_user_sharp,
                          color: Colors.red,
                          size: 18.0,
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
