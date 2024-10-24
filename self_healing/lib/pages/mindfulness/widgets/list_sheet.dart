import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/extension/list.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/container.dart';
import 'package:self_healing/widgets/love.dart';
import 'package:self_healing/widgets/tag_w.dart';

showListSheet(
    {required BuildContext context,
    required List<MindfulnessMediaModel> models}) {
  showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (builder) => ListSheet(
            models: models,
          ));
}

class ListSheet extends StatefulWidget {
  const ListSheet({Key? key, required this.models}) : super(key: key);
  final List<MindfulnessMediaModel> models;

  @override
  _ListSheetState createState() => _ListSheetState();
}

class _ListSheetState extends State<ListSheet> {
  @override
  Widget build(BuildContext context) {
    return BrightnessContainer(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyle.cardCornerRadius)),
      height: MediaQuery.of(context).size.height / 5 * 5,
      padding: EdgeInsets.only(
          left: AppStyle.horizontalPadding,
          right: AppStyle.horizontalPadding,
          top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
              text: "当前播放列表",
              style: AppTextStyle.font18.weight600(),
            ),
            TextSpan(
              text: "(长按拖动可调整播放顺序)",
              style: AppTextStyle.font14,
            )
          ])),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ReorderableListView(
                  onReorder: (_0, _1) {},
                  itemExtent: 80,
                  onReorderStart: (index) {},
                  onReorderEnd: (index) {},
                  children: widget.models.mapE((model, i) {
                    return _ItemWidget(
                      key: Key(model.src),
                      model: model,
                      onPress: (_) {},
                    );
                  }).toList()))
        ],
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({Key? key, required this.model, required this.onPress})
      : super(key: key);
  final MindfulnessMediaModel model;
  final Function(MindfulnessMediaModel) onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppStyle.imgCornerSmallRadius),
              child:
                  Image.asset("assets/imgs/guide_1.jpeg", fit: BoxFit.contain)),
          SizedBox(
            width: 10,
          ),
          _textW(context, "name", "time", "tag", model.isPlaying),
          Spacer(),
          LoveWidget(
            width: 30,
            height: 30,
            isLoved: model.isCollected,
            onPress: (isLoved) {
              log_("list on loved :$isLoved");
            },
          ),
          SizedBox(
            width: 30,
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: model.isPlaying
                ? Image.asset(
                    "assets/icons/player_playing_icon.png",
                    fit: BoxFit.contain,
                  )
                : null,
          )
        ],
      ),
    );
  }
  /*[
          ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppStyle.imgCornerSmallRadius),
              child:
                  Image.asset("assets/imgs/guide_1.jpeg", fit: BoxFit.contain)),
          SizedBox(
            width: 10,
          ),
          _textW(context, "name", "time", "tag", model.isPlaying),
          Spacer(),
          LoveWidget(
            width: 30,
            height: 30,
            isLoved: model.isCollected,
            onPress: (isLoved) {
              log_("list on loved :$isLoved");
            },
          ),
          SizedBox(
            width: 30,
          ),
          SizedBox(
            height: 20,
            width: 20,
            child: model.isPlaying
                ? Image.asset(
                    "assets/icons/player_playing_icon.png",
                    fit: BoxFit.contain,
                  )
                : null,
          )
        ]*/

  Widget _textW(BuildContext context, String name, String time, String tag,
      bool isSelected) {
    final color = isSelected ? Theme.of(context).primaryColor : null;
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyle.font20.copyWith(color: color),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                time,
                style: AppTextStyle.font14.copyWith(color: color),
              ),
              SizedBox(
                width: 10,
              ),
              TagW(
                text: tag,
                textStyle: TextStyle(color: color),
              )
            ],
          )
        ],
      ),
    );
  }
}
