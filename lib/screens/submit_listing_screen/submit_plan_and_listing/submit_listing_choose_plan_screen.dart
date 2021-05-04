import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/skeleton.dart';
import '../widgets/price_plan_widget.dart';
import 'submit_listing_screen_model.dart';

class SubmitListingChoosePlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SubmitListingScreenModel>(
      builder: (_, model, __) {
        if (model.state == SubmitListingState.loadPricePlans) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 1 / 3,
                enlargeCenterPage: true,
              ),
              items: List.generate(
                  3,
                  (index) => SingleChildScrollView(
                        child: Column(
                          children: [
                            Skeleton(
                              width: 350,
                              height: 200,
                              cornerRadius: 15.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    10,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 10.0),
                                          Skeleton(
                                            width: (Random().nextInt(100) + 50)
                                                .toDouble(),
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
            ),
          );
        }

        if (model.pricePlans.isEmpty) {
          return Container();
        }
        return Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1 / 3,
              enlargeCenterPage: true,
            ),
            items: List.generate(
                model.pricePlans.length,
                (index) => PricePlanWidget(
                      pricePlan: model.pricePlans[index],
                      onSelect: () => model
                          .updateSelectedPricePlan(model.pricePlans[index]),
                    )),
          ),
        );
      },
    );
  }
}
