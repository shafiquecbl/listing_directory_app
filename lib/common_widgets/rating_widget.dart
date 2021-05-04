import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../entities/listing.dart';

class RatingWidget extends StatelessWidget {
  final Listing listing;

  RatingWidget(this.listing);
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: double.parse(listing.listingRate),
      minRating: 1.0,
      ignoreGestures: true,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 15.0,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {},
    );
  }
}
