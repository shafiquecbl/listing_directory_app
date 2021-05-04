import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/discovery_screen_model.dart';
import 'widgets/discover_item_v1.dart';

class DiscoveryScreenV1 extends StatefulWidget {
  @override
  _DiscoveryScreenV1State createState() => _DiscoveryScreenV1State();
}

class _DiscoveryScreenV1State extends State<DiscoveryScreenV1>
    with AutomaticKeepAliveClientMixin<DiscoveryScreenV1> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<DiscoveryScreenModel>(
        builder: (context, model, _) => Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: model.kGooglePlex,
                onMapCreated: model.onMapCreated,
                myLocationEnabled: true,
                markers: model.markers,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          30,
                          (index) => DiscoverItemV1(
                                text: 'Listing',
                                onTap: model.goToListing,
                              )),
                    )),
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
