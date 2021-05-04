import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common_widgets/skeleton.dart';

class WishListLoadingItemV1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 80.0,
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Skeleton(
                    cornerRadius: 10.0,
                  ),
                  Center(
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      size: 20.0,
                      color: theme.accentColor,
                    ),
                  ),
                ],
              )),
          const SizedBox(width: 10.0),
          Expanded(
            child: Skeleton(
              height: 20.0,
              width: 100.0,
            ),
          ),
        ],
      ),
    );
  }
}
