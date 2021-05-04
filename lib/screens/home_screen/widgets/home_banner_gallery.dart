import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../configs/app_constants.dart';

class HomeBannerGallery extends StatefulWidget {
  final List<dynamic> imageGallery;
  final double expandedHeight;

  const HomeBannerGallery({Key key, this.imageGallery, this.expandedHeight})
      : super(key: key);
  @override
  _HomeBannerGalleryState createState() => _HomeBannerGalleryState();
}

class _HomeBannerGalleryState extends State<HomeBannerGallery> {
  int currentIndex = 0;

  void autoPlayBanner() {
    if (widget.imageGallery.length <= 1) {
      return;
    }
    Future.delayed(const Duration(seconds: 10)).then((value) {
      setState(() {});
      currentIndex++;
      if (currentIndex == widget.imageGallery.length) {
        currentIndex = 0;
      }
      autoPlayBanner();
    });
  }

  @override
  void initState() {
    super.initState();
    autoPlayBanner();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageGallery.isEmpty) {
      return CachedNetworkImage(
        imageUrl: kDefaultImage,
        fit: BoxFit.cover,
        height: widget.expandedHeight,
        width: MediaQuery.of(context).size.width,
      );
    }
    if (widget.imageGallery.length <= 1) {
      return CachedNetworkImage(
        imageUrl: widget.imageGallery[currentIndex],
        fit: BoxFit.cover,
        height: widget.expandedHeight,
        width: MediaQuery.of(context).size.width,
      );
    }
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.imageGallery[currentIndex],
          fit: BoxFit.cover,
          height: widget.expandedHeight,
          width: MediaQuery.of(context).size.width,
        ),
        CachedNetworkImage(
          imageUrl: (currentIndex + 1) == widget.imageGallery.length
              ? widget.imageGallery[0]
              : widget.imageGallery[currentIndex + 1],
          fit: BoxFit.cover,
          height: widget.expandedHeight,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }
}
