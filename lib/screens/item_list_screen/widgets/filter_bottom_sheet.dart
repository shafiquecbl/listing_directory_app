import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../entities/category.dart';
import '../../../entities/features.dart';
import '../../../entities/location.dart';

enum Option { feature, category, location }

class FilterBottomSheet extends StatefulWidget {
  final List<Category> categories;
  final List<Location> locations;
  final List<Feature> features;
  final Map<String, dynamic> options;
  final Function updateOption;
  const FilterBottomSheet(
      {Key key,
      this.categories,
      this.locations,
      this.features,
      this.updateOption,
      this.options})
      : super(key: key);

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  Map<String, List<int>> filterOptions = {};
  Option currentOption = Option.category;
  @override
  void initState() {
    super.initState();
    widget.options.forEach((key, value) {
      filterOptions[key] = [];
      filterOptions[key].addAll(value);
    });
  }

  void _updateOption(Option option, dynamic selectedObject) {
    switch (option) {
      case Option.category:
        if (filterOptions['selectedCategories'].contains(selectedObject)) {
          filterOptions['selectedCategories'].remove(selectedObject);
        } else {
          filterOptions['selectedCategories'].add(selectedObject);
        }
        break;
      case Option.location:
        if (filterOptions['selectedLocations'].contains(selectedObject)) {
          filterOptions['selectedLocations'].remove(selectedObject);
        } else {
          filterOptions['selectedLocations'].add(selectedObject);
        }
        break;
      case Option.feature:
        if (filterOptions['selectedFeatures'].contains(selectedObject)) {
          filterOptions['selectedFeatures'].remove(selectedObject);
        } else {
          filterOptions['selectedFeatures'].add(selectedObject);
        }
        break;
    }
    setState(() {});
  }

  void clearOption() {
    filterOptions = {
      'selectedCategories': [],
      'selectedLocations': [],
      'selectedFeatures': [],
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 350.0,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: theme.canvasColor.withOpacity(0.8),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5.0),
                  InkWell(
                      onTap: clearOption,
                      child: Text(
                        'reset'.tr(),
                        style: theme.textTheme.subtitle1,
                      )),
                  const Expanded(child: SizedBox(width: 1)),
                  InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'cancel'.tr(),
                        style: theme.textTheme.subtitle1,
                      )),
                  const SizedBox(width: 5.0),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => currentOption = Option.category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: theme.accentColor),
                                  color: currentOption == Option.category
                                      ? theme.accentColor.withOpacity(0.8)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0))),
                              child: Text(
                                'category'.tr(),
                                style: theme.textTheme.headline6,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                setState(() => currentOption = Option.feature),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: theme.accentColor),
                                  color: currentOption == Option.feature
                                      ? theme.accentColor.withOpacity(0.8)
                                      : Colors.transparent),
                              child: Text(
                                'features'.tr(),
                                style: theme.textTheme.headline6,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                setState(() => currentOption = Option.location),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.accentColor),
                                color: currentOption == Option.location
                                    ? theme.accentColor.withOpacity(0.8)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                'location'.tr(),
                                style: theme.textTheme.headline6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      if (currentOption == Option.location)
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: List.generate(
                        //     widget.locations.length,
                        //     (index) => Row(
                        //       children: [
                        //         Text(widget.locations[index].name),
                        //         const Expanded(child: SizedBox(width: 1)),
                        //         SizedBox(
                        //           width: 30.0,
                        //           height: 30.0,
                        //           child: Checkbox(
                        //             value: filterOptions['selectedLocations']
                        //                 .contains(widget.locations[index].id),
                        //             onChanged: (val) => _updateOption(
                        //                 Option.location,
                        //                 widget.locations[index].id),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: Wrap(
                            children: List.generate(
                              widget.locations.length,
                              (index) {
                                return InkWell(
                                  onTap: () => _updateOption(Option.location,
                                      widget.locations[index].id),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      margin: const EdgeInsets.only(
                                          right: 5.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color:
                                              filterOptions['selectedLocations']
                                                      .contains(widget
                                                          .locations[index].id)
                                                  ? theme.buttonColor
                                                  : Colors.transparent),
                                      child: Text(
                                        widget.locations[index].name,
                                        style: theme.textTheme.bodyText1,
                                      )),
                                );
                              },
                            ),
                          ),
                        ),
                      if (currentOption == Option.feature)
                        Center(
                          child: Wrap(
                            children: List.generate(
                              widget.features.length,
                              (index) {
                                return InkWell(
                                  onTap: () => _updateOption(Option.feature,
                                      widget.features[index].id),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      margin: const EdgeInsets.only(
                                          right: 5.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color:
                                              filterOptions['selectedFeatures']
                                                      .contains(widget
                                                          .features[index].id)
                                                  ? theme.buttonColor
                                                  : Colors.transparent),
                                      child: Text(
                                        widget.features[index].name,
                                        style: theme.textTheme.bodyText1,
                                      )),
                                );
                              },
                            ),
                          ),
                        ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: List.generate(
                      //     widget.features.length,
                      //     (index) => Row(
                      //       children: [
                      //         Text(widget.features[index].name),
                      //         const Expanded(child: SizedBox(width: 1)),
                      //         SizedBox(
                      //           width: 30.0,
                      //           height: 30.0,
                      //           child: Checkbox(
                      //             value: filterOptions['selectedFeatures']
                      //                 .contains(widget.features[index].id),
                      //             onChanged: (val) => _updateOption(
                      //                 Option.feature,
                      //                 widget.features[index].id),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      if (currentOption == Option.category)
                        Center(
                          child: Wrap(
                            children: List.generate(
                              widget.categories.length,
                              (index) {
                                return InkWell(
                                  onTap: () => _updateOption(Option.category,
                                      widget.categories[index].id),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      margin: const EdgeInsets.only(
                                          right: 5.0, bottom: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: filterOptions[
                                                      'selectedCategories']
                                                  .contains(widget
                                                      .categories[index].id)
                                              ? theme.buttonColor
                                              : Colors.transparent),
                                      child: Text(
                                        widget.categories[index].name,
                                        style: theme.textTheme.bodyText1,
                                      )),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: theme.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.updateOption(filterOptions);
              },
              child: const Text('apply').tr(),
            ),
          ),
        ],
      ),
    );
  }
}
