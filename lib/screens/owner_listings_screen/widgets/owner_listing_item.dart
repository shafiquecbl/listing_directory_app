import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/listing.dart';
import '../../../tools/tools.dart';
import '../../payment_screen/payment_screen.dart';
import '../../submit_listing_screen/edit_listing_screen/edit_listing_screen.dart';

class OwnerListingItem extends StatelessWidget {
  final Listing listing;
  final Function onFinish;
  const OwnerListingItem(
      {Key key, @required this.listing, @required this.onFinish})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => listing.pricePlan != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EditListingScreen(
                        onFinish: onFinish,
                        listing: listing,
                      )))
          : null,
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: theme.splashColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
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
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: theme.textTheme.headline6,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (listing.planName.isNotEmpty) ...[
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        'listingPlan'.tr(args: [
                          Tools.capitalizeFirstLetter(listing.planName)
                        ]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text('listingStatus'.tr(args: [
                        Tools.capitalizeFirstLetter(listing.postStatus)
                      ])),
                      if (!listing.isPaid) ...[
                        const Expanded(child: SizedBox(width: 1)),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        listing: listing,
                                        onFinish: onFinish,
                                      ))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(2.0),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: 3.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ]),
                            child: Text('unpaid'.tr(),
                                style: theme.textTheme.caption
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                      if (listing.isPaid) ...[
                        const Expanded(child: SizedBox(width: 1)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Text('paid'.tr(),
                              style: theme.textTheme.caption
                                  .copyWith(color: Colors.white)),
                        ),
                      ]
                    ],
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
