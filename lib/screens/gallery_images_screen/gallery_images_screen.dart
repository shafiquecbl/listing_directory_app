import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GalleryImagesScreen extends StatelessWidget {
  final List<String> images = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: size.width,
        height: size.height,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) =>
              CachedNetworkImage(imageUrl: images[index]),
          itemCount: images.length,
        ),
      ),
    );
  }
}
