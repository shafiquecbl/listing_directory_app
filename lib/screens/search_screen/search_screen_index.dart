import 'package:flutter/material.dart';

import 'search_screen_v1.dart';
import 'search_screen_v2.dart';

class SearchScreenIndex extends StatelessWidget {
  final String version;

  SearchScreenIndex({@required this.version});
  @override
  Widget build(BuildContext context) {
    if (version == 'v2') {
      return SearchScreenV2();
    }

    /// Default v1
    return SearchScreenV1();
  }
}
