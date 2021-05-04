import 'package:flutter/material.dart';

import '../../../common_widgets/skeleton.dart';

class DiscoverLoadingItemV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
      child: Skeleton(
        width: size.width,
        height: 100.0,
        cornerRadius: 10.0,
      ),
    );
  }
}
