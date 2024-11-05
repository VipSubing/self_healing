import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/widgets/brightness/builder.dart';

class LoveWidget extends StatelessWidget {
  const LoveWidget(
      {super.key,
      required this.isLoved,
      required this.onPress,
      this.width,
      this.height});
  final bool isLoved;
  final Function(bool) onPress;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 40,
      height: height ?? 40,
      child: ElevatedButton(
        onPressed: () => onPress(isLoved),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: BrightnessBuilder(builder: (context, isBlank) {
          return Image.asset(
            // width: 20,
            // height: 20,
            "assets/icons/love_icon.png",
            color: isLoved
                ? Colors.red
                : (isBlank ? Colors.white : Color.fromARGB(255, 154, 154, 154)),
            colorBlendMode: BlendMode.srcIn,
          );
        }),
      ),
    );
  }
}
