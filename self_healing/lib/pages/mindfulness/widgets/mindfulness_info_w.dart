import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/widgets/tag_w.dart';

class MindfulnessInfoW extends StatefulWidget {
  MindfulnessInfoW(
      {this.cover,
      required this.name,
      required this.time,
      required this.tag,
      required this.isLoved,
      required this.loveCallback});
  final String? cover;
  final String name;
  final String time;
  final String tag;
  final bool isLoved;
  final Function(bool) loveCallback;

  @override
  State<MindfulnessInfoW> createState() => _MindfulnessInfoWState();
}

class _MindfulnessInfoWState extends State<MindfulnessInfoW>
    with WidgetsBindingObserver {
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
    return Container(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              color: Colors.black38,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _textW(context, widget.name, widget.time, widget.tag),
              Container(
                width: 40,
                height: 40,
                child: ElevatedButton(
                  onPressed: null,
                  child: Image.asset(
                    "assets/icons/love_icon.png",
                    width: 35,
                    height: 35,
                    color: widget.isLoved
                        ? Colors.red
                        : (WidgetsBinding.instance.platformDispatcher
                                    .platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _textW(BuildContext context, String name, String time, String tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTextStyle.font18.weight700(),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              time,
              style: AppTextStyle.font14,
            ),
            SizedBox(
              width: 10,
            ),
            TagW(
              text: tag,
            )
          ],
        )
      ],
    );
  }
}
