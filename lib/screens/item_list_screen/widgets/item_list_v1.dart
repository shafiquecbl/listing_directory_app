import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../entities/listing.dart';
import '../../item_detail_screen/item_detail_screen.dart';

class ItemListV1 extends StatelessWidget {
  final Listing listing;

  const ItemListV1({Key key, this.listing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemDetailScreen(
                listing: listing,
              ))),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            border: Border.all(color: theme.splashColor),
            // color: theme.cardColor,
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: listing.featuredImage ??
                    'https://redzonekickboxing.com/wp-content/uploads/2017/04/default-image-620x600.jpg',
                height: 250,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (listing.isAd)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Ad',
                        style: theme.textTheme.caption.copyWith(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                const SizedBox(width: 5.0),
                Flexible(
                  child: Text(
                    listing.title,
                    style: theme.textTheme.headline6,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            RatingBar.builder(
              initialRating: double.parse(listing.listingRate),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 15.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ],
        ),
      ),
    );
  }
}
