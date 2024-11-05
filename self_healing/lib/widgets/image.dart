import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/widgets/brightness/builder.dart';

class NetImage extends StatelessWidget {
  const NetImage({super.key, required this.src, this.width, this.height});
  final double? width;
  final double? height;
  final String? src;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BrightnessBuilder(builder: (context, isDark) {
      final color = Color.fromARGB(255, 200, 200, 200);
      return Container(
        width: width,
        height: height,
        color: isDark ? invertColor(color) : color,
        child: verifySrc(src) ? Image.network(src!, fit: BoxFit.contain) : null,
      );
    });
  }

  bool verifySrc(String? src) {
    if (src == null) {
      return false;
    }
    if (!src.startsWith("http")) {
      return false;
    }
    return true;
  }
}