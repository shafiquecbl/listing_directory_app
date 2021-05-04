import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../entities/export.dart';
import '../../../models/item_list_screen_model.dart';

class AddLocation extends StatefulWidget {
  final Function(int) onCallBack;

  const AddLocation({Key key, this.onCallBack}) : super(key: key);
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation>
    with TickerProviderStateMixin {
  int _currentIndex = -1;
  List<Location> _locations;
  bool _isSelectingLocation = false;

  @override
  void initState() {
    _locations =
        Provider.of<ItemListScreenModel>(context, listen: false).locations;
    super.initState();
  }

  void _updateLocation(int index) {
    if (_currentIndex == index) {
      _currentIndex = -1;
      widget.onCallBack(-1);
    } else {
      _currentIndex = index;
      widget.onCallBack(_locations[_currentIndex].id);
    }

    setState(() {});
  }

  void _openLocations() {
    _isSelectingLocation = !_isSelectingLocation;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: _openLocations,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSize(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 500),
                        vsync: this,
                        child: Icon(
                          Icons.add_location,
                          size: _isSelectingLocation ? 0 : 16.0,
                        ),
                      ),
                      AnimatedSize(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 500),
                        vsync: this,
                        child: Icon(
                          Icons.clear,
                          size: _isSelectingLocation ? 16.0 : 0,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Text('Location'),
                    ],
                  )),
            ),
            AnimatedSize(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 500),
              vsync: this,
              child: Container(
                margin: const EdgeInsets.only(left: 10.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                    color: _currentIndex != -1
                        ? theme.accentColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.0)),
                child: _currentIndex != -1
                    ? Text(_locations[_currentIndex].name)
                    : const Text(''),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        if (_isSelectingLocation) ...[
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            direction: Axis.horizontal,
            children: List.generate(
                _locations.length,
                (index) => InkWell(
                      onTap: () => _updateLocation(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: _currentIndex == index
                              ? theme.accentColor
                              : Colors.grey,
                        ),
                        child: Text(_locations[index].name),
                      ),
                    )),
          ),
          const SizedBox(height: 10.0),
        ],
      ],
    );
  }
}
