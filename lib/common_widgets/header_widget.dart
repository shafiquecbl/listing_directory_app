import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  final String onTapTitle;
  const HeaderWidget({Key key, this.title, this.onTap, this.onTapTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.headline6,
        ),
        const Expanded(child: SizedBox(width: 1)),
        if (onTapTitle != null && onTap != null)
          InkWell(
            onTap: onTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.cardColor,
              ),
              child: Text(
                onTapTitle,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
