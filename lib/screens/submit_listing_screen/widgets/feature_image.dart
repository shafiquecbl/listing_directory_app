import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitFeatureImage extends StatefulWidget {
  final List<dynamic> featuredImage;
  final onCallBack;
  const SubmitFeatureImage({Key key, this.featuredImage, this.onCallBack})
      : super(key: key);
  @override
  _SubmitFeatureImageState createState() => _SubmitFeatureImageState();
}

class _SubmitFeatureImageState extends State<SubmitFeatureImage> {
  var image;
  @override
  void initState() {
    image = widget.featuredImage;
    super.initState();
  }

  Future<void> pickImages() async {
    try {
      var tmp =
          await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);
      if (tmp != null) {
        image = tmp;
      }
      setState(() {});
      widget.onCallBack(image);
    } on Exception {
      image = image;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            'businessLogo'.tr(),
            style:
                theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10.0),
        InkWell(
          onTap: pickImages,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 180.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null && image.isNotEmpty) ...[
                  if (image.first is Asset)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: AssetThumb(
                        asset: image.first,
                        width: size.width.toInt(),
                        height: 180,
                      ),
                    ),
                  if (image.first is String)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: image.first,
                        width: size.width,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
                Container(
                  width: size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
