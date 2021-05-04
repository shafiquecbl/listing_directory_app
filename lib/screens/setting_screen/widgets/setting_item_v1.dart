import 'package:flutter/material.dart';

class SettingItemV1 extends StatelessWidget {
  final Function onTap;
  final String title;
  final bool switchValue;
  final IconData icon;

  const SettingItemV1(
      {Key key, this.onTap, this.title, this.switchValue, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            if (switchValue != null)
              SizedBox(
                height: 20.0,
                child: Switch(
                  value: switchValue,
                  onChanged: (val) => onTap(),
                  inactiveTrackColor: Colors.black38,
                ),
              ),
            if (switchValue == null)
              Padding(
                padding: EdgeInsets.only(
                    right: Directionality.of(context) == TextDirection.rtl
                        ? 0.0
                        : 10.0,
                    left: Directionality.of(context) == TextDirection.rtl
                        ? 10.0
                        : 0.0),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_back_ios_sharp
                      : Icons.arrow_forward_ios_sharp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
