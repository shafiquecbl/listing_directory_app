import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../configs/app_constants.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;

  const Logo({Key key, this.width = 100.0, this.height = 100.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: kLogo,
            width: width,
            height: height,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Mino Paw',
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    );
  }
}
