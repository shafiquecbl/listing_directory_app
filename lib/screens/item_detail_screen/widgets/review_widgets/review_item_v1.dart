import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../common_widgets/gallery_showcase.dart';
import '../../../../configs/app_constants.dart';
import '../../../../entities/review.dart';

class ReviewItemV1 extends StatefulWidget {
  final Review review;
  final Function onLongPress;
  const ReviewItemV1({Key key, this.review, this.onLongPress})
      : super(key: key);

  @override
  _ReviewItemV1State createState() => _ReviewItemV1State();
}

class _ReviewItemV1State extends State<ReviewItemV1> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    (widget.review.authorAvt == null ||
                            widget.review.authorAvt.isEmpty)
                        ? kDefaultImage
                        : widget.review.authorAvt),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.review.authorName),
                  const SizedBox(height: 5.0),
                  Text('review'.plural(widget.review.reviewCount)),
                ],
              ),
              const Expanded(child: SizedBox(width: 1.0)),
              Text(widget.review.date),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              RatingBar.builder(
                initialRating:
                    double.parse(widget.review.lpListingproOptions.rating),
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
              const SizedBox(width: 5.0),
              Text(widget.review.lpListingproOptions.rating),
              const Expanded(child: SizedBox(width: 1)),
              if (widget.onLongPress != null)
                InkWell(
                  onTap: widget.onLongPress,
                  child: const Icon(
                    FontAwesomeIcons.edit,
                    size: 18.0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5.0),
          Text(
            widget.review.title,
            style: theme.textTheme.subtitle1
                .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
          const SizedBox(height: 5.0),
          Text(
            widget.review.content,
            style: theme.textTheme.bodyText2,
          ),
          const SizedBox(height: 5.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.review.galleryImages.length,
                (index) => InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GalleryShowCase(
                        position: index,
                        images: widget.review.galleryImages,
                      ),
                    ),
                  ),
                  child: Container(
                    width: 75.0,
                    height: 75.0,
                    margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.review.galleryImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
