import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceRangeWidget extends StatefulWidget {
  final onCallBack;
  final String priceStatus;
  const PriceRangeWidget({Key key, this.onCallBack, this.priceStatus})
      : super(key: key);
  @override
  _PriceRangeWidgetState createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  final data = [
    {'name': 'notsay', 'displayName': 'notsay'.tr()},
    {'name': 'inexpensive', 'displayName': 'inexpensive'.tr()},
    {'name': 'moderate', 'displayName': 'moderate'.tr()},
    {'name': 'pricey', 'displayName': 'pricey'.tr()},
    {'name': 'ultra_high_end', 'displayName': 'ultraHigh'.tr()},
  ];
  var currentIndex = 0;
  String displayName;
  @override
  void initState() {
    currentIndex =
        data.indexWhere((element) => element['name'] == widget.priceStatus);
    displayName = data[currentIndex]['displayName'];
    super.initState();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: (context),
      builder: (subContext) => Container(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 50.0,
          scrollController:
              FixedExtentScrollController(initialItem: currentIndex),
          onSelectedItemChanged: (val) {
            currentIndex = val;
            displayName = data[currentIndex]['displayName'];
            widget.onCallBack(data[currentIndex]['name']);
            setState(() {});
          },
          children: List.generate(
            data.length,
            (index) => Center(
              child: Text(
                data[index]['displayName'],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            'priceRange'.tr(),
            style:
                theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: _showBottomSheet,
          child: Container(
            height: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: theme.cardColor.withOpacity(0.5)),
            child: Row(
              children: [
                const SizedBox(width: 15.0),
                Text(
                  displayName,
                  style:
                      theme.textTheme.bodyText2.copyWith(color: Colors.white),
                ),
                const Expanded(child: SizedBox(width: 1)),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                const SizedBox(width: 10.0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
