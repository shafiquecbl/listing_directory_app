import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../entities/suggested_search.dart';
import '../../../enums/enums.dart';
import '../../../tools/tools.dart';
import '../../item_detail_screen/item_detail_screen.dart';
import '../../item_list_screen/item_list_screen_v1.dart';

class SearchItemV2 extends StatefulWidget {
  final TagsNCats tagsNCats;
  final Tag tag;
  final Tag cat;
  final Titles titles;
  final int locationId;
  const SearchItemV2(
      {Key key,
      this.tagsNCats,
      this.tag,
      this.titles,
      this.cat,
      this.locationId})
      : super(key: key);

  @override
  _SearchItemV2State createState() => _SearchItemV2State();
}

class _SearchItemV2State extends State<SearchItemV2> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void _onTap() {
      if (widget.tagsNCats != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemListScreenV1(
                      categoryIds: [widget.tagsNCats.catTermId],
                      tagIds: [widget.tagsNCats.tagTermId],
                      locationIds:
                          widget.locationId == -1 ? [] : [widget.locationId],
                    )));
      }
      if (widget.tag != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemListScreenV1(
                      tagIds: [widget.tag.termId],
                      locationIds:
                          widget.locationId == -1 ? [] : [widget.locationId],
                    )));
      }
      if (widget.cat != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemListScreenV1(
                      categoryIds: [widget.cat.termId],
                      locationIds:
                          widget.locationId == -1 ? [] : [widget.locationId],
                    )));
      }
      if (widget.titles != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemDetailScreen(
                  listing: widget.titles.listing,
                )));
      }
    }

    var image = '';
    if (widget.tagsNCats != null) {
      image = widget.tagsNCats.catIcon;
    }
    if (widget.tag != null) {
      image = widget.tag.icon;
    }
    if (widget.cat != null) {
      image = widget.cat.icon;
    }
    if (widget.titles != null) {
      image = widget.titles.listing.featuredImage;
    }
    return InkWell(
      onTap: _onTap,
      child: Container(
        height: 60.0,
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        )),
        padding: EdgeInsets.symmetric(
            vertical: Tools.checkImageType(image) == ImageType.url ? 5.0 : 0.0),
        child: Row(
          children: [
            if (!Tools.checkEmptyString(image)) ...[
              if (Tools.checkImageType(image) == ImageType.url)
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 40.0,
                      height: 40.0,
                      imageUrl: image,
                    ),
                  ),
                ),
              if (Tools.checkImageType(image) == ImageType.asset)
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
              if (Tools.checkImageType(image) == ImageType.base64)
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.memory(
                    base64Decode(Tools.trimBase64Image(image)),
                    fit: BoxFit.cover,
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
            ],
            const SizedBox(width: 10.0),
            if (widget.tagsNCats != null)
              Expanded(
                child: Text(
                  '${widget.tagsNCats.tagName} in ${widget.tagsNCats.catName}',
                  style: theme.textTheme.subtitle2.copyWith(fontSize: 16.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (widget.tag != null)
              Expanded(
                child: Text(
                  widget.tag.name,
                  style: theme.textTheme.subtitle2.copyWith(fontSize: 16.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (widget.titles != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.titles.listing.title,
                    style: theme.textTheme.subtitle2.copyWith(fontSize: 16.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!Tools.checkEmptyString(widget.titles.location)) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      widget.titles.location,
                      style: theme.textTheme.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            if (widget.cat != null)
              Expanded(
                child: Text(
                  widget.cat.name,
                  style: theme.textTheme.subtitle2.copyWith(fontSize: 16.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
