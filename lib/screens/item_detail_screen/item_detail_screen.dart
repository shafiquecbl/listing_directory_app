import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/ad_mob_widget.dart';
import '../../common_widgets/header_widget.dart';
import '../../common_widgets/price_widget.dart';
import '../../common_widgets/search_input.dart';
import '../../configs/app_config.dart';
import '../../entities/listing.dart';
import '../../entities/review.dart';
import '../../entities/user.dart';
import '../../enums/enums.dart';
import '../../models/authentication_model.dart';
import '../../models/wish_list_screen_model.dart';
import '../../tools/tools.dart';
import '../authentication_screen/login_screen.dart';
import '../message_user_screen/message_user_screen_v1.dart';
import 'item_detail_screen_model.dart';
import 'widgets/booking_widgets/booking_widget.dart';
import 'widgets/event_widgets/event_item_v1.dart';
import 'widgets/event_widgets/event_slider.dart';
import 'widgets/listing_gallery/listing_gallery_v1.dart';
import 'widgets/review_widgets/review_item_v1.dart';
import 'widgets/review_widgets/review_loading_item_v1.dart';
import 'widgets/review_widgets/review_submit.dart';
import 'widgets/review_widgets/social_contact.dart';

part 'item_detail_screen_actions.dart';

class ItemDetailScreen extends StatefulWidget {
  final Listing listing;

  const ItemDetailScreen({Key key, this.listing}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final authModel = Provider.of<AuthenticationModel>(context, listen: false);
    return ChangeNotifierProvider<ItemDetailScreenModel>(
        create: (_) => ItemDetailScreenModel(widget.listing),
        lazy: false,
        child: Scaffold(
          backgroundColor: theme.backgroundColor,
          body: Container(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            backgroundColor: theme.backgroundColor,
                            expandedHeight: size.height * 0.3,
                            brightness: theme.brightness,
                            flexibleSpace: FlexibleSpaceBar(
                              background: ListingGalleryV1(
                                images: widget.listing.galleryImages,
                              ),
                            ),
                            pinned: true,
                            floating: false,
                            actions: <Widget>[
                              Consumer<AuthenticationModel>(
                                builder: (_, model, __) =>
                                    model.user?.id.toString() !=
                                            widget.listing.authorId
                                        ? IconButton(
                                            icon: const Icon(Icons.message),
                                            onPressed: _createChat,
                                          )
                                        : Container(),
                              ),
                              Consumer<WishListScreenModel>(
                                  builder: (context, wishListModel, _) {
                                var tmp = wishListModel.wishListItems
                                    .firstWhere(
                                        (element) =>
                                            element.id == widget.listing.id,
                                        orElse: () => null);

                                return IconButton(
                                  icon: Icon(tmp != null
                                      ? FontAwesomeIcons.solidHeart
                                      : FontAwesomeIcons.heart),
                                  tooltip: 'saveListing'.tr(),
                                  onPressed: () {
                                    if (authModel.user == null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                      return;
                                    }
                                    wishListModel.addOrRemoveWishList(
                                        widget.listing, authModel.user);
                                  },
                                );
                              }),
                              Consumer<ItemDetailScreenModel>(
                                builder: (_, model, __) => IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () =>
                                      model.shareListing(widget.listing.link),
                                ),
                              ),
                            ],
                            iconTheme: theme.iconTheme,
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  color: theme.backgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.listing.title,
                                        style: theme.textTheme.headline5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10.0),
                                                Text(widget
                                                        .listing
                                                        .lpListingproOptions
                                                        .gAddress ??
                                                    ''),
                                                const SizedBox(height: 10.0),
                                                PriceWidget(
                                                  listing: widget.listing,
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  widget.listing.openStatus ==
                                                          'open'
                                                      ? 'openNow'.tr()
                                                      : 'closedNow'.tr(),
                                                  style: theme
                                                      .textTheme.bodyText2
                                                      .copyWith(
                                                          color: widget.listing
                                                                      .openStatus ==
                                                                  'open'
                                                              ? Colors.green
                                                              : Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.listing.listingRate ??
                                                    '',
                                                style: theme.textTheme.headline5
                                                    .copyWith(
                                                        color: Colors
                                                            .orangeAccent),
                                              ),
                                              const Text('review').plural(
                                                  int.parse(widget.listing
                                                          .listingReviewed) ??
                                                      0),
                                              if (widget
                                                  .listing.isEnableBooking) ...[
                                                const SizedBox(height: 10.0),
                                                Consumer<ItemDetailScreenModel>(
                                                  builder:
                                                      (context, model, _) =>
                                                          ElevatedButton(
                                                    onPressed: () =>
                                                        _showBookingBottomSheet(
                                                            model),
                                                    child: Text('bookNow'.tr()),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                    height: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: _buildUrl(),
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                _buildContact(),
                                _buildFeature(),
                                _buildLocation(),
                                _buildListTag(),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10.0),
                                _buildEventCard(),
                                const SizedBox(height: 10.0),
                                Consumer<ItemDetailScreenModel>(
                                  builder: (context, model, _) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: HeaderWidget(
                                      title: 'reviews'.tr(),
                                      onTapTitle: model.reviews.length <= 5
                                          ? null
                                          : 'viewAll'.tr(),
                                      onTap: () => null,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Consumer<ItemDetailScreenModel>(
                                  builder: (context, model, _) {
                                    if (model.state == ReviewState.loading) {
                                      return Column(
                                        children: List.generate(
                                            3,
                                            (index) =>
                                                const ReviewLoadingItemV1()),
                                      );
                                    }

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: model.reviews.isNotEmpty
                                          ? Column(
                                              children: List.generate(
                                                  model.reviews.length,
                                                  (index) => ReviewItemV1(
                                                        onLongPress: model
                                                                    .reviews[
                                                                        index]
                                                                    .author ==
                                                                authModel
                                                                    .user.id
                                                            ? () => showReviewOption(
                                                                model.reviews[
                                                                    index],
                                                                authModel.user,
                                                                model
                                                                    .deleteReview,
                                                                (review) =>
                                                                    _showReviewScreen(
                                                                        model,
                                                                        review:
                                                                            review))
                                                            : null,
                                                        review: model
                                                            .reviews[index],
                                                      )),
                                            )
                                          : Center(
                                              child:
                                                  const Text('noReview').tr()),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10.0),
                                Consumer<ItemDetailScreenModel>(
                                  builder: (context, model, _) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: InkWell(
                                      onTap: () => _showReviewScreen(model),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SearchInput(
                                              hintText: 'createReview'.tr(),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          const Icon(Icons.send),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AdMobWidget(),
              ],
            ),
          ),
        ));
  }
}
