import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/price_widget.dart';
import '../../../../entities/listing.dart';

class BannerItemV1 extends StatelessWidget {
  final String imgUrl;
  final Function onTap;
  final String title;
  final Listing listing;
  const BannerItemV1({
    Key key,
    this.imgUrl,
    this.onTap,
    this.title,
    this.listing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 350,
        width: 250,
        margin: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Container(
              height: 320,
              width: 250,
              decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CachedNetworkImage(
                  /// If listing = null mean this banner is category, otherwise, it's for listing
                  imageUrl: listing?.featuredImage ?? imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (listing == null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: theme.cardColor.withOpacity(0.7)),
                  child: Center(
                      child: Text(
                    title ?? '',
                    style:
                        theme.textTheme.headline6.copyWith(color: Colors.white),
                  )),
                ),
              ),
            if (listing != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    height: 125.0,
                    width: 200,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: theme.cardColor.withOpacity(0.7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (listing.isAd && listing != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.yellow, width: 1),
                                ),
                                child: Text(
                                  'Ad',
                                  style: theme.textTheme.caption.copyWith(
                                      color: Colors.white, fontSize: 10.0),
                                ),
                              ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(left: 2.0),
                                child: Text(
                                  listing.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.subtitle1
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        PriceWidget(listing: listing),
                        const SizedBox(height: 10.0),
                        Text(
                          listing.openStatus == 'open'
                              ? 'openNow'.tr()
                              : 'closedNow'.tr(),
                          style: theme.textTheme.caption.copyWith(
                              color: listing.openStatus == 'open'
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                listing.pureTaxonomies?.listingCategory
                                        ?.length ??
                                    3,
                                (index) => Container(
                                    margin: const EdgeInsets.only(
                                        right: 5.0, top: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0, horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: theme.accentColor, width: 1),
                                    ),
                                    child: Text(
                                      listing.pureTaxonomies
                                          .listingCategory[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: Colors.white),
                                    ))),
                          ),
                        ),
                      ],
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
