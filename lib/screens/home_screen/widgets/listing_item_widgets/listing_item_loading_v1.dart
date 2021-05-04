import 'package:flutter/material.dart';

import '../../../../common_widgets/skeleton.dart';

class ListingLoadingItemV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 75.0,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Skeleton(
            width: 50,
            height: 50,
            cornerRadius: 10.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Skeleton(
                  width: 100,
                  height: 16.0,
                ),
                const SizedBox(height: 5.0),
                Skeleton(
                  width: 100,
                  height: 14.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
