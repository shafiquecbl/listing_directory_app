import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../common_widgets/skeleton.dart';
import '../../../tools/tools.dart';

class SubmitGalleryImages extends StatefulWidget {
  final List<dynamic> galleryImages;
  final Function onCallBack;
  final Function onRemove;
  final int maxImages;
  final int maxSize;

  const SubmitGalleryImages(
      {Key key,
      this.galleryImages,
      this.onCallBack,
      this.maxImages = 1,
      this.maxSize = 1,
      this.onRemove})
      : super(key: key);
  @override
  _SubmitGalleryImagesState createState() => _SubmitGalleryImagesState();
}

class _SubmitGalleryImagesState extends State<SubmitGalleryImages> {
  List<dynamic> images = [];
  int maxBytes;
  int currentBytes = 0;
  @override
  void initState() {
    images.addAll(widget.galleryImages);
    maxBytes = widget.maxSize * 1000000;
    super.initState();
  }

  Future<void> pickImages() async {
    try {
      var count = widget.maxImages - images.length;
      if (count == 0) {
        showToast('imagesAllowed'.plural(widget.maxImages));
        return;
      }
      var tmp = await MultiImagePicker.pickImages(
          maxImages: widget.maxImages - images.length, enableCamera: true);
      var tmpBytes = currentBytes;
      for (var img in tmp) {
        var byteData = await img.getByteData(quality: 100);
        var bytes = byteData.buffer.asUint8List();
        var unit = await Tools.compressList(list: bytes);
        if ((tmpBytes + unit.length) > maxBytes) {
          showToast('maxSizeAllowed'.plural(widget.maxSize));
          return;
        }
        tmpBytes += unit.length;
      }
      if (widget.onCallBack != null) {
        widget.onCallBack(tmp);
      }
      images.addAll(tmp);
      setState(() {});
    } catch (e) {
      log(e);
    }
  }

  void _removeImage(int index) {
    images.removeAt(index);
    widget.onRemove(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            'imageGallery'.tr(),
            style:
                theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: pickImages,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(right: 5.0),
                  height: 80.0,
                  width: 80.0,
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ...List.generate(
                images.length,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(right: 5.0),
                  height: 80.0,
                  width: 80.0,
                  child: Stack(
                    children: [
                      if (images[index] is Asset)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: AssetThumb(
                            asset: images[index],
                            width: 80,
                            height: 80,
                            spinner: Skeleton(
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      if (images[index] is String)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: images[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => _removeImage(index),
                          child: const Icon(
                            Icons.close_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
