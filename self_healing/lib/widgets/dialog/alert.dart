import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/button.dart';

showAlert(BuildContext context,
    {required String title,
    required String content,
    required Function() sureCallback}) {
  showDialog(
      context: context,
      builder: (context) {
        return BrightnessBuilder(builder: (context, isDark) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.font20.weight600(),
            ),
            content: Text(
              content,
              style: AppTextStyle.font16,
            ),
            backgroundColor: AppStyle.background1Color(isDark),
            elevation: 24,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius)),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              MeTextButton.two(
                  onPress: () {
                    Navigator.of(context).pop('cancle');
                  },
                  title: "取消",
                  size: Size(100, 40)),
              MeTextButton.one(
                  onPress: () {
                    Navigator.of(context).pop("ok");
                    sureCallback();
                  },
                  title: "确认",
                  size: Size(100, 40)),
            ],
          );
        });
      });
}
