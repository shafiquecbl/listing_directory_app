import 'package:flutter/material.dart';

class CommonInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabledInput;
  final String labelText;
  final double height;
  final bool multiLine;
  final onChanged;
  final onSubmitted;
  final TextInputType keyboardType;

  const CommonInput(
      {Key key,
      this.controller,
      this.hintText,
      this.labelText,
      this.enabledInput = true,
      this.height,
      this.multiLine = false,
      this.onChanged,
      this.onSubmitted,
      this.keyboardType = TextInputType.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: multiLine ? null : height,
      child: TextField(
        maxLines: multiLine ? null : 1,
        style: const TextStyle(fontSize: 16.0, color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor.withOpacity(0.5),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelText: labelText,
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
        ),
        onChanged: (val) => onChanged != null ? onChanged(val) : null,
        onSubmitted: (val) => onSubmitted != null ? onSubmitted(val) : null,
        enabled: enabledInput,
        controller: controller,
        keyboardType: keyboardType,
      ),
    );
  }
}
