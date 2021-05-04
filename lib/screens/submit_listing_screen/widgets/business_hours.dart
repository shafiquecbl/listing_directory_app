import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tools/tools.dart';
import '../submit_listing_constant.dart';

class BusinessHours extends StatefulWidget {
  final List<Map<dynamic, dynamic>> businessHours;

  const BusinessHours({Key key, this.businessHours}) : super(key: key);
  @override
  _BusinessHoursState createState() => _BusinessHoursState();
}

class _BusinessHoursState extends State<BusinessHours> {
  bool _isOpen = false;

  void _updateBusinessHours(int index, Map<dynamic, dynamic> map) {
    widget.businessHours[index] = map;

    // if (map['open'].contains('pm') && map['close'].contains('am')) {
    //   widget.businessHours.remove(key);
    //   var index = SubmitListingConstant.days.indexWhere((day) => day == key);
    //   var nextDay =
    //       (index + 1) == SubmitListingConstant.days.length ? 0 : index + 1;
    //   widget.businessHours['$key~${SubmitListingConstant.days[nextDay]}'] = map;
    //   print(key);
    // } else {
    //   widget.businessHours[key] = map;
    // }

    setState(() {});
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
                  'businessHours'.tr(),
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
        if (_isOpen) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: List.generate(
                  widget.businessHours.length,
                  (index) => DayDropdownValue(
                        businessHour: widget.businessHours[index],
                        index: index,
                        onCallBack: (index, map) =>
                            _updateBusinessHours(index, map),
                      )),
            ),
          ),
        ]
      ],
    );
  }
}

enum DayDropdownType { open, close }

class DayDropdownValue extends StatefulWidget {
  final Map<dynamic, dynamic> businessHour;
  final int index;
  final onCallBack;
  const DayDropdownValue(
      {Key key, this.businessHour, this.onCallBack, this.index})
      : super(key: key);

  @override
  _DayDropdownValueState createState() => _DayDropdownValueState();
}

class _DayDropdownValueState extends State<DayDropdownValue> {
  @override
  void initState() {
    super.initState();
  }

  void _showBottomSheet(DayDropdownType type, String value,
      {bool isSecondSlot = false}) {
    var list = [];
    list = SubmitListingConstant.time;
    var initialValue = list.indexWhere((element) => element == value);

    showModalBottomSheet(
      context: (context),
      builder: (subContext) => Container(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 50.0,
          looping: true,
          scrollController:
              FixedExtentScrollController(initialItem: initialValue),
          onSelectedItemChanged: (val) {
            var map = <dynamic, dynamic>{};
            widget.businessHour.forEach((key, value) {
              map[key] = value;
            });
            switch (type) {
              case DayDropdownType.open:
                isSecondSlot
                    ? map['2ndSlotOpen'] = SubmitListingConstant.time[val]
                    : map['open'] = SubmitListingConstant.time[val];

                break;
              case DayDropdownType.close:
                isSecondSlot
                    ? map['2ndSlotClose'] = SubmitListingConstant.time[val]
                    : map['close'] = SubmitListingConstant.time[val];

                break;
            }
            widget.onCallBack(
              widget.index,
              map,
            );
          },
          children: List.generate(
            list.length,
            (index) => Center(
              child: Text(
                list[index],
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

    var day = widget.businessHour['day'];
    var secondDay = widget.businessHour['2ndSlotDay'];

    bool is24Hour = Tools.isCloseTimeGreaterThanOpenTime(
                widget.businessHour['open'], widget.businessHour['close']) ==
            2
        ? true
        : widget.businessHour['24hours'];

    if (Tools.isCloseTimeGreaterThanOpenTime(
            widget.businessHour['open'], widget.businessHour['close']) ==
        1) {
      day = '${widget.businessHour['day']}~\n${widget.businessHour['nextDay']}';
    }
    if (widget.businessHour['2ndSlot']) {
      if (Tools.isCloseTimeGreaterThanOpenTime(
              widget.businessHour['2ndSlotOpen'],
              widget.businessHour['2ndSlotClose']) ==
          1) {
        secondDay =
            '${widget.businessHour['2ndSlotDay']}~\n${widget.businessHour['2ndSlotNextDay']}';
      }
      is24Hour = widget.businessHour['24hours'];
    }

    return Column(
      children: [
        Container(
          height: 40.0,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                height: 40.0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: widget.businessHour['enable']
                      ? null
                      : Colors.grey.withOpacity(0.3),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        day,
                        style: theme.textTheme.caption
                            .copyWith(fontWeight: FontWeight.w500),
                      ).tr(),
                    ),
                  ],
                ),
              )),
              const SizedBox(width: 10.0),
              Expanded(
                child: InkWell(
                  onTap: () => widget.businessHour['enable']
                      ? !widget.businessHour['24hours']
                          ? _showBottomSheet(
                              DayDropdownType.open, widget.businessHour['open'])
                          : null
                      : null,
                  child: Container(
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: widget.businessHour['enable']
                            ? !widget.businessHour['24hours']
                                ? null
                                : Colors.grey.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.businessHour['open'],
                            style: theme.textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                  child: InkWell(
                onTap: () => widget.businessHour['enable']
                    ? !widget.businessHour['24hours']
                        ? _showBottomSheet(
                            DayDropdownType.close, widget.businessHour['close'])
                        : null
                    : null,
                child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      color: widget.businessHour['enable']
                          ? !widget.businessHour['24hours']
                              ? null
                              : Colors.grey.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.3),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: [
                      Text(
                        widget.businessHour['close'],
                        style: theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Expanded(child: SizedBox(width: 1)),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        ...[
          const SizedBox(height: 5.0),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            height: widget.businessHour['enable'] &&
                    !widget.businessHour['24hours'] &&
                    widget.businessHour['2ndSlot']
                ? 40
                : 0,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: widget.businessHour['enable']
                        ? null
                        : Colors.grey.withOpacity(0.3),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          secondDay,
                          style: theme.textTheme.caption
                              .copyWith(fontWeight: FontWeight.w500),
                        ).tr(),
                      ),
                    ],
                  ),
                )),
                const SizedBox(width: 10.0),
                Expanded(
                  child: InkWell(
                    onTap: () => widget.businessHour['enable']
                        ? !widget.businessHour['24hours']
                            ? _showBottomSheet(DayDropdownType.open,
                                widget.businessHour['2ndSlotOpen'],
                                isSecondSlot: true)
                            : null
                        : null,
                    child: Container(
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: widget.businessHour['enable']
                              ? !widget.businessHour['24hours']
                                  ? null
                                  : Colors.grey.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.businessHour['2ndSlotOpen'],
                              style: theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                              opacity: widget.businessHour['enable'] &&
                                      !widget.businessHour['24hours'] &&
                                      widget.businessHour['2ndSlot']
                                  ? 1.0
                                  : 0.0,
                              duration: Duration(
                                  milliseconds:
                                      widget.businessHour['2ndSlot'] ? 500 : 0),
                              curve: Curves.ease,
                              child: const Icon(Icons.arrow_drop_down)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                    child: InkWell(
                  onTap: () => widget.businessHour['enable']
                      ? !widget.businessHour['24hours']
                          ? _showBottomSheet(DayDropdownType.close,
                              widget.businessHour['2ndSlotClose'],
                              isSecondSlot: true)
                          : null
                      : null,
                  child: Container(
                    height: 40.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: widget.businessHour['enable']
                            ? !widget.businessHour['24hours']
                                ? null
                                : Colors.grey.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.3),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Row(
                      children: [
                        Text(
                          widget.businessHour['2ndSlotClose'],
                          style: theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Expanded(child: SizedBox(width: 1)),
                        AnimatedOpacity(
                            opacity: widget.businessHour['enable'] &&
                                    !widget.businessHour['24hours'] &&
                                    widget.businessHour['2ndSlot']
                                ? 1.0
                                : 0.0,
                            duration: Duration(
                                milliseconds:
                                    widget.businessHour['2ndSlot'] ? 500 : 0),
                            curve: Curves.ease,
                            child: const Icon(Icons.arrow_drop_down)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Text('enable'.tr(),
                    style: theme.textTheme.caption.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(width: 5),
                SizedBox(
                  width: 23.0,
                  height: 23.0,
                  child: Checkbox(
                    value: widget.businessHour['enable'],
                    onChanged: (val) => setState(() =>
                        widget.businessHour['enable'] =
                            !widget.businessHour['enable']),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox(width: 1)),
            Row(
              children: [
                Text(
                  '2ndSlot'.tr(),
                  style: theme.textTheme.caption.copyWith(
                    color: widget.businessHour['enable']
                        ? null
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 23.0,
                  height: 23.0,
                  child: Checkbox(
                    activeColor: widget.businessHour['enable']
                        ? widget.businessHour['24hours']
                            ? Colors.grey.shade500
                            : null
                        : Colors.grey.shade500,
                    value: widget.businessHour['24hours']
                        ? false
                        : widget.businessHour['2ndSlot'],
                    onChanged: (val) => widget.businessHour['enable']
                        ? widget.businessHour['24hours']
                            ? null
                            : setState(() => widget.businessHour['2ndSlot'] =
                                !widget.businessHour['2ndSlot'])
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            Row(
              children: [
                Text(
                  '24hours'.tr(),
                  style: theme.textTheme.caption.copyWith(
                    color: widget.businessHour['enable']
                        ? null
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 23.0,
                  height: 23.0,
                  child: Checkbox(
                    activeColor: widget.businessHour['enable']
                        ? null
                        : Colors.grey.shade500,
                    value: is24Hour,
                    onChanged: (val) => widget.businessHour['enable']
                        ? widget.businessHour['2ndSlot']
                            ? setState(() => widget.businessHour['24hours'] =
                                !widget.businessHour['24hours'])
                            : Tools.isCloseTimeGreaterThanOpenTime(
                                        widget.businessHour['open'],
                                        widget.businessHour['close']) ==
                                    2
                                ? null
                                : setState(() =>
                                    widget.businessHour['24hours'] =
                                        !widget.businessHour['24hours'])
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
