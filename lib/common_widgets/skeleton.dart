import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_model.dart';

class Skeleton extends StatefulWidget {
  final double height;
  final double width;
  final double cornerRadius;

  Skeleton({
    Key key,
    this.height = 20,
    this.width = 200,
    this.cornerRadius = 4,
  }) : super(key: key);

  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(
        () {
          setState(() {});
        },
      );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        Provider.of<AppModel>(context, listen: false).isDarkTheme;
    var colors = isDarkTheme
        ? [
            const Color(0xFF696969),
            const Color(0x1A000000),
            const Color(0xFF696969)
          ]
        : [
            const Color(0x0D000000),
            const Color(0x1A000000),
            const Color(0x0D000000)
          ];
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        gradient: LinearGradient(
          begin: Alignment(gradientPosition.value, 0),
          end: const Alignment(-1, 0),
          colors: colors,
        ),
      ),
    );
  }
}
