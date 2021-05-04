import 'package:flutter/material.dart';

import '../../../common_widgets/skeleton.dart';

class SearchLoadingItemV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey,
        ),
      )),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Skeleton(),
          ),
          const SizedBox(width: 5.0),
          Skeleton(
            height: 16.0,
            width: 100.0,
          ),
        ],
      ),
    );
  }
}
