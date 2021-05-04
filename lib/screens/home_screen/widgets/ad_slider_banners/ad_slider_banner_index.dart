import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../entities/listing.dart';
import '../banner_widgets/banner_item_index.dart';

class AdSliderBannerIndex extends StatelessWidget {
  final String version;
  final List<Listing> list;
  final Map config;

  const AdSliderBannerIndex(
      {Key key, @required this.version, @required this.list, this.config})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (version == 'v3') {
      return CarouselSlider(
        options: CarouselOptions(
          autoPlay: config['autoPlay'] ?? true,
          autoPlayInterval: Duration(seconds: config['interval'] ?? 3),
          aspectRatio: 16 / 7,
          enlargeCenterPage: true,
        ),
        items: List.generate(
          list?.length ?? 0,
          (index) => BannerItemIndex(
            listing: list[index],
          ),
        ),
      );
    }
    if (version == 'v2') {
      return CarouselSlider(
        options: CarouselOptions(
          autoPlay: config['autoPlay'] ?? true,
          autoPlayInterval: Duration(seconds: config['interval'] ?? 3),
        ),
        items: List.generate(
          list?.length ?? 0,
          (index) => BannerItemIndex(
            listing: list[index],
          ),
        ),
      );
    }

    /// Default v1
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          list?.length ?? 0,
          (index) => BannerItemIndex(
            listing: list[index],
          ),
        ),
      ),
    );
  }
}
