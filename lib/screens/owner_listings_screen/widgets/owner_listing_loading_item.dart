import 'package:flutter/material.dart';

import '../../../common_widgets/skeleton.dart';

class OwnerListingLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Skeleton(
              cornerRadius: 10.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  width: 150,
                  height: 20.0,
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Skeleton(
                      width: 60.0,
                      height: 16.0,
                    ),
                    const Expanded(child: SizedBox(width: 1)),
                    Skeleton(
                      width: 60.0,
                      height: 25.0,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
