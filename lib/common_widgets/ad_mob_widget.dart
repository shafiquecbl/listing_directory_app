import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import '../configs/admob_config.dart';
import '../configs/app_config.dart';

class AdMobWidget extends StatefulWidget {
  @override
  _AdMobWidgetState createState() => _AdMobWidgetState();
}

class _AdMobWidgetState extends State<AdMobWidget> {
  var _adUnitID;

  var _controller;

  double _height = 0;

  StreamSubscription _subscription;

  @override
  void initState() {
    if (!AppConfig.webPlatform && AppConfig.enableAdMob) {
      _adUnitID = AdMobConfigs.nativeAdUnitId;
      _controller = NativeAdmobController();
      _subscription = _controller.stateChanged.listen(_onStateChanged);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (!AppConfig.webPlatform && AppConfig.enableAdMob) {
      _subscription.cancel();
      _controller.dispose();
    }

    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = AdMobConfigs.adDefaultHeight;
        });
        break;
      case AdLoadState.loadError:
        setState(() {
          _height = 0;
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.enableAdMob) {
      return Container();
    }
    if (AppConfig.webPlatform) {
      return Container(
        height: 100,
        color: Colors.white,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.orange,
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'Ad',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ),
                  const Expanded(child: SizedBox(width: 1)),
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 14.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      'CONTACT US',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Expanded(
                    child: Text(
                      'Mino Paw - Flutter App For Listing Pro theme',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        maxHeight: _height,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          Expanded(
            child: NativeAdmob(
              adUnitID: _adUnitID,
              controller: _controller,
              type: NativeAdmobType.banner,
              loading: Container(),
            ),
          ),
        ],
      ),
    );
  }
}
