import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
      final color = const Color.fromARGB(255, 200, 200, 200);
      return Container(
        width: width,
        height: height,
        color: verifySrc(src) ? null : (isDark ? invertColor(color) : color),
        child: verifySrc(src)
            ? Center(
                child: CachedNetworkImage(
                imageUrl: src!,
              )
                )
            : null,
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
