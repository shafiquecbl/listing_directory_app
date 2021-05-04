import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GalleryShowCase extends StatefulWidget {
  final int position;
  final List<Asset> assets;
  final List<dynamic> images;

  const GalleryShowCase({Key key, this.position, this.assets, this.images})
      : super(key: key);

  @override
  _GalleryShowCaseState createState() => _GalleryShowCaseState();
}

class _GalleryShowCaseState extends State<GalleryShowCase> {
  var _pageViewController;

  @override
  void initState() {
    _pageViewController = PageController(initialPage: widget.position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: theme.backgroundColor,
      ),
      body: Column(
        children: [
          if (widget.assets != null && widget.assets.isNotEmpty)
            Expanded(
              child: PageView(
                controller: _pageViewController,
                children: List.generate(
                    widget.assets.length,
                    (index) => AssetThumb(
                          asset: widget.assets[index],
                          width: size.width.toInt(),
                          height: size.height.toInt(),
                        )),
              ),
            ),
          if (widget.images != null && widget.images.isNotEmpty)
            Expanded(
              child: PageView(
                  controller: _pageViewController,
                  children: List.generate(
                    widget.images.length,
                    (index) => CachedNetworkImage(
                      imageUrl: widget.images[index],
                    ),
                  )),
            ),
        ],
      ),
    );
  }
}
