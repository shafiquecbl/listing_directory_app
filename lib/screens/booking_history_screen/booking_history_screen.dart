import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common_widgets/skeleton.dart';
import '../../models/authentication_model.dart';
import 'booking_history_screen_model.dart';

class BookingHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId =
        Provider.of<AuthenticationModel>(context, listen: false).user.id;
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => BookingHistoryScreenModel(userId),
      child: Scaffold(
        appBar: AppBar(
          brightness: theme.brightness,
          backgroundColor: theme.backgroundColor,
          title: Text(
            'bookingHistory'.tr(),
            style: theme.textTheme.headline6,
          ),
          centerTitle: true,
          iconTheme: theme.iconTheme,
        ),
        backgroundColor: theme.backgroundColor,
        body: Consumer<BookingHistoryScreenModel>(
          builder: (_, model, __) {
            if (model.state == BookingHistoryState.loading) {
              return SingleChildScrollView(
                  child: Column(
                children: List.generate(
                    5,
                    (index) => Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: Skeleton(
                            width: size.width,
                            height: 80.0,
                          ),
                        )),
              ));
            }
            if (model.bookings.isEmpty) {
              return SmartRefresher(
                controller: model.refreshController,
                onRefresh: () => model.getBookings(userId),
                child: Center(
                  child: Text('noData'.tr()),
                ),
              );
            }
            return SmartRefresher(
              controller: model.refreshController,
              enablePullUp: true,
              onLoading: () => model.loadMoreBookings(userId),
              onRefresh: () => model.getBookings(userId),
              child: ListView.builder(
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.splashColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: model.bookings[index].featuredImage,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              model.bookings[index].title,
                              style: theme.textTheme.headline6,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.mobile,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  model.bookings[index].phone,
                                  style: theme.textTheme.bodyText1,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.history,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  model.bookings[index].status,
                                  style: theme.textTheme.bodyText1,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 16.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  model.bookings[index].email,
                                  style: theme.textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: model.bookings.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
