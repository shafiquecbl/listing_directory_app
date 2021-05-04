import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share/share.dart';

import '../../configs/dynamic_link_config.dart';
import '../../entities/listing.dart';
import '../../entities/review.dart';
import '../../entities/user.dart';
import '../../services/api_service.dart';
import '../../tools/tools.dart';

enum ReviewState { loading, loaded, upload }

class ItemDetailScreenModel extends ChangeNotifier {
  Listing listing;
  final _services = ApiServices();
  List<Review> reviews = [];
  List<dynamic> reviewUploadImages = [];
  List<String> removedUrls = [];
  final reviewTitleController = TextEditingController();
  final reviewContentController = TextEditingController();
  double uploadProgress = 0.0;
  var state = ReviewState.loading;
  double rating = 5.0;

  void _updateState(state) {
    this.state = state;
    notifyListeners();
  }

  ItemDetailScreenModel(this.listing) {
    getReviews();
    _services.updateView(listing.id, isAd: listing.isAd);
  }
  int _page = 1;
  final _perPage = 10;
  Future<void> getReviews() async {
    _updateState(ReviewState.loading);
    _page = 1;
    reviews = await _services.getReviews(
        id: listing.id, page: _page, perPage: _perPage);
    _updateState(ReviewState.loaded);
  }

  void resetReview() {
    reviewTitleController.clear();
    reviewContentController.clear();
    rating = 5.0;
    reviewUploadImages.clear();
    removedUrls.clear();
  }

  void updateEditReview(Review review) {
    reviewTitleController.text = review.title;
    reviewContentController.text = review.content;
    rating = double.parse(review.lpListingproOptions.rating);
    reviewUploadImages = <dynamic>[];
    reviewUploadImages.addAll(review.galleryImages);
  }

  Future<List<dynamic>> convertImagesToBase64() async {
    var images64 = [];
    if (reviewUploadImages != null) {
      if (reviewUploadImages.isNotEmpty) {
        for (var i = 0; i < reviewUploadImages.length; i++) {
          if (reviewUploadImages[i] is String) {
            continue;
          }
          var img64 = '';
          if (reviewUploadImages[i] is Asset) {
            var unit;
            var byteData =
                await reviewUploadImages[i].getByteData(quality: 100);
            var bytes = byteData.buffer.asUint8List();
            unit = await Tools.compressList(list: bytes);
            img64 = base64Encode(unit);
            images64.add(img64);
          }
        }
      }
    }
    return images64;
  }

  Future<void> createReview(User user) async {
    _updateState(ReviewState.upload);
    final images64 = await convertImagesToBase64();
    var code = await _services.createReview(
        user: user,
        data: {
          'listing_id': listing.id.toString(),
          'post_author': user.id.toString(),
          'post_title': reviewTitleController.text,
          'post_content': reviewContentController.text,
          'rating': rating.toString(),
          'images64': images64,
        },
        updateProgress: _updateReviewProgress);
    uploadProgress = 0.0;
    if (code == 1) {
      showToast('submitReviewSuccess'.tr());
      await getReviews();
    }
    if (code == -1) {
      showToast('unknownError'.tr());
    }
    if (code == 2) {
      showToast('haveReview'.tr());
    }
    if (code == 0) {
      showToast('ownerCannotSubmitReview'.tr());
    }
  }

  void updateRating(double rating) {
    this.rating = rating;
  }

  void removeImage(int index) {
    if (reviewUploadImages[index] is String) {
      removedUrls.add(reviewUploadImages[index]);
    }
    reviewUploadImages.removeAt(index);
    notifyListeners();
  }

  Future<void> pickImages() async {
    try {
      final images =
          await MultiImagePicker.pickImages(maxImages: 5, enableCamera: true);
      reviewUploadImages.addAll(images);
    } on Exception {
      reviewUploadImages = [];
    }
    notifyListeners();
  }

  void _updateReviewProgress(int sent, int total) {
    uploadProgress = sent / total;
    if (uploadProgress == 1.0) {
      uploadProgress -= 0.1;
    }
    notifyListeners();
  }

  Future<void> deleteReview(User user, int reviewId) async {
    _updateState(ReviewState.loading);
    await _services.deleteReview(user: user, reviewId: reviewId).then((val) {
      if (val == 1) {
        showToast('deleteSuccessful'.tr());
        getReviews();
        return;
      }
      showToast('deleteFailed'.tr());
    });
  }

  Future<void> editReview(User user, int reviewId) async {
    _updateState(ReviewState.upload);
    final images64 = await convertImagesToBase64();
    var code = await _services.editReview(
        user: user,
        data: {
          'listing_id': listing.id.toString(),
          'post_author': user.id.toString(),
          'post_title': reviewTitleController.text,
          'post_content': reviewContentController.text,
          'rating': rating.toString(),
          'review_id': reviewId,
          'images64': images64,
          'remove_urls': removedUrls,
        },
        updateProgress: _updateReviewProgress);
    uploadProgress = 0.0;
    if (code == 1) {
      showToast('editReviewSuccess'.tr());
      await getReviews();
    }
    if (code == -1) {
      showToast('editReviewFailed'.tr());
    }
  }

  Future<void> shareListing(String link) async {
    final url = await DynamicLinkService.createLink(link);
    await Share.share(url);
  }
}
