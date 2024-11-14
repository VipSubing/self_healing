import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/widgets/brightness/container.dart';

class MindfulnessTips extends StatelessWidget {
  MindfulnessTips({super.key, required this.tipsText, required this.onPress});
  final String tipsText;
  final void Function() onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: 70,
          padding: EdgeInsets.only(left: 20, right: 20),
          width: constraints.maxWidth,
          // padding: EdgeInsets.all(5),
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius),
          //     color: Color.fromARGB(81, 4, 239, 118)),
          child: Text(
            tipsText,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: AppTextStyle.font20,
          ),
        );
      }),
    );
  }
}
