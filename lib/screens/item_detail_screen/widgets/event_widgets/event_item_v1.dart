import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../configs/app_constants.dart';
import '../../../../entities/event.dart';
import '../../../../tools/tools.dart';

class EventItemV1 extends StatelessWidget {
  final Event event;

  const EventItemV1({Key key, this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    void _openTicketLink() async {
      final url = event.eventTicketUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      width: size.width,
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 210,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: theme.cardColor,
                      spreadRadius: 5.0,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 3.0)),
                ],
              ),
              child: Row(
                children: [
                  AspectRatio(aspectRatio: 3 / 4, child: Container()),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        Text(
                          event.eventTitle,
                          maxLines: 2,
                          style: theme.textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'eventDate'.tr(args: [event.eventDate]),
                          maxLines: 2,
                          style: theme.textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'eventTime'.tr(args: [event.eventTime]),
                          maxLines: 2,
                          style: theme.textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'eventLoc'.tr(args: [event.eventLoc]),
                          maxLines: 2,
                          style: theme.textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Expanded(child: SizedBox(height: 10.0)),
                        Align(
                          alignment: Tools.isDirectionRTL(context)
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: _openTicketLink,
                            child: const Text('buyTicket').tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 1.0),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: event.eventFeaturedImage ?? kDefaultImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
