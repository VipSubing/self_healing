import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

class MindfulnessInfoW extends StatefulWidget {
  const MindfulnessInfoW(
      {super.key, this.cover,
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
                // color: Colors.black38,
                ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _textW(context, widget.name, widget.time, widget.tag),
              LoveWidget(
                width: 40,
                height: 40,
                isLoved: widget.isLoved,
                onPress: widget.loveCallback,
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
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: AppTextStyle.font18.weight700(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              time,
              style: AppTextStyle.font14,
            ),
            const SizedBox(
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
