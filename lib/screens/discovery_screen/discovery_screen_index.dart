import 'package:flutter/material.dart';

import 'discovery_screen_v1.dart';
import 'discovery_screen_v2.dart';

class DiscoveryScreenIndex extends StatelessWidget {
  final String version;

  const DiscoveryScreenIndex({Key key, this.version}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (version == 'v1') {
      return DiscoveryScreenV1();
    }

    /// Default v2
    return DiscoveryScreenV2();
  }
}
