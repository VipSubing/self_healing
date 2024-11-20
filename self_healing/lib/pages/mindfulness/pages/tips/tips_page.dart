import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/pages/mindfulness/other/audio/store.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/brightness/image.dart';
import 'package:self_healing/widgets/dialog/alert.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  var list = <String>[];
  String? inputText;
  @override
  void initState() {
    list = MindfulessStore.shared.tips;
    super.initState();
  }

  onPressItem(int i) {
    showPlainAlert(
      context,
      title: "删除提醒",
      content: "是否删除这条提醒？",
      sureCallback: () {
        setState(() {
          list.removeAt(i);
        });

        MindfulessStore.shared.tips = list;
      },
    );
  }

  onPressAdd() {
    inputText = null;
    showAlert(context,
        title: const Text("添加新的提醒"),
        content: SizedBox(
          height: 180,
          child: BrightnessBuilder(builder: (context, isDark) {
            return TextField(
              onChanged: (value) => inputText = value,
              maxLength: 120,
              style: AppTextStyle.font18,
              expands: true,
              maxLines: null,
              // focusNode: node1,
              textDirection: TextDirection.ltr,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.start,

              decoration: InputDecoration(
                filled: true,
                hintText: '提醒',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(AppStyle.imgCornerRadius)),
              ),
            );
          }),
        ), sureCallback: () {
      FocusScope.of(context).unfocus();
      if (inputText != null && inputText!.length != 0) {
        setState(() {
          list.add(inputText!);
        });
        MindfulessStore.shared.tips = list;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("自我提醒")),
        actions: [
          SizedBox(
            width: 50,
            child: IconButton(
                padding: EdgeInsets.all(10),
                onPressed: onPressAdd,
                icon: BrightnessIcon(src: "assets/icons/add_icon.png")),
          ),
          SizedBox(
            width: 25,
          )
        ],
      ),
      body: SafeArea(child: BrightnessBuilder(builder: (context, isDark) {
        return Container(
          padding: EdgeInsets.only(
              top: 20,
              left: AppStyle.horizontalPadding,
              right: AppStyle.horizontalPadding),
          child: Expanded(
              child: ReorderableListView(
            children: list.mapE((model, i) {
              return _TipsItem(
                  key: ValueKey(i),
                  isLast: i == list.length - 1,
                  text: list[i],
                  isDark: isDark,
                  onPress: () => onPressItem(i));
            }),
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              setState(() {
                list.exchangeE(oldIndex, newIndex);
              });
              MindfulessStore.shared.tips = list;
            },
          )),
        );
      })),
    );
  }
}

class _TipsItem extends StatelessWidget {
  const _TipsItem(
      {super.key,
      required this.isLast,
      required this.text,
      required this.isDark,
      required this.onPress});
  final bool isLast;
  final String text;
  final bool isDark;
  final Function() onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        decoration: !isLast
            ? BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: AppStyle.borderLineColor(isDark))))
            : null,
        child: Text(
          text,
          maxLines: null,
          style: AppTextStyle.font20.weight500(),
        ),
      ),
    );
  }
}
