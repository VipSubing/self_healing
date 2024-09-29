import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/basic/app_style.dart';

class SelectedButton extends StatelessWidget {
  SelectedButton(
      {super.key,
      required this.isSelected,
      required this.child,
      this.onPressed});

  final bool isSelected;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, 
        style: ElevatedButton.styleFrom(
            textStyle: AppTextStyle.font16,
            backgroundColor: isSelected
                ? Theme.of(context).primaryColor
                : (Theme.of(context).brightness == Brightness.dark
                    ? Color.fromARGB(255, 22, 22, 22)
                    : Color.fromARGB(255, 233, 233, 233))),
        child: child);
  }
}
