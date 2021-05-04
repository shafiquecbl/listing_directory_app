import '../tools/tools.dart';

class PricePlan {
  int id;
  String title;
  String planPackageType;
  String planDescContent;
  String planTitleColor;
  String planNoOfImg;
  String planImgLmt;
  String planPrice;
  String planTime;
  String fPlanContinue;
  String planHot;
  String lpAdsWihPlan;
  String lpHidegooglead;
  String lpEventsplan;
  String lpFeaturedImageplan;
  String listingprocPlanCampaigns;
  String listingprocPlanDeals;
  String listingprocPlanTimekit;
  String listingprocPlanAnnouncment;
  String listingprocPlanMenu;
  String listingprocPlanReservera;
  String contactShow;
  String mapShow;
  String videoShow;
  String galleryShow;
  String listingprocTagline;
  String listingprocLocation;
  String listingprocWebsite;
  String listingprocSocial;
  String listingprocLeadform;
  String listingprocBookings;
  String listingprocFaq;
  String listingprocPrice;
  String listingprocTagKey;
  String listingprocBhours;
  LpPricePlanListingproOptions lpListingproOptions;
  String lpListingproOptionsFields;

  PricePlan(
      {this.id,
      this.title,
      this.planPackageType,
      this.planDescContent,
      this.planTitleColor,
      this.planNoOfImg,
      this.planImgLmt,
      this.planPrice,
      this.planTime,
      this.fPlanContinue,
      this.planHot,
      this.lpAdsWihPlan,
      this.lpHidegooglead,
      this.lpEventsplan,
      this.lpFeaturedImageplan,
      this.listingprocPlanCampaigns,
      this.listingprocPlanDeals,
      this.listingprocPlanTimekit,
      this.listingprocPlanAnnouncment,
      this.listingprocPlanMenu,
      this.listingprocPlanReservera,
      this.contactShow,
      this.mapShow,
      this.videoShow,
      this.galleryShow,
      this.listingprocTagline,
      this.listingprocLocation,
      this.listingprocWebsite,
      this.listingprocSocial,
      this.listingprocLeadform,
      this.listingprocBookings,
      this.listingprocFaq,
      this.listingprocPrice,
      this.listingprocTagKey,
      this.listingprocBhours,
      this.lpListingproOptions,
      this.lpListingproOptionsFields});

  PricePlan.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      title = json['title']['rendered'];
      planPackageType = json['plan_package_type'];
      planDescContent = json['plan_desc_content'];
      planTitleColor = json['plan_title_color'];
      planNoOfImg = json['plan_no_of_img'];
      if (Tools.checkEmptyString(planNoOfImg)) {
        planNoOfImg = '100';
      }
      planImgLmt = json['plan_img_lmt'];
      if (Tools.checkEmptyString(planImgLmt)) {
        planImgLmt = '100';
      }
      planPrice = json['plan_price'];
      planTime = json['plan_time'];
      fPlanContinue = json['f_plan_continue'];
      planHot = json['plan_hot'];
      lpAdsWihPlan = json['lp_ads_wih_plan'];
      lpHidegooglead = json['lp_hidegooglead'];
      lpEventsplan = json['lp_eventsplan'];
      lpFeaturedImageplan = json['lp_featured_imageplan'];
      listingprocPlanCampaigns = json['listingproc_plan_campaigns'];
      listingprocPlanDeals = json['listingproc_plan_deals'];
      listingprocPlanTimekit = json['listingproc_plan_timekit'];
      listingprocPlanAnnouncment = json['listingproc_plan_announcment'];
      listingprocPlanMenu = json['listingproc_plan_menu'];
      listingprocPlanReservera = json['listingproc_plan_reservera'];
      contactShow = json['contact_show'];
      mapShow = json['map_show'];
      videoShow = json['video_show'];
      galleryShow = json['gallery_show'];
      listingprocTagline = json['listingproc_tagline'];
      listingprocLocation = json['listingproc_location'];
      listingprocWebsite = json['listingproc_website'];
      listingprocSocial = json['listingproc_social'];
      listingprocLeadform = json['listingproc_leadform'];
      listingprocBookings = json['listingproc_bookings'];
      listingprocFaq = json['listingproc_faq'];
      listingprocPrice = json['listingproc_price'];
      listingprocTagKey = json['listingproc_tag_key'];
      listingprocBhours = json['listingproc_bhours'];
      lpListingproOptions = json['lp_listingpro_options'] != null
          ? LpPricePlanListingproOptions.fromJson(json['lp_listingpro_options'])
          : null;
      lpListingproOptionsFields = json['lp_listingpro_options_fields'];
    } catch (e) {
      log('PricePlan.fromJson $e');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['plan_package_type'] = planPackageType;
    data['plan_desc_content'] = planDescContent;
    data['plan_title_color'] = planTitleColor;
    data['plan_no_of_img'] = planNoOfImg;
    data['plan_img_lmt'] = planImgLmt;
    data['plan_price'] = planPrice;
    data['plan_time'] = planTime;
    data['f_plan_continue'] = fPlanContinue;
    data['plan_hot'] = planHot;
    data['lp_ads_wih_plan'] = lpAdsWihPlan;
    data['lp_hidegooglead'] = lpHidegooglead;
    data['lp_eventsplan'] = lpEventsplan;
    data['lp_featured_imageplan'] = lpFeaturedImageplan;
    data['listingproc_plan_campaigns'] = listingprocPlanCampaigns;
    data['listingproc_plan_deals'] = listingprocPlanDeals;
    data['listingproc_plan_timekit'] = listingprocPlanTimekit;
    data['listingproc_plan_announcment'] = listingprocPlanAnnouncment;
    data['listingproc_plan_menu'] = listingprocPlanMenu;
    data['listingproc_plan_reservera'] = listingprocPlanReservera;
    data['contact_show'] = contactShow;
    data['map_show'] = mapShow;
    data['video_show'] = videoShow;
    data['gallery_show'] = galleryShow;
    data['listingproc_tagline'] = listingprocTagline;
    data['listingproc_location'] = listingprocLocation;
    data['listingproc_website'] = listingprocWebsite;
    data['listingproc_social'] = listingprocSocial;
    data['listingproc_leadform'] = listingprocLeadform;
    data['listingproc_bookings'] = listingprocBookings;
    data['listingproc_faq'] = listingprocFaq;
    data['listingproc_price'] = listingprocPrice;
    data['listingproc_tag_key'] = listingprocTagKey;
    data['listingproc_bhours'] = listingprocBhours;
    if (lpListingproOptions != null) {
      data['lp_listingpro_options'] = lpListingproOptions.toJson();
    }
    data['lp_listingpro_options_fields'] = lpListingproOptionsFields;
    return data;
  }
}

class Title {
  String rendered;

  Title({this.rendered});

  Title.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rendered'] = rendered;
    return data;
  }
}

class LpPricePlanListingproOptions {
  String planFor;
  String lpPricePlanBg;
  Map<dynamic, dynamic> lpPricePlanAddmore;

  LpPricePlanListingproOptions(
      {this.planFor, this.lpPricePlanBg, this.lpPricePlanAddmore});

  LpPricePlanListingproOptions.fromJson(Map<String, dynamic> json) {
    planFor = json['plan_for'];
    lpPricePlanBg = json['lp_price_plan_bg'];
    if (json['lp_price_plan_addmore'] is String) {
      lpPricePlanAddmore = {};
    } else {
      lpPricePlanAddmore = json['lp_price_plan_addmore'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['plan_for'] = planFor;
    data['lp_price_plan_bg'] = lpPricePlanBg;
    data['lp_price_plan_addmore'] = lpPricePlanAddmore;
    return data;
  }
}
