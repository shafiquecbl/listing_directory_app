import '../configs/app_constants.dart';
import '../tools/tools.dart';
import 'event.dart';
import 'export.dart';

class Listing {
  int id;
  double distance;
  String openStatus;
  PureTaxonomies pureTaxonomies;
  String link;
  String title;
  String content;
  String featuredImage;
  List<String> galleryImages;
  String listingRate;
  String listingReviewed;
  LpListingproOptions lpListingproOptions;
  List<Event> events;
  bool isEnableBooking;
  bool isAd;
  bool isPaid;
  String authorId;
  String authorAvatar;
  String postStatus;
  String planName;
  String authorName;
  PricePlan pricePlan;
  Listing({
    this.id,
    this.distance,
    this.openStatus,
    this.pureTaxonomies,
    this.link,
    this.title,
    this.content,
    this.featuredImage,
    this.galleryImages,
    this.lpListingproOptions,
    this.events,
    this.listingRate,
    this.listingReviewed,
    this.isEnableBooking,
    this.isAd = false,
    this.isPaid,
    this.postStatus,
    this.planName,
    this.authorId,
    this.authorName,
    this.authorAvatar,
    this.pricePlan,
  });

  Listing.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      //distance = double.parse(json['distance']?.toString());
      isAd = json['isAd'] ?? false;
      postStatus = json['post_status'];
      openStatus = json['open_status'];
      pureTaxonomies =
          json['pure_taxonomies'] != null && json['pure_taxonomies'] is Map
              ? PureTaxonomies.fromJson(json['pure_taxonomies'])
              : null;
      link = json['link'];
      authorName = json['author_display_name'];
      authorId = json['author'].toString();
      authorAvatar = json['author_avatar'];
      isPaid = json['paid'] ?? true;
      planName = json['plan_name'] ?? '';
      title = Tools.parseHtmlString(json['title']['rendered']);
      content = Tools.parseHtmlString(json['content']['rendered']);
      featuredImage = json['featured_image'];

      galleryImages = json['gallery_images']?.cast<String>();
      galleryImages ??= [];

      if (Tools.checkEmptyString(featuredImage)) {
        if (galleryImages.isNotEmpty) {
          featuredImage = galleryImages[0];
        } else {
          featuredImage = kDefaultImage;
        }
      } else {
        galleryImages.insert(0, featuredImage);
      }

      listingRate = json['listing_rate'];
      if (listingRate == null || listingRate.isEmpty) {
        listingRate = '0.0';
      }
      listingReviewed = json['listing_reviewed'];
      if (listingReviewed == null || listingReviewed.isEmpty) {
        listingReviewed = '0';
      }
      isEnableBooking = json['enable_booking'];
      lpListingproOptions = json['lp_listingpro_options'] != null
          ? LpListingproOptions.fromJson(json['lp_listingpro_options'])
          : null;
      if (json['events'] != null) {
        events = <Event>[];
        json['events'].forEach((v) {
          events.add(Event.fromJson(v));
        });
      }
      if (json['price_plan'] != null && json['price_plan']['id'] != 0) {
        pricePlan = PricePlan.fromJson(json['price_plan']);
      }
    } catch (e) {
      log('Listing.fromJson $title $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['distance'] = distance;
    data['open_status'] = openStatus;
    if (pureTaxonomies != null) {
      data['pure_taxonomies'] = pureTaxonomies.toJson();
    }
    data['link'] = link;
    data['title'] = title;
    data['content'] = content;
    data['featured_image'] = featuredImage;
    data['gallery_images'] = galleryImages;
    data['listing_rate'] = listingRate;
    data['listing_reviewed'] = listingReviewed;
    if (lpListingproOptions != null) {
      data['lp_listingpro_options'] = lpListingproOptions.toJson();
    }
    if (events != null) {
      data['events'] = events.map((v) => v.toJson()).toList();
    }
    data['price_plan'] = pricePlan.toJson();
    return data;
  }
}

class PureTaxonomies {
  List<Taxonomy> listingCategory;
  List<Taxonomy> location;
  List<Taxonomy> features;
  List<Taxonomy> tags;
  PureTaxonomies({listingCategory, location, features, tags});

  PureTaxonomies.fromJson(Map<String, dynamic> json) {
    if (json['listing-category'] != null) {
      listingCategory = <Taxonomy>[];
      json['listing-category'].forEach((v) {
        listingCategory.add(Taxonomy.fromJson(v));
      });
    }
    if (json['location'] != null) {
      location = <Taxonomy>[];
      json['location'].forEach((v) {
        location.add(Taxonomy.fromJson(v));
      });
    }
    if (json['features'] != null) {
      features = <Taxonomy>[];
      json['features'].forEach((v) {
        features.add(Taxonomy.fromJson(v));
      });
    }
    if (json['list-tags'] != null) {
      tags = <Taxonomy>[];
      json['list-tags'].forEach((v) {
        tags.add(Taxonomy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (listingCategory != null) {
      data['listing-category'] =
          listingCategory.map((v) => v.toJson()).toList();
    }
    if (location != null) {
      data['location'] = location.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Taxonomy {
  int termId;
  String name;

  Taxonomy({
    termId,
    name,
  });

  Taxonomy.fromJson(Map<String, dynamic> json) {
    termId = json['term_id'];
    name = Tools.parseHtmlString(json['name']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term_id'] = termId;
    data['name'] = name;
    return data;
  }
}

class LpListingproOptions {
  String taglineText;
  String gAddress;
  double latitude;
  double longitude;
  String phone;
  String whatsapp;
  String email;
  String website;
  String twitter;
  String facebook;
  String linkedin;
  String youtube;
  String instagram;
  String video;
  String gallery;
  String priceStatus;
  String listPrice;
  String listPriceTo;
  String reviewsIds;
  String planId;
  List<BusinessHours> businessHours = [];
  String businessLogo;
  bool claimedSection;
  Faqs faqs;
  LpListingproOptions(
      {this.taglineText,
      this.gAddress,
      this.latitude,
      this.longitude,
      this.phone,
      this.whatsapp,
      this.email,
      this.website,
      this.twitter,
      this.facebook,
      this.linkedin,
      this.youtube,
      this.instagram,
      this.video,
      this.gallery,
      this.priceStatus,
      this.listPrice,
      this.listPriceTo,
      this.reviewsIds,
      this.businessHours,
      this.businessLogo,
      this.claimedSection,
      this.planId,
      this.faqs});

  LpListingproOptions.fromJson(Map<String, dynamic> json) {
    taglineText = json['tagline_text'];
    gAddress = json['gAddress'];

    if (json['latitude'] != null &&
        json['longitude'] != null &&
        json['latitude'].toString().isNotEmpty &&
        json['longitude'].toString().isNotEmpty) {
      latitude = double.parse(json['latitude']);
      longitude = double.parse(json['longitude']);
    }
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    email = json['email'];
    website = json['website'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    planId = json['Plan_id'];
    video = json['video'];
    gallery = json['gallery'];
    priceStatus = json['price_status'];
    listPrice = json['list_price'];
    listPriceTo = json['list_price_to'];
    reviewsIds = json['reviews_ids'].toString();
    businessLogo = json['business_logo'];
    claimedSection = !(json['claimed_section'] == null ||
        json['claimed_section'].contains('not_claimed'));

    final openHoursList = json['business_hours'];
    var tmpList = <BusinessHours>[];
    if (openHoursList != null && openHoursList.isNotEmpty) {
      openHoursList.forEach((k, v) {
        tmpList.add(BusinessHours.fromJson(k, v));
      });

      for (var i = 0; i < tmpList.length; i++) {
        if ((i + 1) < tmpList.length && tmpList[i].day == tmpList[i + 1].day) {
          tmpList[i].openTime.addAll(tmpList[i + 1].openTime);
          tmpList[i].closeTime.addAll(tmpList[i + 1].closeTime);
          businessHours.add(tmpList[i]);
          i += 1;
        } else {
          businessHours.add(tmpList[i]);
        }
      }
    }
    faqs = json['faqs'] != null ? Faqs.fromJson(json['faqs']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tagline_text'] = taglineText;
    data['gAddress'] = gAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['whatsapp'] = whatsapp;
    data['email'] = email;
    data['website'] = website;
    data['twitter'] = twitter;
    data['facebook'] = facebook;
    data['linkedin'] = linkedin;
    data['youtube'] = youtube;
    data['instagram'] = instagram;
    data['video'] = video;
    data['gallery'] = gallery;
    data['price_status'] = priceStatus;
    data['list_price'] = listPrice;
    data['list_price_to'] = listPriceTo;
    data['Plan_id'] = planId;
    if (faqs != null) {
      data['faqs'] = faqs.toJson();
    }
    // if (businessHours != null) {
    //   data['business_hours'] = businessHours.toJson();
    // }

    data['business_logo'] = businessLogo;
    return data;
  }
}

class Faqs {
  List<String> faq = [];
  List<String> faqans = [];

  Faqs({this.faq, this.faqans});

  Faqs.fromJson(Map<String, dynamic> json) {
    if (json['faq'] is List && json['faqans'] is List) {
      faq = json['faq'].cast<String>();
      faqans = json['faqans'].cast<String>();
    } else if (json['faq'] is Map && json['faqans'] is Map) {
      json['faq'].forEach((k, v) {
        faq.add(v);
      });
      json['faqans'].forEach((k, v) {
        faqans.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['faq'] = faq;
    data['faqans'] = faqans;
    return data;
  }
}

class BusinessHours {
  String day;
  String nextDay;
  List<String> openTime = [];
  List<String> closeTime = [];

  BusinessHours.fromJson(String key, dynamic value) {
    try {
      day = key;

      if (day.contains('~')) {
        day = key.split('~').first;
        nextDay = key.split('~').last;
      }

      if (value['open'].isEmpty) {
        openTime.add('24 hours open');
      } else {
        if (value['open'] is String) {
          var time = value['open'].toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          openTime.add(time);
        } else if (value['open'] is List) {
          value['open'].forEach((val) {
            var time = val.toString();
            // time = time.contains('am')
            //     ? time.replaceAll('am', ' AM')
            //     : time.replaceAll('pm', ' PM');
            openTime.add(time);
          });
        } else if (value['open'] is Map) {
          var time = value['open']['1'].toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          openTime.add(time);
        }

        if (value['close'] is String) {
          var time = value['close'].toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          closeTime.add(time);
        } else if (value['close'] is List) {
          value['close'].forEach((val) {
            var time = val.toString();
            // time = time.contains('am')
            //     ? time.replaceAll('am', ' AM')
            //     : time.replaceAll('pm', ' PM');
            closeTime.add(time);
          });
        } else if (value['close'] is Map) {
          var time = value['close']['1'].toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          closeTime.add(time);
        }
      }
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  BusinessHours.fromLocalJson(String key, dynamic value) {
    try {
      day = key;
      if (value['open'] is String) {
        var time = value['open'].toString();
        // time = time.contains('am')
        //     ? time.replaceAll('am', ' AM')
        //     : time.replaceAll('pm', ' PM');
        openTime.add(time);
      } else {
        value['open'].forEach((val) {
          var time = val.toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          openTime.add(time);
        });
      }
      if (value['close'] is String) {
        var time = value['close'].toString();
        // time = time.contains('am')
        //     ? time.replaceAll('am', ' AM')
        //     : time.replaceAll('pm', ' PM');
        closeTime.add(time);
      } else {
        value['close'].forEach((val) {
          var time = val.toString();
          // time = time.contains('am')
          //     ? time.replaceAll('am', ' AM')
          //     : time.replaceAll('pm', ' PM');
          closeTime.add(time);
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '$day': {'open': openTime, 'close': closeTime}
    };
  }
}

class Day {
  String open;
  String close;

  Day({open, close});

  Day.fromJson(Map<String, dynamic> json) {
    open = json['open'];
    close = json['close'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}
