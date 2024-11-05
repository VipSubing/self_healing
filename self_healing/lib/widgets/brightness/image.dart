import 'package:flutter/material.dart';
import 'package:self_healing/widgets/brightness/builder.dart';

class BrightnessIcon extends StatelessWidget {
  const BrightnessIcon({super.key, required this.src, this.size});
  final String src;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isBlank) {
      return Image.asset(
        width: size?.width,
        height: size?.height,
        src,
        color: (isBlank ? Colors.white : Colors.black),
        colorBlendMode: BlendMode.srcIn,
      );
    });
  }
}
