import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../entities/listing.dart';
import '../../../entities/price_plan.dart';
import '../../../entities/user.dart';
import '../../../services/api_service.dart';
import '../../../tools/tools.dart';

enum EditListingState { loading, loaded, loadPricePlans }

class EditListingScreenModel extends ChangeNotifier {
  final _services = ApiServices();
  var state = EditListingState.loaded;
  final PageController pageController = PageController();
  var prototypeSocialMedia = [
    {
      'displayName': 'Instagram',
      'name': 'instagram',
      'value': TextEditingController()
    },
    {
      'displayName': 'YouTube',
      'name': 'youtube',
      'value': TextEditingController()
    },
    {
      'displayName': 'Twitter',
      'name': 'twitter',
      'value': TextEditingController()
    },
    {
      'displayName': 'Facebook',
      'name': 'facebook',
      'value': TextEditingController()
    },
    {
      'displayName': 'LinkedIn',
      'name': 'linkedin',
      'value': TextEditingController()
    },
    {
      'displayName': 'WhatsApp',
      'name': 'whatsapp',
      'value': TextEditingController()
    },
  ];

  var prototypeBusinessHours = [
    {
      'day': 'Monday',
      'nextDay': 'Tuesday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Monday',
      '2ndSlotNextDay': 'Tuesday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Tuesday',
      'nextDay': 'Wednesday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Tuesday',
      '2ndSlotNextDay': 'Wednesday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Wednesday',
      'nextDay': 'Thursday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Wednesday',
      '2ndSlotNextDay': 'Thursday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Thursday',
      'nextDay': 'Friday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Thursday',
      '2ndSlotNextDay': 'Friday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Friday',
      'nextDay': 'Saturday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Friday',
      '2ndSlotNextDay': 'Saturday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Saturday',
      'nextDay': 'Sunday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Saturday',
      '2ndSlotNextDay': 'Sunday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
    {
      'day': 'Sunday',
      'nextDay': 'Monday',
      'open': '09:00am',
      'close': '05:00pm',
      '24hours': false,
      'enable': false,
      '2ndSlot': false,
      '2ndSlotDay': 'Sunday',
      '2ndSlotNextDay': 'Monday',
      '2ndSlotOpen': '09:00am',
      '2ndSlotClose': '05:00pm',
    },
  ];

  /// Attributes for listing submit
  int selectedCategory;
  int selectedLocation;
  List<int> selectedFeatures = [];
  List<Map<String, dynamic>> socialMedias = [];
  List<TextEditingController> faqs = [];
  List<TextEditingController> faqAns = [];
  List<dynamic> galleryImages = [];
  List<dynamic> businessLogo = [];
  String priceStatus = 'notsay';
  PricePlan selectedPricePlan;
  List<Map<dynamic, dynamic>> businessHours = [];
  final Listing listing;
  EditListingScreenModel(this.listing) {
    initControllers();
  }

  /// Add this later

  /// text controllers for listing submit
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagLineController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController priceFromController = TextEditingController();
  final TextEditingController priceToController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  void initControllers() {
    selectedPricePlan = listing.pricePlan;
    titleController.text = listing.title;
    tagLineController.text = listing.lpListingproOptions.taglineText;
    addressController.text = listing.lpListingproOptions.gAddress;
    latitudeController.text =
        listing.lpListingproOptions?.latitude?.toString() ?? '';
    longitudeController.text =
        listing.lpListingproOptions?.longitude?.toString() ?? '';
    phoneController.text = listing.lpListingproOptions.phone;
    websiteController.text = listing.lpListingproOptions.website;
    priceFromController.text = listing.lpListingproOptions?.listPrice ?? '';
    priceToController.text = listing.lpListingproOptions?.listPriceTo ?? '';
    descriptionController.text = listing.content;
    // tagsController.text = listing.lpListingproOption

    if (listing?.pureTaxonomies?.features != null &&
        listing.pureTaxonomies.features.isNotEmpty) {
      listing.pureTaxonomies.features.forEach((element) {
        selectedFeatures.add(element.termId);
      });
    }
    if (listing?.pureTaxonomies?.tags != null &&
        listing.pureTaxonomies.tags.isNotEmpty) {
      var tags = '';
      listing.pureTaxonomies.tags.forEach((element) {
        tags += '${element.name},';
      });
      tagsController.text = tags;
    }

    if (listing?.pureTaxonomies?.location != null &&
        listing.pureTaxonomies.location.isNotEmpty) {
      selectedLocation = listing.pureTaxonomies.location.first.termId;
    }
    if (listing?.pureTaxonomies?.listingCategory != null &&
        listing.pureTaxonomies.listingCategory.isNotEmpty) {
      selectedCategory = listing.pureTaxonomies.listingCategory.first.termId;
    }
    businessLogo.add(listing.featuredImage);
    galleryImages.addAll(listing.galleryImages);
    if (galleryImages.isNotEmpty && galleryImages.first == businessLogo.first) {
      galleryImages.remove(listing.featuredImage);
    }

    businessHours.addAll(prototypeBusinessHours);

    businessHours.forEach((bh) {
      listing.lpListingproOptions.businessHours.forEach((lbh) {
        if (bh['day'] == lbh.day) {
          bh['enable'] = true;
          if (lbh.openTime.first.contains('24')) {
            bh['24hours'] = true;
          } else {
            if (lbh.openTime.length == 2 && lbh.closeTime.length == 2) {
              bh['open'] = lbh.openTime[0];
              bh['close'] = lbh.closeTime[0];
              bh['2ndSlot'] = true;
              bh['2ndSlotOpen'] = lbh.openTime[1];
              bh['2ndSlotClose'] = lbh.closeTime[1];
            } else {
              bh['open'] = lbh.openTime.first;
              bh['close'] = lbh.closeTime.first;
            }
          }
        }
      });
    });

    if (listing.lpListingproOptions.faqs != null &&
        listing.lpListingproOptions.faqs != null) {
      if (listing.lpListingproOptions.faqs.faq.isNotEmpty &&
          listing.lpListingproOptions.faqs.faqans.isNotEmpty) {
        listing.lpListingproOptions.faqs.faq.forEach((element) {
          final _controller = TextEditingController();
          _controller.text = element;
          faqs.add(_controller);
        });
        listing.lpListingproOptions.faqs.faqans.forEach((element) {
          final _controller = TextEditingController();
          _controller.text = element;
          faqAns.add(_controller);
        });
      }
    }

    socialMedias.addAll(prototypeSocialMedia);
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'instagram')]['value']
        .text = listing.lpListingproOptions.instagram;
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'youtube')]['value']
        .text = listing.lpListingproOptions.youtube;
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'twitter')]['value']
        .text = listing.lpListingproOptions.twitter;
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'facebook')]['value']
        .text = listing.lpListingproOptions.facebook;
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'linkedin')]['value']
        .text = listing.lpListingproOptions.linkedin;
    socialMedias[socialMedias
            .indexWhere((element) => element['name'] == 'whatsapp')]['value']
        .text = listing.lpListingproOptions.whatsapp;

    priceStatus = listing.lpListingproOptions.priceStatus;

    _updateState(EditListingState.loaded);
  }

  void clearEverything() {
    titleController.clear();
    tagLineController.clear();
    addressController.clear();
    latitudeController.clear();
    longitudeController.clear();
    phoneController.clear();
    websiteController.clear();
    priceFromController.clear();
    priceToController.clear();
    descriptionController.clear();
    tagsController.clear();
    galleryImages.clear();
    businessLogo.clear();
    selectedCategory = null;
    selectedLocation = null;
    faqs.clear();
    faqAns.clear();
    selectedFeatures.clear();
    businessHours.clear();
    businessHours.addAll(prototypeBusinessHours);
    socialMedias.clear();
    socialMedias.addAll(prototypeSocialMedia);
  }

  void updateSelectedPricePlan(PricePlan pricePlan) {
    selectedPricePlan = pricePlan;
    _updateState(EditListingState.loaded);
    pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void updateSelectedCategory(int categoryId) {
    selectedCategory = categoryId;
    if (selectedCategory == -1) {
      selectedCategory = null;
    }
  }

  void updateFeatureImage(List<Asset> image) {
    businessLogo = image;
  }

  void updateGalleryImages(List<dynamic> galleryImages) {
    this.galleryImages.addAll(galleryImages);
  }

  void updateSelectedPriceStatus(String status) {
    priceStatus = status;
  }

  void updateSelectedLocation(int locationId) {
    selectedLocation = locationId;
    if (selectedLocation == -1) {
      selectedLocation = null;
    }
  }

  void updateSelectedFeatures(int featureId) {
    if (selectedFeatures.contains(featureId)) {
      selectedFeatures.remove(featureId);
    } else {
      selectedFeatures.add(featureId);
    }
  }

  int isNotEnoughForSubmit() {
    if (titleController.text.trim().isEmpty) {
      return 1;
    }

    if (descriptionController.text.trim().isEmpty) {
      return 2;
    }
    if (selectedCategory == null) {
      return 3;
    }
    return 0;
  }

  void removeGalleryImage(int index) {
    galleryImages.removeAt(index);
  }

  Future<int> submitListing(User user) async {
    _updateState(EditListingState.loading);
    var businessHoursData = {};
    businessHours.forEach((element) {
      if (element['enable']) {
        if (element['24hours']) {
          businessHoursData[element['day']] = {'open': '', 'close': ''};
        } else {
          if (element['2ndSlot']) {
            /// Time Slot 1
            var result = Tools.isCloseTimeGreaterThanOpenTime(
                element['open'], element['close']);
            var day = '';
            switch (result) {
              case 0:
              case 2:
                day = element['day'];
                break;
              case 1:
                day = '${element['day']}~${element['nextDay']}';
                break;
            }

            /// Time Slot 2
            var result2 = Tools.isCloseTimeGreaterThanOpenTime(
                element['2ndSlotOpen'], element['2ndSlotClose']);
            var secondDay = '';
            switch (result2) {
              case 0:
              case 2:
                secondDay = element['2ndSlotDay'];
                break;
              case 1:
                secondDay =
                    '${element['2ndSlotDay']}~${element['2ndSlotNextDay']}';
                break;
            }

            if (day == secondDay) {
              businessHoursData[day] = {
                'open': [element['open'], element['2ndSlotOpen']],
                'close': [element['close'], element['2ndSlotClose']]
              };
            }

            if (day != secondDay) {
              businessHoursData[day] = {
                'open': [element['open']],
                'close': [element['close']]
              };
              businessHoursData[secondDay] = {
                'open': [element['2ndSlotOpen']],
                'close': [element['2ndSlotClose']]
              };
            }
          }

          if (!element['2ndSlot']) {
            var result = Tools.isCloseTimeGreaterThanOpenTime(
                element['open'], element['close']);
            var day = '';
            switch (result) {
              case 0:
              case 2:
                day = element['day'];
                break;
              case 1:
                day = '${element['day']}~${element['nextDay']}';
                break;
            }
            if (result == 2) {
              businessHoursData[day] = {'open': '', 'close': ''};
            } else {
              businessHoursData[day] = {
                'open': element['open'],
                'close': element['close']
              };
            }
          }
        }
      }
    });
    var featuredImage = '';
    if (businessLogo.isNotEmpty) {
      if (!(businessLogo.first is Asset) &&
          businessLogo.first.contains('http')) {
        featuredImage = businessLogo.first;
      } else {
        var byteData = await businessLogo.first.getByteData(quality: 100);
        var bytes = byteData.buffer.asUint8List();
        var unit = await Tools.compressList(list: bytes);
        featuredImage = base64Encode(unit);
      }
    }
    var gallery = <String>[];
    if (galleryImages.isNotEmpty) {
      for (var img in galleryImages) {
        if (!(img is Asset) && img.contains('http')) {
          gallery.add(img);
        } else {
          var byteData = await img.getByteData(quality: 100);
          var bytes = byteData.buffer.asUint8List();
          var unit = await Tools.compressList(list: bytes);
          gallery.add(base64Encode(unit));
        }
      }
    }

    var data = {
      'id': listing.id,
      'plan_id': selectedPricePlan.id,
      'cookie': user.cookie,
      'postTitle': titleController.text,
      'postContent': descriptionController.text,
      'gAddress': addressController.text,
      'tags': tagsController.text,
      'location': selectedLocation,
      'category': selectedCategory,
      'business_hours': businessHoursData,
      'price_status': priceStatus,
      'tagline_text': tagLineController.text,
      'latitude': latitudeController.text,
      'longitude': longitudeController.text,
      'phone': phoneController.text,
      'website': websiteController.text,
      'listingprice': priceFromController.text,
      'listingptext': priceToController.text,
      'features': selectedFeatures,
    };

    if (faqs.isNotEmpty && faqAns.isNotEmpty) {
      var listFaq = <String>[];
      var listFaqAns = <String>[];
      faqs.forEach((element) {
        listFaq.add(element.text);
      });
      faqAns.forEach((element) {
        listFaqAns.add(element.text);
      });
      data['faq'] = listFaq;
      data['faqans'] = listFaqAns;
    }

    for (var item in socialMedias) {
      data[item['name']] = item['value'].text;
    }

    if (featuredImage.isNotEmpty) {
      data['featured_image'] = featuredImage;
    }
    if (gallery.isNotEmpty) {
      data['gallery'] = gallery;
    }
    var result = await _services.submitListing(data: data);
    _updateState(EditListingState.loaded);
    return result;
  }
}
