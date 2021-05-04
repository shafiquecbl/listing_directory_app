import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/price_widget.dart';
import '../../../entities/listing.dart';
import '../../item_detail_screen/item_detail_screen.dart';

class SearchItemV1 extends StatelessWidget {
  final Listing listing;

  const SearchItemV1({Key key, this.listing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemDetailScreen(
                listing: listing,
              ))),
      child: Container(
        height: 60.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                  imageUrl: listing.featuredImage,
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
            ),
            const SizedBox(width: 5.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (listing.isAd)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange, width: 1),
                          ),
                          child: Text(
                            'Ad',
                            style: theme.textTheme.caption
                                .copyWith(fontSize: 10.0),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 2.0),
                          child: Text(
                            listing.title ?? '',
                            style: theme.textTheme.subtitle1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  if (listing?.lpListingproOptions?.priceStatus != null)
                    PriceWidget(listing: listing),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
