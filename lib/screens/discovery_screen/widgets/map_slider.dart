import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../../configs/app_constants.dart';

class MapSlider extends StatefulWidget {
  final Function onCallBack;
  final double distance;
  final LocationData locationData;

  const MapSlider(
      {Key key,
      this.onCallBack,
      @required this.distance,
      @required this.locationData})
      : super(key: key);
  @override
  _MapSliderState createState() => _MapSliderState();
}

class _MapSliderState extends State<MapSlider> {
  bool isUpdating = false;
  double distance;

  @override
  void initState() {
    distance = widget.distance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        isUpdating
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.black87.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  '${distance.toStringAsFixed(2)} km',
                  style:
                      theme.textTheme.subtitle1.copyWith(color: Colors.white),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  ' ',
                  style:
                      theme.textTheme.subtitle1.copyWith(color: Colors.white),
                ),
              ),
        Slider(
          min: kGoogleMapConfig['minRadius'],
          max: kGoogleMapConfig['maxRadius'],
          value: distance,
          activeColor: isUpdating
              ? Colors.blueAccent
              : Colors.blueAccent.withOpacity(0.5),
          onChangeEnd: (value) {
            if (isUpdating) {
              isUpdating = false;
              setState(() {});
              widget.onCallBack(value, widget.locationData);
            }
          },
          onChanged: (value) {
            if (!isUpdating) {
              isUpdating = true;
            }

            distance = value;
            setState(() {});
          },
        ),
      ],
    );
  }
}
