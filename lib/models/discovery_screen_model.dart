import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../configs/app_constants.dart';
import '../entities/listing.dart';
import '../services/api_service.dart';

enum Option {
  open,
  view,
  rating,
  review,
}

enum DiscoveryState { init, loading, loaded, loadMore }

class DiscoveryScreenModel extends ChangeNotifier {
  final _services = ApiServices();
  List<Listing> listings = [];
  GoogleMapController controller;
  Set<Marker> markers = {};
  final RefreshController refreshController = RefreshController();
  int _page = 1;
  final int _perPage = 10;
  Option currentSelectOption = Option.review;
  double distance = kGoogleMapConfig['initRadius'];
  Set<Circle> circles;
  var state = DiscoveryState.init;
  List<Option> options = [
    Option.view,
    Option.review,
    Option.rating,
    Option.open
  ];

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  void updateDistance(double distance, LocationData locationData) {
    this.distance = distance.roundToDouble();
    circles = {
      Circle(
          circleId: CircleId('radius-map'),
          center: LatLng(locationData.latitude, locationData.longitude),
          radius: distance * 1000,
          strokeColor: Colors.blueAccent,
          strokeWidth: 1,
          fillColor: Colors.blueAccent.withOpacity(0.5))
    };
    EasyDebounce.cancel('getNearestListings');
    EasyDebounce.debounce(
        'getNearestListings', const Duration(milliseconds: 200), () {
      getNearestListings(locationData);
    });
  }

  void updateOption(int index, LocationData locationData) {
    if (currentSelectOption != options[index]) {
      currentSelectOption = options[index];
      _updateState(DiscoveryState.loaded);
      getNearestListings(locationData);
    }
  }

  String _convertOption() {
    switch (currentSelectOption) {
      case Option.open:
        return 'open';
      case Option.review:
        return 'review';
      case Option.rating:
        return 'rating';
      case Option.view:
        return 'view';
    }
    return 'review';
  }

  void getNearestListings(LocationData locationData) async {
    if (state == DiscoveryState.loadMore || state == DiscoveryState.loading) {
      return;
    }

    _updateState(DiscoveryState.loading);
    _page = 1;
    markers.clear();
    listings.clear();
    listings = await _services.getAdListings(perPage: 1, adType: 'topofsearch');
    var list = await _services.getNearestListing(
        long: locationData.longitude,
        lat: locationData.latitude,
        page: _page,
        perPage: _perPage,
        option: _convertOption(),
        distance: distance);

    for (var item in list) {
      var tmp = listings.where((element) => element.id == item.id);

      if (tmp.isEmpty) {
        listings.add(item);
      }
    }
    for (var listing in listings) {
      markers.add(
        Marker(
          infoWindow: InfoWindow(title: listing.title),
          markerId: MarkerId(
            'map-${listing.id.toString()}',
          ),
          position: LatLng(
            listing.lpListingproOptions.latitude,
            listing.lpListingproOptions.longitude,
          ),
        ),
      );
    }
    refreshController.loadComplete();
    refreshController.refreshCompleted();
    _updateState(DiscoveryState.loaded);
  }

  void loadMoreNearestListings(LocationData locationData) async {
    if (state == DiscoveryState.loadMore || state == DiscoveryState.loading) {
      return;
    }
    _updateState(DiscoveryState.loadMore);
    _page++;
    var list = <Listing>[];
    list = await _services.getNearestListing(
      long: locationData.longitude,
      lat: locationData.latitude,
      perPage: _perPage,
      page: _page,
      option: _convertOption(),
      distance: distance,
    );
    if (list.isEmpty) {
      refreshController.loadNoData();
      _updateState(DiscoveryState.loaded);
      return;
    }
    for (var item in list) {
      var tmp = listings.where((element) => element.id == item.id);
      if (tmp.isEmpty) {
        listings.add(item);
      }
    }
    for (var listing in listings) {
      markers.add(Marker(
          markerId: MarkerId(
            'map-${listing.id.toString()}',
          ),
          position: LatLng(listing.lpListingproOptions.latitude,
              listing.lpListingproOptions.longitude)));
    }
    refreshController.loadComplete();
    _updateState(DiscoveryState.loaded);
  }

  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(
        kGoogleMapConfig['initLatitude'], kGoogleMapConfig['initLongitude']),
    zoom: kGoogleMapConfig['zoom'],
  );

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  Future<void> goToListing({Listing listing}) async {
    var kLake = CameraPosition(
        target: LatLng(listing.lpListingproOptions.latitude,
            listing.lpListingproOptions.longitude),
        zoom: kGoogleMapConfig['zoom']);
    await controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }
}
