import 'package:flutter/material.dart';

import '../../../entities/listing.dart';

class DiscoverItemV1 extends StatelessWidget {
  final Listing listing;
  final String text;
  final Function onTap;
  const DiscoverItemV1({Key key, this.listing, this.text, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 50,
        margin: const EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Text(text),
      ),
    );
  }
}
