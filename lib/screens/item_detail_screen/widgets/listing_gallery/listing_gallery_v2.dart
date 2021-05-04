import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ListingGalleryV2 extends StatelessWidget {
  final List<String> images;

  const ListingGalleryV2({Key key, this.images}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.cover,
        );
      },
      itemCount: images.length,
      pagination: const SwiperPagination(),
      control: const SwiperControl(),
    );
  }
}
