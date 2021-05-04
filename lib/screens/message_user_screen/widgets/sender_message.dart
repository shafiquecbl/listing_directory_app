import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/gallery_showcase.dart';
import '../../../tools/tools.dart';

class SenderMessage extends StatefulWidget {
  final String message;
  final String time;
  final List<dynamic> images;
  const SenderMessage({Key key, this.message, this.time, this.images})
      : super(key: key);
  @override
  _SenderMessageState createState() => _SenderMessageState();
}

class _SenderMessageState extends State<SenderMessage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(
          left: Tools.isDirectionRTL(context) ? 0.0 : 80.0,
          right: Tools.isDirectionRTL(context) ? 80.0 : 0.0,
          bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.images != null && widget.images.isNotEmpty) ...[
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    widget.images.length,
                    (index) => InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
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
            const SizedBox(height: 5.0),
          ],
          if (widget.message.trim().isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.lightBlue.shade500,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.message,
                        style: theme.textTheme.bodyText1.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        widget.time,
                        style: theme.textTheme.caption.copyWith(
                            color: Colors.white,
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
