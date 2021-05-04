import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/common_input.dart';

class SocialMedias extends StatefulWidget {
  final List<Map<String, dynamic>> socialMedias;
  const SocialMedias({Key key, this.socialMedias}) : super(key: key);
  @override
  _SocialMediasState createState() => _SocialMediasState();
}

class _SocialMediasState extends State<SocialMedias> {
  bool _isOpen = false;
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
                  'socialMedias'.tr(),
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
          ...List.generate(
              widget.socialMedias.length,
              (index) => Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: theme.accentColor,
                                ),
                              ),
                              child: Text(
                                  widget.socialMedias[index]['displayName']),
                            )),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 3,
                          child: CommonInput(
                            hintText: widget.socialMedias[index]['displayName'],
                            controller: widget.socialMedias[index]['value'],
                          ),
                        ),
                      ],
                    ),
                  ))
      ],
    );
  }
}
