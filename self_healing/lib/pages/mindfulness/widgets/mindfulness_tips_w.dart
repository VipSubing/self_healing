import 'dart:math';

import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/pages/mindfulness/other/audio/store.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MindfulnessTips extends StatefulWidget {
  const MindfulnessTips({super.key, required this.onPress});
  final void Function() onPress;

  @override
  State<MindfulnessTips> createState() => _MindfulnessTipsState();
}

class _MindfulnessTipsState extends State<MindfulnessTips> {
  late String text = MindfulessStore.shared.tips.first;
  var set = <int>{};
  @override
  void initState() {
    text = getRandomText();
    super.initState();
  }

  String getRandomText() {
    if (MindfulessStore.shared.tips.length > 0) {
      int index = randomIndex();
      log_("randomIndex $index");
      return MindfulessStore.shared.tips[index];
    }
    return "";
  }

  int randomIndex() {
    if (set.length == MindfulessStore.shared.tips.length) {
      set.clear();
    }
    var random = Random();
    int randomNumber = random.nextInt(MindfulessStore.shared.tips.length);
    if (set.contains(randomNumber)) {
      return randomIndex();
    }
    set.add(randomNumber);
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 20, right: 20),
          width: constraints.maxWidth,
          child: VisibilityDetector(
            key: const ValueKey("MindfulnessTips"),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 1.0) {
                setState(() {
                  text = getRandomText();
                });
              }
            },
            child: Text(
              text,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: AppTextStyle.font20,
            ),
          ),
        );
      }),
    );
  }
}
