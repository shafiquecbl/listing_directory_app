import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/gallery_showcase.dart';
import '../../../configs/app_constants.dart';
import '../../../tools/tools.dart';

class ReceiverMessage extends StatefulWidget {
  final String message;
  final String receiverAvatar;
  final String time;
  final List<dynamic> images;
  const ReceiverMessage(
      {Key key, this.message, this.receiverAvatar, this.time, this.images})
      : super(key: key);
  @override
  _ReceiverMessageState createState() => _ReceiverMessageState();
}

class _ReceiverMessageState extends State<ReceiverMessage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(
          right: Tools.isDirectionRTL(context) ? 0 : 80.0,
          left: Tools.isDirectionRTL(context) ? 80.0 : 0,
          bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.images != null && widget.images.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      widget.images.length,
                      (index) => InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => GalleryShowCase(
                                      position: index,
                                      images: widget.images,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.images[index],
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
            const SizedBox(height: 5.0),
          ],
          if (widget.message.trim().isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.receiverAvatar ?? kDefaultImage,
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message,
                        style: theme.textTheme.bodyText1.copyWith(
                            color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.time,
                        style: theme.textTheme.caption.copyWith(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
