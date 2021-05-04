import 'package:flutter/material.dart';

import '../../../../common_widgets/skeleton.dart';
import '../../../../entities/review.dart';

class ReviewLoadingItemV1 extends StatelessWidget {
  final Review review;

  const ReviewLoadingItemV1({Key key, this.review}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(
                width: 40,
                height: 40,
                cornerRadius: 50.0,
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(
                    width: 100,
                    height: 14,
                  ),
                  const SizedBox(height: 5.0),
                  Skeleton(
                    width: 50,
                    height: 14,
                  ),
                ],
              ),
              const Expanded(child: SizedBox(width: 1.0)),
              Skeleton(
                width: 100,
                height: 14,
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Skeleton(
            width: 100,
            height: 16,
          ),
          const SizedBox(height: 5.0),
          Skeleton(
            width: 200,
            height: 14,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
