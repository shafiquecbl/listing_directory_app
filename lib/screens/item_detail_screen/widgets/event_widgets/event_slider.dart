import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../entities/event.dart';
import 'event_item_v1.dart';

class EventSlider extends StatefulWidget {
  final List<Event> events;

  const EventSlider({Key key, this.events}) : super(key: key);

  @override
  _EventSliderState createState() => _EventSliderState();
}

class _EventSliderState extends State<EventSlider> {
  int _currentIndex = 0;

  Widget _buildCustomIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.events.length,
        (index) => Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Icon(
            Icons.album_outlined,
            color: _currentIndex == index
                ? Theme.of(context).accentColor
                : Theme.of(context).disabledColor,
            size: 10.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            options: CarouselOptions(
                height: 210.0,
                viewportFraction: 0.95,
                aspectRatio: 2.0,
                onPageChanged: (index, _) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
            items: List.generate(
                widget.events.length,
                (index) => EventItemV1(
                      event: widget.events[index],
                    ))),
        const SizedBox(height: 10.0),
        _buildCustomIndicators(),
      ],
    );
  }
}
