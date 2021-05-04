import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../entities/listing.dart';
import '../../../item_detail_screen/item_detail_screen.dart';

class ListingItemV3 extends StatelessWidget {
  final Listing listing;

  const ListingItemV3({Key key, this.listing}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ItemDetailScreen(
                listing: listing,
              ))),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Colors.grey,
                child: CachedNetworkImage(
                  imageUrl: listing.featuredImage,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0)),
                ),
                child: Center(
                  child: Text(
                    listing.title,
                    style:
                        theme.textTheme.bodyText1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return InkWell(
    //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => ItemDetailScreen(
    //             listing: listing,
    //           ))),
    //   child: Container(
    //     height: 370,
    //     width: 250,
    //     margin: const EdgeInsets.all(10.0),
    //     child: Stack(
    //       children: [
    //         ClipRRect(
    //           borderRadius: BorderRadius.circular(20.0),
    //           child: Container(
    //             height: 320,
    //             width: 250,
    //             decoration: BoxDecoration(
    //               color: Colors.green,
    //               borderRadius: BorderRadius.circular(20.0),
    //             ),
    //             child: Image.network(
    //               'https://redzonekickboxing.com/wp-content/uploads/2017/04/default-image-620x600.jpg',
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Container(
    //             height: 130,
    //             width: 200,
    //             padding: const EdgeInsets.all(10.0),
    //             decoration: BoxDecoration(
    //               color: theme.cardColor,
    //               borderRadius: BorderRadius.circular(10.0),
    //             ),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   listing.title,
    //                   style: theme.textTheme.headline6,
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 const SizedBox(height: 5.0),
    //                 PriceWidget(
    //                   listing: listing,
    //                 ),
    //                 const SizedBox(height: 5.0),
    //                 RatingBar.builder(
    //                   initialRating: 3,
    //                   minRating: 1,
    //                   direction: Axis.horizontal,
    //                   allowHalfRating: true,
    //                   itemCount: 5,
    //                   itemSize: 15.0,
    //                   itemBuilder: (context, _) => Icon(
    //                     Icons.star,
    //                     color: Colors.amber,
    //                   ),
    //                   onRatingUpdate: (rating) {
    //                     print(rating);
    //                   },
    //                 ),
    //                 const SizedBox(height: 10.0),
    //                 SingleChildScrollView(
    //                   scrollDirection: Axis.horizontal,
    //                   child: Row(
    //                     children: List.generate(
    //                       listing.pureTaxonomies.listingCategory.length,
    //                       (index) => Container(
    //                         margin: const EdgeInsets.only(right: 10.0),
    //                         padding: const EdgeInsets.all(5.0),
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(10.0),
    //                             border: Border.all(
    //                               color: Colors.pinkAccent,
    //                             )),
    //                         child: Text(listing
    //                             .pureTaxonomies.listingCategory[index].name),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 // Row(
    //                 //   children: List.generate(
    //                 //     listing?.pureTaxonomies?.listingCategory?.length ?? 0,
    //                 //     (index) => Container(
    //                 //       child: Text(
    //                 //           listing.pureTaxonomies.listingCategory[index].name),
    //                 //     ),
    //                 //   ),
    //                 // ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
