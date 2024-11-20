import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/button.dart';

showPlainAlert(BuildContext context,
    {required String title,
    required String content,
    required Function() sureCallback}) {
  showAlert(context,
      title: Text(
        title,
        // textAlign: TextAlign.center,
        style: AppTextStyle.font24.weight600(),
      ),
      content: Text(
        content,
        style: AppTextStyle.font18,
      ),
      sureCallback: sureCallback);
}

showAlert(BuildContext context,
    {Widget? title, Widget? content, required Function() sureCallback}) {
  showDialog(
      context: context,
      builder: (context) {
        return BrightnessBuilder(builder: (context, isDark) {
          return AlertDialog(
            title: title,
            content: SizedBox(
                width: MediaQuery.of(context).size.width - 50, child: content),
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
                  size: const Size(120, 54)),
              MeTextButton.one(
                  onPress: () {
                    Navigator.of(context).pop("ok");
                    sureCallback();
                  },
                  title: "确认",
                  size: const Size(120, 54)),
            ],
          );
        });
      });
}
