import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../configs/app_config.dart';
import '../../configs/app_constants.dart';
import '../../models/authentication_model.dart';
import '../../models/discovery_screen_model.dart';
import '../../tools/tools.dart';
import 'widgets/discover_item_v2.dart';
import 'widgets/discover_loading_item_v2.dart';
import 'widgets/map_slider.dart';

class DiscoveryScreenV2 extends StatefulWidget {
  @override
  _DiscoveryScreenV2State createState() => _DiscoveryScreenV2State();
}

class _DiscoveryScreenV2State extends State<DiscoveryScreenV2>
    with
        AutomaticKeepAliveClientMixin<DiscoveryScreenV2>,
        WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mapModel =
          Provider.of<DiscoveryScreenModel>(context, listen: false);
      final locationData =
          Provider.of<AuthenticationModel>(context, listen: false).locationData;
      mapModel.updateDistance(mapModel.distance, locationData);
      var kLake = CameraPosition(
          target: LatLng(locationData.latitude, locationData.longitude),
          zoom: kGoogleMapConfig['zoom']);
      Future.delayed(const Duration(milliseconds: 1000)).then((value) {
        if (mounted) {
          mapModel.controller
              .animateCamera(CameraUpdate.newCameraPosition(kLake));
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final mapModel =
          Provider.of<DiscoveryScreenModel>(context, listen: false);
      mapModel.controller.setMapStyle('[]');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final locationData =
        Provider.of<AuthenticationModel>(context, listen: false).locationData;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Consumer<DiscoveryScreenModel>(
        builder: (context, model, _) => Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (!AppConfig.webPlatform)
                      SafeArea(
                        bottom: false,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: model.kGooglePlex,
                          onMapCreated: model.onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: model.markers,
                          circles: model.circles,
                        ),
                      ),
                    if (AppConfig.webPlatform)
                      const Text(
                          'Google map is not supported on Web Platform!\nPlease test this feature on the App.'),
                    SafeArea(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                List.generate(model.options.length, (index) {
                              String title;
                              switch (model.options[index]) {
                                case Option.open:
                                  title = 'openNow'.tr();
                                  break;
                                case Option.rating:
                                  title = 'mostRating'.tr();
                                  break;
                                case Option.review:
                                  title = 'mostReview'.tr();
                                  break;
                                case Option.view:
                                  title = 'mostViewed'.tr();
                                  break;
                                default:
                                  title = '';
                              }
                              final locationData =
                                  Provider.of<AuthenticationModel>(context,
                                          listen: false)
                                      .locationData;
                              return InkWell(
                                onTap: () =>
                                    model.updateOption(index, locationData),
                                child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      color: model.currentSelectOption ==
                                              model.options[index]
                                          ? Colors.green
                                          : Colors.grey.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      title,
                                      style: theme.textTheme.bodyText2
                                          .copyWith(color: Colors.white),
                                    )),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15.0,
                      left: Tools.isDirectionRTL(context) ? null : -20.0,
                      right: Tools.isDirectionRTL(context) ? -20.0 : null,
                      child: MapSlider(
                        onCallBack: model.updateDistance,
                        distance: model.distance,
                        locationData: locationData,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: model.state == DiscoveryState.loading
                      ? SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                5, (index) => DiscoverLoadingItemV2()),
                          ),
                        )
                      : model.listings.isNotEmpty
                          ? SmartRefresher(
                              controller: model.refreshController,
                              onLoading: () =>
                                  model.loadMoreNearestListings(locationData),
                              enablePullUp: true,
                              onRefresh: () =>
                                  model.getNearestListings(locationData),
                              child: ListView.builder(
                                itemBuilder: (context, index) => DiscoverItemV2(
                                  text: 'Listing',
                                  listing: model.listings[index],
                                  onTap: () => model.goToListing(
                                      listing: model.listings[index]),
                                ),
                                itemCount: model.listings.length,
                              ),
                            )
                          : Center(
                              child: const Text('noData').tr(),
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
