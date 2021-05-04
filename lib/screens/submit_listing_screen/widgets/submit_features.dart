import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/export.dart';

class SubmitFeatures extends StatefulWidget {
  final List<Feature> features;
  final onCallBack;
  final List<int> selectedFeatures;
  const SubmitFeatures(
      {Key key, this.features, this.onCallBack, this.selectedFeatures})
      : super(key: key);
  @override
  _SubmitFeaturesState createState() => _SubmitFeaturesState();
}

class _SubmitFeaturesState extends State<SubmitFeatures> {
  List<int> featureIds = [];
  bool _isOpen = false;

  @override
  void initState() {
    if (widget.selectedFeatures != null) {
      featureIds.addAll(widget.selectedFeatures);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                Text(
                  'features'.tr(),
                  style: theme.textTheme.headline6
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                _isOpen
                    ? const Icon(Icons.arrow_drop_down)
                    : const SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(Icons.arrow_right),
                      )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        if (_isOpen)
          Wrap(
            direction: Axis.horizontal,
            children: List.generate(
                widget.features.length,
                (index) => InkWell(
                      onTap: () {
                        if (featureIds.contains(widget.features[index].id)) {
                          featureIds.remove(widget.features[index].id);
                        } else {
                          featureIds.add(widget.features[index].id);
                        }
                        setState(() {});
                        widget.onCallBack(widget.features[index].id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color:
                                featureIds.contains(widget.features[index].id)
                                    ? theme.accentColor
                                    : Colors.grey),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Text(
                          widget.features[index].name,
                          style: theme.textTheme.subtitle1
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )),
          ),
      ],
    );
  }
}
