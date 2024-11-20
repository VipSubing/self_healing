import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/widgets/brightness/builder.dart';

class SelectedButton extends StatelessWidget {
  const SelectedButton(
      {super.key,
      required this.isSelected,
      required this.child,
      this.onPressed});

  final bool isSelected;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isDark) {
      return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              textStyle: AppTextStyle.font16,
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark
                      ? const Color.fromARGB(255, 22, 22, 22)
                      : const Color.fromARGB(255, 233, 233, 233))),
          child: child);
    });
  }
}

class MeTextButton extends StatelessWidget {
  // const MeTextButton(
  //     {super.key,
  //     required this.onPress,
  //     required this.title,
  //     required this.child,
  //     required this.size,
  //     this.cornerRadius});

  final Function() onPress;
  final String title;
  final Size size;
  final double? cornerRadius;
  final Color backgroundColor;
  final Color color;
  final TextStyle? textStyle;

  const MeTextButton.one(
      {super.key,
      required this.onPress,
      required this.title,
      required this.size,
      this.cornerRadius,
      this.textStyle})
      : backgroundColor = Colors.black,
        color = Colors.white;

  MeTextButton.two(
      {super.key,
      required this.onPress,
      required this.title,
      required this.size,
      this.cornerRadius,
      this.textStyle})
      : backgroundColor = const Color.fromARGB(255, 233, 233, 233),
        color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isDark) {
      return SizedBox(
        width: size.width,
        height: size.height,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
              Radius.circular(cornerRadius ?? AppStyle.btnCornerRadius)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? invertColor(backgroundColor) : backgroundColor),
              onPressed: onPress,
              child: Text(
                title,
                style: textStyle ??
                    AppTextStyle.font16
                        .weight600()
                        .copyWith(color: isDark ? invertColor(color) : color),
              )),
        ),
      );
    });
  }
}
