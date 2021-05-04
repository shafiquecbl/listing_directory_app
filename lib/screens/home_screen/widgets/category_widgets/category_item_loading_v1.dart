import 'package:flutter/material.dart';

import '../../../../common_widgets/skeleton.dart';

class CategoryItemLoadingV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Skeleton(
          cornerRadius: 20.0,
        ),
      ),
    );
  }
}
