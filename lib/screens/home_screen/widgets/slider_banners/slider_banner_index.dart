import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../banner_widgets/banner_item_index.dart';

class SliderBannerIndex extends StatelessWidget {
  final String version;
  final List<Map<dynamic, dynamic>> list;
  final Map configListingLayout;
  final Map config;

  const SliderBannerIndex(
      {Key key, this.version, this.list, this.configListingLayout, this.config})
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
          list.length,
          (index) => BannerItemIndex(
            item: list[index],
            listing: list[index]['type'] == 'category'
                ? null
                : configListingLayout[list[index]['id']],
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
          list.length,
          (index) => BannerItemIndex(
            item: list[index],
            listing: list[index]['type'] == 'category'
                ? null
                : configListingLayout[list[index]['id']],
          ),
        ),
      );
    }

    /// Default v1
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          list.length,
          (index) => BannerItemIndex(
            item: list[index],
            listing: list[index]['type'] == 'category'
                ? null
                : configListingLayout[list[index]['id']],
          ),
        ),
      ),
    );
  }
}
