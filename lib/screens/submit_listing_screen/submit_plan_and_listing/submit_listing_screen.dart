import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configs/app_config.dart';
import '../../../models/authentication_model.dart';
import '../../../models/export.dart';
import '../../../tools/tools.dart';
import '../widgets/business_hours.dart';
import '../widgets/faqs.dart';
import '../widgets/feature_image.dart';
import '../widgets/gallery_images.dart';
import '../widgets/listing_input.dart';
import '../widgets/map_pin_drop.dart';
import '../widgets/price_range_widget.dart';
import '../widgets/social_medias.dart';
import '../widgets/submit_category.dart';
import '../widgets/submit_features.dart';
import '../widgets/submit_location.dart';
import 'submit_listing_choose_plan_screen.dart';
import 'submit_listing_screen_model.dart';

class SubmitListingScreen extends StatefulWidget {
  @override
  _SubmitListingScreenState createState() => _SubmitListingScreenState();
}

class _SubmitListingScreenState extends State<SubmitListingScreen> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    final categories =
        Provider.of<ItemListScreenModel>(context, listen: false).categories;
    final features =
        Provider.of<ItemListScreenModel>(context, listen: false).features;
    final locations =
        Provider.of<ItemListScreenModel>(context, listen: false).locations;
    return ChangeNotifierProvider<SubmitListingScreenModel>(
      create: (_) => SubmitListingScreenModel(),
      child: Consumer<SubmitListingScreenModel>(
        builder: (_, model, __) => Stack(
          children: [
            Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: AppBar(
                backgroundColor: theme.backgroundColor,
                brightness: theme.brightness,
                title: Text(
                  'addListing'.tr(),
                  style: theme.textTheme.headline6,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    if (page == 0) {
                      Navigator.pop(context);
                    } else {
                      model.pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                      model.clearEverything();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  icon: AppConfig.webPlatform
                      ? Icon(
                          Icons.arrow_back_ios_sharp,
                          color: theme.iconTheme.color,
                        )
                      : Platform.isIOS
                          ? Icon(
                              Icons.arrow_back_ios_sharp,
                              color: theme.iconTheme.color,
                            )
                          : Icon(
                              Icons.arrow_back,
                              color: theme.iconTheme.color,
                            ),
                ),
              ),
              body: PageView(
                controller: model.pageController,
                onPageChanged: (index) => page = index,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SubmitListingChoosePlanScreen(),
                  if (model.selectedPricePlan != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SubmitFeatureImage(
                              featuredImage: model.businessLogo,
                              onCallBack: (image) =>
                                  model.updateFeatureImage(image),
                            ),
                            if (model.selectedPricePlan.galleryShow != 'false')
                              SubmitGalleryImages(
                                galleryImages: model.galleryImages,
                                maxImages: int.parse(
                                    model.selectedPricePlan?.planNoOfImg ??
                                        '0'),
                                maxSize: int.parse(
                                  model.selectedPricePlan?.planImgLmt ?? '0',
                                ),
                                onCallBack: model.updateGalleryImages,
                                onRemove: model.removeGalleryImage,
                              ),
                            ListingInput(
                              controller: model.titleController,
                              labelText: 'title'.tr(),
                            ),
                            if (model.selectedPricePlan.listingprocTagline !=
                                'false')
                              ListingInput(
                                controller: model.tagLineController,
                                labelText: 'tagLine'.tr(),
                              ),
                            ListingInput(
                              controller: model.addressController,
                              labelText: 'fullAddress'.tr(),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ListingInput(
                                    controller: model.latitudeController,
                                    labelText: 'latitude'.tr(),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: ListingInput(
                                    controller: model.longitudeController,
                                    labelText: 'longitude'.tr(),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: MapPinDrop(
                                latController: model.latitudeController,
                                longController: model.longitudeController,
                                addressUpdateCallBack: (address) =>
                                    model.addressController.text = address,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            if (model.selectedPricePlan.listingprocLocation !=
                                'false')
                              SubmitLocation(
                                locations: locations,
                                onCallBack: model.updateSelectedLocation,
                              ),
                            const SizedBox(height: 10.0),
                            SubmitCategory(
                              categories: categories,
                              onCallBack: model.updateSelectedCategory,
                            ),
                            const SizedBox(height: 10.0),
                            SubmitFeatures(
                              features: features,
                              onCallBack: model.updateSelectedFeatures,
                            ),
                            const SizedBox(height: 10.0),
                            if (model.selectedPricePlan.listingprocSocial !=
                                'false') ...[
                              SocialMedias(
                                socialMedias: model.socialMedias,
                              ),
                              const SizedBox(height: 10.0),
                            ],
                            if (model.selectedPricePlan.listingprocBhours !=
                                'false') ...[
                              BusinessHours(
                                businessHours: model.businessHours,
                              ),
                              const SizedBox(height: 10.0),
                            ],
                            if (model.selectedPricePlan.listingprocFaq !=
                                'false')
                              FAQS(
                                faqs: model.faqs,
                                faqAns: model.faqAns,
                              ),
                            if (model.selectedPricePlan.contactShow != 'false')
                              ListingInput(
                                controller: model.phoneController,
                                labelText: 'phone'.tr(),
                                keyboardType: TextInputType.phone,
                              ),
                            if (model.selectedPricePlan.listingprocWebsite !=
                                'false')
                              ListingInput(
                                controller: model.websiteController,
                                labelText: 'website'.tr(),
                              ),
                            if (model.selectedPricePlan.listingprocPrice !=
                                'false') ...[
                              PriceRangeWidget(
                                priceStatus: model.priceStatus,
                                onCallBack: (val) =>
                                    model.updateSelectedPriceStatus(val),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListingInput(
                                      controller: model.priceFromController,
                                      labelText: 'priceFrom'.tr(),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: ListingInput(
                                      controller: model.priceToController,
                                      labelText: 'priceTo'.tr(),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (model.selectedPricePlan.listingprocTagKey !=
                                'false')
                              ListingInput(
                                controller: model.tagsController,
                                labelText: 'tags'.tr(),
                                hintText: 'separatedByComma'.tr(),
                              ),
                            ListingInput(
                              controller: model.descriptionController,
                              labelText: 'description'.tr(),
                              multiLine: true,
                            ),
                            InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                var error = model.isNotEnoughForSubmit();
                                if (error == 1) {
                                  showToast('titleIsRequired'.tr());
                                  return;
                                }
                                if (error == 2) {
                                  showToast('descriptionIsRequired'.tr());
                                  return;
                                }
                                if (error == 3) {
                                  showToast('mustSelectACategory'.tr());
                                  return;
                                }
                                var res = await model.submitListing(user);
                                if (res == 1) {
                                  showToast('successfullySubmitted'.tr());
                                  Navigator.of(context).pop();
                                } else {
                                  showToast('addListingFailed'.tr());
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: theme.accentColor,
                                ),
                                width: size.width,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'saveAndPreview'.tr(),
                                    style: theme.textTheme.subtitle1.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (model.state == SubmitListingState.loading)
              Container(
                width: size.width,
                height: size.height,
                color: Colors.grey.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
