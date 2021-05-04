import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/category.dart';

class SubmitCategory extends StatefulWidget {
  final List<Category> categories;
  final int selectedCategory;
  final onCallBack;
  const SubmitCategory(
      {Key key, this.categories, this.onCallBack, this.selectedCategory})
      : super(key: key);
  @override
  _SubmitCategoryState createState() => _SubmitCategoryState();
}

class _SubmitCategoryState extends State<SubmitCategory> {
  int currentIndex = -1;
  bool _isOpen = false;

  @override
  void initState() {
    if (widget.selectedCategory != null) {
      currentIndex = widget.categories
          .indexWhere((element) => element.id == widget.selectedCategory);
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
                  'category'.tr(),
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
                widget.categories.length,
                (index) => InkWell(
                      onTap: () {
                        if (currentIndex == index) {
                          currentIndex = -1;
                        } else {
                          currentIndex = index;
                        }
                        setState(() {});
                        widget.onCallBack(widget.categories[index].id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: index == currentIndex
                                ? theme.accentColor
                                : Colors.grey),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Text(
                          widget.categories[index].name,
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
