import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../entities/listing.dart';
import '../../../models/authentication_model.dart';
import '../../../models/wish_list_screen_model.dart';
import '../../item_detail_screen/item_detail_screen.dart';

class WishListItemV1 extends StatelessWidget {
  final Listing listing;
  final WishListScreenModel model;
  const WishListItemV1({Key key, this.listing, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authModel = Provider.of<AuthenticationModel>(context, listen: false);
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
                  listing: listing,
                ),
              ),
            ),
        child: Dismissible(
          key: Key(listing.id.toString()),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              model.addOrRemoveWishList(listing, authModel.user);
            }
          },
          direction: DismissDirection.endToStart,
          background: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Expanded(flex: 2, child: SizedBox(width: 1)),
                const Expanded(flex: 2, child: SizedBox(width: 1)),
                Expanded(
                    flex: 3,
                    child: Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.red,
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(FontAwesomeIcons.trash),
                            const SizedBox(height: 5.0),
                            const Text('Delete'),
                          ],
                        )))),
                const SizedBox(width: 10.0),
              ],
            ),
          ),
          child: Container(
            height: 80.0,
            margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: listing.featuredImage ??
                                  'https://redzonekickboxing.com/wp-content/uploads/2017/04/default-image-620x600.jpg',
                              fit: BoxFit.cover,
                            )),
                        Center(
                          child: Icon(
                            FontAwesomeIcons.solidHeart,
                            size: 20.0,
                            color: theme.accentColor,
                          ),
                        ),
                      ],
                    )),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    listing.title,
                    style: theme.textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
