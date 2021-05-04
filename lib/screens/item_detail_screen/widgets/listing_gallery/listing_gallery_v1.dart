import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/gallery_showcase.dart';
import '../../../../configs/app_constants.dart';

class ListingGalleryV1 extends StatefulWidget {
  final List<String> images;

  const ListingGalleryV1({Key key, this.images}) : super(key: key);

  @override
  _ListingGalleryV1State createState() => _ListingGalleryV1State();
}

class _ListingGalleryV1State extends State<ListingGalleryV1> {
  int currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.images.isNotEmpty)
          PageView(
            children: List.generate(
                widget.images.length,
                (index) => InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GalleryShowCase(
                            position: index,
                            images: widget.images,
                          ),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                      ),
                    )),
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            controller: _pageController,
          ),
        if (widget.images.isEmpty) CachedNetworkImage(imageUrl: kDefaultImage),
        Align(
          alignment: Alignment.bottomLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                  widget.images.length,
                  (index) => InkWell(
                        onTap: () {
                          currentIndex = index;
                          _pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                          setState(() {});
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: currentIndex == index
                                      ? Colors.red
                                      : Colors.grey),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }
}
