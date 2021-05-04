import 'package:flutter/material.dart';

import '../../../common_widgets/common_input.dart';

class ListingInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool multiLine;
  final bool enable;
  final TextInputType keyboardType;
  const ListingInput({
    Key key,
    this.controller,
    this.labelText,
    this.hintText,
    this.multiLine = false,
    this.enable = true,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            labelText,
            style:
                theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 8.0),
        CommonInput(
          controller: controller,
          hintText: hintText ?? labelText,
          height: 40.0,
          multiLine: multiLine,
          enabledInput: enable,
          keyboardType: keyboardType,
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
