import '../configs/app_constants.dart';
import '../tools/tools.dart';

class Review {
  int id;
  int author;
  String date;
  String title;
  String content;
  int parent;
  String template;
  String authorName;
  int reviewCount;
  String authorAvt;
  List<String> galleryImages;
  String galleryImageIds;
  LpReviewListingproOptions lpListingproOptions;
  Review({
    this.id,
    this.author,
    this.date,
    this.title,
    this.content,
    this.parent,
    this.template,
    this.authorName,
    this.authorAvt,
    this.galleryImages,
    this.galleryImageIds,
    this.lpListingproOptions,
    this.reviewCount,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    date = json['date'];
    title = json['title'] != null ? Tools.parseHtmlString(json['title']) : null;
    content =
        json['content'] != null ? Tools.parseHtmlString(json['content']) : null;
    parent = json['parent'];
    template = json['template'];
    authorName = json['author_name'][0];
    authorAvt = kDefaultImage;
    if (json['author_name'][1] != null) {
      authorAvt = json['author_name'][1];
    }

    galleryImages = json['gallery_images'].cast<String>();
    galleryImageIds = json['gallery_image_ids'];
    lpListingproOptions = json['lp_listingpro_options'] != null
        ? LpReviewListingproOptions.fromJson(json['lp_listingpro_options'])
        : null;
    reviewCount = int.parse(json['review_count']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    if (title != null) {
      data['title']['rendered'] = title;
    }
    if (content != null) {
      data['content']['rendered'] = content;
    }
    data['parent'] = parent;
    data['template'] = template;
    data['author_name'] = authorName;
    data['gallery_images'] = galleryImages;
    data['gallery_image_ids'] = galleryImageIds;
    if (lpListingproOptions != null) {
      data['lp_listingpro_options'] = lpListingproOptions.toJson();
    }
    data['review_count'] = reviewCount;
    return data;
  }
}

class LpReviewListingproOptions {
  String rating;
  String listingId;

  LpReviewListingproOptions({this.rating, this.listingId});

  LpReviewListingproOptions.fromJson(Map<String, dynamic> json) {
    rating = '0.0';
    if (!Tools.checkEmptyString(json['rating'].toString())) {
      rating = json['rating'].toString();
    }
    listingId = json['listing_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rating'] = rating;
    data['listing_id'] = listingId;
    return data;
  }
}
