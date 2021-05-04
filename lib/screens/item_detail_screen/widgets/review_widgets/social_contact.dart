import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../enums/enums.dart';

class SocialContact extends StatelessWidget {
  final IconData icon;
  final String value;
  final SocialType type;

  const SocialContact(
      {Key key, @required this.icon, @required this.value, @required this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void _launchURL() async {
      var _url;
      switch (type) {
        case SocialType.email:
          {
            final _emailLaunchUri = Uri(
                scheme: 'mailto',
                path: '$value',
                queryParameters: {'subject': 'Query about: '});
            _url = _emailLaunchUri.toString();
            break;
          }
        case SocialType.phone:
          {
            _url = 'tel:${value.trim()}';
            break;
          }
        case SocialType.facebook:
          {
            _url = value;
            await launch(_url, forceWebView: false);
            return;
          }
        case SocialType.whatsApp:
          {
            if (Platform.isAndroid) {
              _url = 'https://wa.me/$value/?text=';
            } else {
              _url = 'https://api.whatsapp.com/send?phone=$value='; //
            }
            break;
          }
        case SocialType.twitter:
        case SocialType.url:
        case SocialType.linkedIn:
        case SocialType.youtube:
        case SocialType.instagram:
          {
            _url = value;
            break;
          }
      }

      if (_url != null) {
        if (await canLaunch(_url)) {
          await launch(_url);
        } else {
          throw 'Could not launch $_url';
        }
      }
    }

    return InkWell(
      onTap: _launchURL,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          children: [
            Icon(
              icon,
              color: theme.accentColor,
            ),
            const SizedBox(width: 10.0),
            Flexible(
              child: Text(
                value,
                style: theme.textTheme.bodyText2.copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
