import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common_widgets/skeleton.dart';

class ListingLoadingItemV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Skeleton(
        width: 150,
        height: 160,
      ),
    );
  }
}
