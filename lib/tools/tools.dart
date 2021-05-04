import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart' as intl;

import '../enums/enums.dart';

class Tools {
  static String convertSecondsToTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  static String stringBase64Encode(String credentials) {
    var stringToBase64 = utf8.fuse(base64);
    var encoded = stringToBase64.encode(credentials);
    return encoded;
  }

  static String capitalizeFirstLetter(String value) {
    if (value.trim().isEmpty) {
      return value;
    }
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String stringBase64Decode(String credentials) {
    var stringToBase64 = utf8.fuse(base64);
    var decoded = stringToBase64.decode(credentials);
    return decoded;
  }

  static bool checkEmptyString(String value) {
    if (value != null && value.trim().isNotEmpty) {
      return false;
    }
    return true;
  }

  static ImageType checkImageType(String image) {
    if (image.contains('http://') || image.contains('https://')) {
      return ImageType.url;
    }
    if (image.contains('assets')) {
      return ImageType.asset;
    }
    return ImageType.base64;
  }

  static String trimBase64Image(String image) {
    var trimImage = image.trim();
    trimImage = trimImage.replaceAll('data:image/png;base64,', '');
    trimImage = trimImage.replaceAll('data:image/jpg;base64,', '');
    trimImage = trimImage.replaceAll('data:image/jpeg;base64,', '');
    trimImage = trimImage.replaceAll('data:image/gif;base64,', '');
    return trimImage;
  }

  static String calDistance(
      double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    var distance = 12742 * asin(sqrt(a));

    if (distance >= 10.0) {
      return '>10KM';
    }

    return '${distance.toStringAsFixed(2)}KM';
  }

  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static Future<Uint8List> compressList({Uint8List list, File file}) async {
    var result;
    if (list != null) {
      result = await FlutterImageCompress.compressWithList(
        list,
        minHeight: 800,
        minWidth: 800,
        quality: 60,
        format: CompressFormat.jpeg,
      );
    } else {
      result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 800,
        quality: 60,
      );
    }

    return result;
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  static String convertCurrency(dynamic price) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return currencyFormatter.format(int.parse(price));
  }

  static int isCloseTimeGreaterThanOpenTime(String openHour, String closeHour) {
    /// If open time is after close time
    if (!openHour.contains('12:30pm')) {
      if (openHour.contains('pm') && closeHour.contains('am')) {
        return 1;
      }
    }

    /// If both time are the same, then it's considered 24 hours
    if (openHour == closeHour) {
      return 2;
    }

    if ((openHour.contains('am') && closeHour.contains('am')) ||
        ((openHour.contains('pm') && closeHour.contains('pm')))) {
      /// Compare the time
      var openH =
          openHour.replaceAll('am', '').replaceAll('pm', '').split(':')[0];
      var openM =
          openHour.replaceAll('am', '').replaceAll('pm', '').split(':')[1];

      var closeH =
          closeHour.replaceAll('am', '').replaceAll('pm', '').split(':')[0];
      var closeM =
          closeHour.replaceAll('am', '').replaceAll('pm', '').split(':')[1];

      /// Special case
      if (openHour.contains('12:00pm') || openHour.contains('12:30pm')) {
        openH = '00';
      }

      if (int.parse(openH) > int.parse(closeH)) {
        return 1;
      } else if (int.parse(openH) == int.parse(closeH)) {
        if (int.parse(openM) > int.parse(closeM)) {
          return 1;
        }
      }
    }
    return 0;
  }
}

void log(String message) {
  // ignore: avoid_print
  print('${DateTime.now()}: $message');
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
