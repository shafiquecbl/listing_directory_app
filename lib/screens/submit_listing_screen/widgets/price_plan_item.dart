import 'package:flutter/material.dart';

class PricePlanItem extends StatelessWidget {
  final bool isCheck;
  final String title;

  const PricePlanItem({Key key, this.isCheck = false, @required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isCheck
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                )
              : const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }
}
