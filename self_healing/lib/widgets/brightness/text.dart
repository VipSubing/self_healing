import 'package:flutter/material.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/widgets/brightness/builder.dart';

class BrightnessText extends StatelessWidget {
  BrightnessText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    required this.color,
    this.darkColor,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final Color color;
  final Color? darkColor;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isDark) {
      final _darkColor = darkColor ?? invertColor(color);
      var _style = style ?? TextStyle(color: isDark ? _darkColor : color);

      return Text(
        data,
        style: _style,
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
      );
    });
  }
}
