import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../entities/listing.dart';

class PriceWidget extends StatelessWidget {
  final Listing listing;

  const PriceWidget({Key key, @required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = 4;

    if (listing.lpListingproOptions.priceStatus == 'notsay') {
      count = 0;
    }
    if (listing.lpListingproOptions.priceStatus == 'inexpensive') {
      count = 1;
    }
    if (listing.lpListingproOptions.priceStatus == 'moderate') {
      count = 2;
    }
    if (listing.lpListingproOptions.priceStatus == 'pricey') {
      count = 3;
    }
    if (listing.lpListingproOptions.priceStatus == 'ultra_high_end') {
      count = 4;
    }

    return Container(
      child: Row(
        children: List.generate(
          4,
          (index) => index < count
              ? const Icon(
                  FontAwesomeIcons.dollarSign,
                  size: 16.0,
                  color: Colors.green,
                )
              : const Icon(
                  FontAwesomeIcons.dollarSign,
                  size: 16.0,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
