import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/price_widget.dart';
import '../../../common_widgets/rating_widget.dart';
import '../../../entities/listing.dart';
import '../../../models/authentication_model.dart';
import '../../../tools/tools.dart';
import '../../item_detail_screen/item_detail_screen.dart';

class DiscoverItemV2 extends StatelessWidget {
  final Listing listing;
  final String text;
  final Function onTap;
  const DiscoverItemV2({Key key, this.listing, this.text, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authModel = Provider.of<AuthenticationModel>(context, listen: false);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.splashColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Colors.grey,
                width: 80.0,
                height: 80.0,
                child: CachedNetworkImage(
                  imageUrl: listing.featuredImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (listing.isAd)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          margin: const EdgeInsets.only(right: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.yellow, width: 1),
                          ),
                          child: Text(
                            'Ad',
                            style: theme.textTheme.caption
                                .copyWith( fontSize: 10.0),
                          ),
                        ),
                      Flexible(
                        child: Text(
                          listing.title,
                          style: theme.textTheme.headline6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  PriceWidget(listing: listing),
                  const SizedBox(height: 5.0),
                  Text(
                    Tools.calDistance(
                        authModel.locationData.latitude,
                        authModel.locationData.longitude,
                        listing.lpListingproOptions.latitude,
                        listing.lpListingproOptions.longitude),
                  ),
                  const SizedBox(height: 5.0),
                  RatingWidget(listing),
                ],
              ),
            ),
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ItemDetailScreen(
                          listing: listing,
                        ))),
                icon: Icon(Directionality.of(context) == TextDirection.rtl
                    ? Icons.arrow_back_ios_sharp
                    : Icons.arrow_forward_ios_sharp)),
          ],
        ),
      ),
    );
  }
}
