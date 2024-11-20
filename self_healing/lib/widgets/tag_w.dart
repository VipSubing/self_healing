import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/basic/app_style.dart';

class TagW extends StatefulWidget {
  const TagW({super.key, 
    this.padding,
    required this.text,
    this.borderRadius,
    this.textStyle,
  });

  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final String text;
  final double? borderRadius;

  @override
  State<TagW> createState() => _TagWState();
}

class _TagWState extends State<TagW> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //添加观察者
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //添加观察者
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // final brightness =
    //     WidgetsBinding.instance.platformDispatcher.platformBrightness;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: widget.padding != null
          ? widget.padding!
          : const EdgeInsets.fromLTRB(5, 2, 5, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              widget.borderRadius != null ? widget.borderRadius! : 4),
          color:
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                      Brightness.dark
                  ? const Color.fromARGB(255, 63, 63, 63)
                  : const Color.fromARGB(31, 66, 66, 66)),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
        style:
            widget.textStyle ?? AppTextStyle.font12,
      ),
    );
  }
}
