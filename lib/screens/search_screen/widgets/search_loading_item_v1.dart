import 'package:flutter/material.dart';

import '../../../common_widgets/skeleton.dart';

class SearchLoadingItemV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Skeleton(),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  height: 16.0,
                  width: 100.0,
                ),
                const SizedBox(height: 5.0),
                Skeleton(
                  height: 16.0,
                  width: 50.0,
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
