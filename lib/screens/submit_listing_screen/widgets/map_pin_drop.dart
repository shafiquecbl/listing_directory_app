import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common_widgets/common_input.dart';
import '../../../configs/app_config.dart';
import '../../../configs/app_constants.dart';
import '../../../entities/prediction.dart';
import '../../../models/authentication_model.dart';
import '../../../services/api_service.dart';

class MapPinDrop extends StatefulWidget {
  final TextEditingController latController;
  final TextEditingController longController;
  final addressUpdateCallBack;
  const MapPinDrop(
      {Key key,
      this.latController,
      this.longController,
      this.addressUpdateCallBack})
      : super(key: key);
  @override
  _MapPinDropState createState() => _MapPinDropState();
}

class _MapPinDropState extends State<MapPinDrop> {
  GoogleMapController controller;
  Set<Marker> markers = {};
  List<Prediction> autocompletePlaces = [];
  final TextEditingController addressController = TextEditingController();
  final _services = ApiServices();
  var uuid;
  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(
        kGoogleMapConfig['initLatitude'], kGoogleMapConfig['initLongitude']),
    zoom: kGoogleMapConfig['zoom'],
  );

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void _updateLocation(double latitude, double longitude) {
    widget.latController.text = latitude.toString();
    widget.longController.text = longitude.toString();
    markers.clear();
    markers.add(
      Marker(
        infoWindow: const InfoWindow(title: 'Your address'),
        markerId: MarkerId(
          'map-pin-drop-$latitude,$longitude',
        ),
        position: LatLng(
          latitude,
          longitude,
        ),
      ),
    );

    setState(() {});
  }

  void _moveToMyLocation() {
    final userLocation =
        Provider.of<AuthenticationModel>(context, listen: false).locationData;
    var kLake = CameraPosition(
        target: LatLng(userLocation.latitude, userLocation.longitude),
        zoom: kGoogleMapConfig['zoom']);
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  void _getAutocompletePlaces() {
    EasyDebounce.cancel('getAutocompletePlaces');
    EasyDebounce.debounce(
        'getAutocompletePlaces', const Duration(milliseconds: 300), () async {
      if (addressController.text != '') {
        autocompletePlaces =
            await _services.getAutoCompletePlaces(addressController.text, uuid);
        setState(() {});
      }
    });
  }

  Future<void> _onSelectAddress(int index) async {
    FocusScope.of(context).unfocus();
    if (autocompletePlaces.isEmpty) {
      return;
    }
    final prediction = autocompletePlaces[index];
    autocompletePlaces.clear();
    addressController.text = prediction.description;
    final _prediction = await _services.getPlaceDetail(prediction, uuid);
    widget.addressUpdateCallBack(_prediction.description);
    uuid = Uuid().v4();
    _updateLocation(
        double.parse(_prediction.lat), double.parse(_prediction.long));
    var kLake = CameraPosition(
        target: LatLng(
            double.parse(_prediction.lat), double.parse(_prediction.long)),
        zoom: kGoogleMapConfig['zoom']);
    await controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
  }

  @override
  void initState() {
    uuid = Uuid().v4();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.longController.text.isNotEmpty &&
          widget.latController.text.isNotEmpty) {
        _updateLocation(double.parse(widget.latController.text.trim()),
            double.parse(widget.longController.text.trim()));
        var kLake = CameraPosition(
            target: LatLng(double.parse(widget.latController.text.trim()),
                double.parse(widget.longController.text.trim())),
            zoom: kGoogleMapConfig['zoom']);
        Future.delayed(const Duration(seconds: 2)).then((value) {
          controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    if (AppConfig.webPlatform) {
      return Container(
        height: 300.0,
        color: Colors.grey,
        child: const Center(
          child: Text(
              'Google Map is not supported on Web Platform!\nPlease test this feature on the App.'),
        ),
      );
    }
    return Container(
      height: 300.0,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (latLng) =>
                _updateLocation(latLng.latitude, latLng.longitude),
            markers: markers,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonInput(
                          controller: addressController,
                          hintText: 'searchALocation'.tr(),
                          onChanged: (val) => _getAutocompletePlaces(),
                          onSubmitted: (val) => _onSelectAddress(0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          addressController.clear();
                          autocompletePlaces.clear();
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.cardColor.withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.clear,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (autocompletePlaces.isNotEmpty) ...[
                    const SizedBox(height: 10.0),
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          autocompletePlaces.length,
                          (index) => InkWell(
                              onTap: () => _onSelectAddress(index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded),
                                    Expanded(
                                      child: Text(
                                        autocompletePlaces[index].description,
                                        style: theme.textTheme.bodyText2,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: InkWell(
              onTap: _moveToMyLocation,
              child: Container(
                width: 35.0,
                height: 35.0,
                margin: const EdgeInsets.all(10.0),
                color: Colors.white,
                child: const Center(
                  child: Icon(
                    Icons.my_location,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
