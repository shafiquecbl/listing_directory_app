import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../entities/price_plan.dart';
import '../../../entities/user.dart';
import '../../../services/api_service.dart';
import '../../../tools/tools.dart';

enum SubmitListingState { loading, loaded, loadPricePlans }

class SubmitListingScreenModel extends ChangeNotifier {
  final _services = ApiServices();
  List<PricePlan> pricePlans = [];
  var state = SubmitListingState.loaded;
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
  List<Asset> galleryImages = [];
  List<Asset> businessLogo = [];
  String priceStatus = 'notsay';
  PricePlan selectedPricePlan;
  List<Map<dynamic, dynamic>> businessHours = [];

  /// Add this later
  ///String businessHours;

  /// text controllers for listing submit
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagLineController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
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

  void clearEverything() {
    titleController.clear();
    tagLineController.clear();
    addressController.clear();
    latitudeController.clear();
    longitudeController.clear();
    cityController.clear();
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
    _updateState(SubmitListingState.loaded);
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

  void updateGalleryImages(List<Asset> galleryImages) {
    this.galleryImages = galleryImages;
  }

  void updateSelectedPriceStatus(String status) {
    priceStatus = status;
  }

  SubmitListingScreenModel() {
    businessHours.addAll(prototypeBusinessHours);
    socialMedias.addAll(prototypeSocialMedia);
    getPricePlans();
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

  Future<void> getPricePlans() async {
    _updateState(SubmitListingState.loadPricePlans);
    pricePlans = await _services.getPricePlans();
    _updateState(SubmitListingState.loaded);
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
    _updateState(SubmitListingState.loading);

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
      var byteData = await businessLogo.first.getByteData(quality: 100);
      var bytes = byteData.buffer.asUint8List();
      var unit = await Tools.compressList(list: bytes);
      featuredImage = base64Encode(unit);
    }
    var gallery = <String>[];
    if (galleryImages.isNotEmpty) {
      for (var img in galleryImages) {
        var byteData = await img.getByteData(quality: 100);
        var bytes = byteData.buffer.asUint8List();
        var unit = await Tools.compressList(list: bytes);
        gallery.add(base64Encode(unit));
      }
    }

    var data = {
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
    _updateState(SubmitListingState.loaded);
    return result;
  }
}
