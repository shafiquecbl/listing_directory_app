import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/gallery_showcase.dart';
import '../../../../common_widgets/search_input.dart';
import '../../../../entities/review.dart';
import '../../../../models/authentication_model.dart';
import '../../../../tools/tools.dart';
import '../../../../tools/widget_generate.dart';
import '../../item_detail_screen_model.dart';

class ReviewSubmit extends StatefulWidget {
  final Review review;

  const ReviewSubmit({Key key, this.review}) : super(key: key);
  @override
  _ReviewSubmitState createState() => _ReviewSubmitState();
}

class _ReviewSubmitState extends State<ReviewSubmit> {
  @override
  void initState() {
    Provider.of<ItemDetailScreenModel>(context, listen: false).resetReview();
    if (widget.review != null) {
      Provider.of<ItemDetailScreenModel>(context, listen: false)
          .updateEditReview(widget.review);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: WidgetGenerate.getAppBar(
          widget.review != null ? 'editReview'.tr() : 'reviewSubmit'.tr(),
          theme),
      body: Consumer<ItemDetailScreenModel>(
        builder: (_, model, __) => Stack(
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.backgroundColor,
              ),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            'yourKindReview'.tr().toUpperCase(),
                            style: theme.textTheme.headline5,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          width: size.width,
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.8),
                          margin: const EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'title'.tr(),
                          style: theme.textTheme.headline6,
                        ),
                        const SizedBox(height: 5.0),
                        SearchInput(
                          controller: model.reviewTitleController,
                          hintText: 'It was an awesome experience to be there',
                          enabledInput: true,
                        ),
                        const SizedBox(height: 10.0),
                        Text('reviews'.tr(), style: theme.textTheme.headline6),
                        const SizedBox(height: 5.0),
                        SearchInput(
                          controller: model.reviewContentController,
                          hintText:
                              'A great review covers food, service, and ambiance.',
                          enabledInput: true,
                          height: null,
                          maxLines: null,
                          onSubmitted: (val) => null,
                        ),
                        const SizedBox(height: 5.0),
                        ChangeNotifierProvider<ItemDetailScreenModel>.value(
                          value: model,
                          child: Consumer<ItemDetailScreenModel>(
                            builder: (_, itemModel, __) =>
                                SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: model.pickImages,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                        itemModel.reviewUploadImages.length,
                                        (index) => InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GalleryShowCase(
                                                    position: index,
                                                    assets: itemModel
                                                        .reviewUploadImages,
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8.0),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 75.0,
                                                      height: 75.0,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: itemModel
                                                                    .reviewUploadImages[
                                                                index] is String
                                                            ? CachedNetworkImage(
                                                                imageUrl: itemModel
                                                                        .reviewUploadImages[
                                                                    index],
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : AssetThumb(
                                                                asset: itemModel
                                                                        .reviewUploadImages[
                                                                    index],
                                                                width: 300,
                                                                height: 300,
                                                              ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: -12.0,
                                                      right: -15.0,
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .remove_circle_outline),
                                                        onPressed: () =>
                                                            itemModel
                                                                .removeImage(
                                                                    index),
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          width: size.width,
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.8),
                          margin: const EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: RatingBar.builder(
                            initialRating: model.rating,
                            minRating: 1.0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              model.updateRating(rating);
                            },
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (Tools.checkEmptyString(
                                      model.reviewTitleController.text) ||
                                  Tools.checkEmptyString(
                                      model.reviewContentController.text)) {
                                showToast('pleaseFillInYourReview'.tr());
                                return false;
                              }

                              if (widget.review != null) {
                                await model.editReview(user, widget.review.id);
                              } else {
                                await model.createReview(user);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.check),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (model.state == ReviewState.upload)
              Container(
                color: Colors.grey.withOpacity(0.3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    value: model.uploadProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                    backgroundColor: Colors.grey,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
