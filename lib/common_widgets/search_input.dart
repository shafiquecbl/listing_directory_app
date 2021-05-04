import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Function onClear;
  final FocusNode focusNode;
  final String hintText;
  final bool enabledInput;
  final bool autoFocus;
  final int maxLines;
  final double height;
  const SearchInput(
      {Key key,
      this.height = 40.0,
      this.controller,
      this.onChanged,
      this.onSubmitted,
      this.onClear,
      this.focusNode,
      this.hintText,
      this.enabledInput = false,
      this.autoFocus = false,
      this.maxLines = 1})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: autoFocus,
              maxLines: maxLines,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).cardColor.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                hintText: hintText ?? 'searchForSomething'.tr(),
                hintStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: controller != null &&
                        controller?.text != '' &&
                        onClear != null
                    ? InkWell(
                        onTap: onClear,
                        child: const Icon(Icons.clear),
                      )
                    : Container(
                        width: 24,
                      ),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
              enabled: enabledInput,
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
