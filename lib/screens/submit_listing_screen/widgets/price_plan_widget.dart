import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/price_plan.dart';
import '../../../tools/tools.dart';
import 'price_plan_item.dart';

class PricePlanWidget extends StatelessWidget {
  final PricePlan pricePlan;
  final onSelect;
  const PricePlanWidget({Key key, this.pricePlan, this.onSelect})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!Tools.checkEmptyString(
            pricePlan.lpListingproOptions.lpPricePlanBg))
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  pricePlan.lpListingproOptions.lpPricePlanBg,
                ),
              ),
            ),
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pricePlan.planHot != 'false')
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'hot'.tr(),
                        style: theme.textTheme.headline6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  Text(
                    pricePlan.title,
                    style: theme.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    Tools.checkEmptyString(pricePlan.planPrice)
                        ? 'Free'
                        : Tools.convertCurrency(pricePlan.planPrice),
                    style: theme.textTheme.headline3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    pricePlan.planPackageType,
                    style: theme.textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (Tools.checkEmptyString(pricePlan.lpListingproOptions.lpPricePlanBg))
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Color(int.parse(
                    pricePlan.planTitleColor.replaceAll('#', '0xFF')))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pricePlan.planHot != 'false')
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'hot'.tr(),
                      style: theme.textTheme.headline6.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Text(
                  pricePlan.title,
                  style: theme.textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  Tools.checkEmptyString(pricePlan.planPrice)
                      ? 'Free'
                      : Tools.convertCurrency(pricePlan.planPrice),
                  style: theme.textTheme.headline3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  pricePlan.planPackageType,
                  style: theme.textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10.0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pricePlan.planTime.isNotEmpty)
                    PricePlanItem(
                      title: 'duration'.plural(int.parse(pricePlan.planTime)),
                      isCheck: true,
                    ),
                    PricePlanItem(
                      title: 'mapDisplay'.tr(),
                      isCheck: pricePlan.mapShow != 'false',
                    ),
                    PricePlanItem(
                      title: 'contactDisplay'.tr(),
                      isCheck: pricePlan.contactShow != 'false',
                    ),
                    PricePlanItem(
                      title: 'imageGallery'.tr(),
                      isCheck: pricePlan.galleryShow != 'false',
                    ),
                    PricePlanItem(
                      title: 'video'.tr(),
                      isCheck: pricePlan.videoShow != 'false',
                    ),
                    PricePlanItem(
                      title: 'location'.tr(),
                      isCheck: pricePlan.listingprocLocation != 'false',
                    ),
                    PricePlanItem(
                      title: 'website'.tr(),
                      isCheck: pricePlan.listingprocWebsite != 'false',
                    ),
                    PricePlanItem(
                      title: 'socialLinks'.tr(),
                      isCheck: pricePlan.listingprocSocial != 'false',
                    ),
                    PricePlanItem(
                      title: 'faq'.tr(),
                      isCheck: pricePlan.listingprocFaq != 'false',
                    ),
                    PricePlanItem(
                      title: 'priceRange'.tr(),
                      isCheck: pricePlan.listingprocPrice != 'false',
                    ),
                    PricePlanItem(
                      title: 'tagsKeywords'.tr(),
                      isCheck: pricePlan.listingprocTagKey != 'false',
                    ),
                    PricePlanItem(
                      title: 'businessHours'.tr(),
                      isCheck: pricePlan.listingprocBhours != 'false',
                    ),
                    PricePlanItem(
                      title: 'timeKit'.tr(),
                      isCheck: pricePlan.listingprocPlanTimekit != 'false',
                    ),
                    PricePlanItem(
                      title: 'menu'.tr(),
                      isCheck: pricePlan.listingprocPlanMenu != 'false',
                    ),
                    PricePlanItem(
                      title: 'announcement'.tr(),
                      isCheck: pricePlan.listingprocPlanAnnouncment != 'false',
                    ),
                    PricePlanItem(
                      title: 'deals-offers-discounts'.tr(),
                      isCheck: pricePlan.listingprocPlanDeals != 'false',
                    ),
                    PricePlanItem(
                      title: 'hideCompetitorsAds'.tr(),
                      isCheck: pricePlan.lpAdsWihPlan != 'false',
                    ),
                    PricePlanItem(
                      title: 'events'.tr(),
                      isCheck: pricePlan.lpEventsplan != 'false',
                    ),
                    PricePlanItem(
                      title: 'bookings'.tr(),
                      isCheck: pricePlan.listingprocBookings != 'false',
                    ),
                    PricePlanItem(
                      title: 'leadForm'.tr(),
                      isCheck: pricePlan.listingprocLeadform != 'false',
                    ),
                    PricePlanItem(
                      title: 'hideGoogleAds'.tr(),
                      isCheck: pricePlan.lpHidegooglead != 'false',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: theme.accentColor),
            onPressed: onSelect,
            child: Text('chooseThisPlan'.tr()),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
