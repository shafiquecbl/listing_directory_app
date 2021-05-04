import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/location.dart';

class SubmitLocation extends StatefulWidget {
  final List<Location> locations;
  final int selectedLocation;
  final onCallBack;

  const SubmitLocation(
      {Key key, this.locations, this.onCallBack, this.selectedLocation})
      : super(key: key);
  @override
  _SubmitLocationState createState() => _SubmitLocationState();
}

class _SubmitLocationState extends State<SubmitLocation> {
  int currentIndex = -1;
  bool _isOpen = false;

  @override
  void initState() {
    if (widget.selectedLocation != null) {
      currentIndex = widget.locations
          .indexWhere((element) => element.id == widget.selectedLocation);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                Text(
                  'location'.tr(),
                  style: theme.textTheme.headline6
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                _isOpen
                    ? const Icon(Icons.arrow_drop_down)
                    : const SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(Icons.arrow_right),
                      )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        if (_isOpen)
          Wrap(
            direction: Axis.horizontal,
            children: List.generate(
                widget.locations.length,
                (index) => InkWell(
                      onTap: () {
                        if (currentIndex == index) {
                          currentIndex = -1;
                        } else {
                          currentIndex = index;
                        }
                        setState(() {});
                        widget.onCallBack(widget.locations[index].id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: index == currentIndex
                                ? theme.accentColor
                                : Colors.grey),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Text(
                          widget.locations[index].name,
                          style: theme.textTheme.subtitle1
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )),
          ),
      ],
    );
  }
}
