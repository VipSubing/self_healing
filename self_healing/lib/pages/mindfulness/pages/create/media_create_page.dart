import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/pages/create/media_create_controller.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:self_healing/widgets/brightness/builder.dart';
import 'package:self_healing/widgets/brightness/container.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaCreatePage extends GetView<MediaCreateController> {
  MediaCreatePage({super.key}) {
    Get.delete<MediaCreateController>();
    Get.put(MediaCreateController());
  }

  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  onCommit() async {
    unfoucs();
    SmartDialog.showLoading();
    try {
      var url = await controller.upload();
      log_("onCommit suc :$url");
      SmartDialog.dismiss();
      SmartDialog.showNotify(msg: "操作成功", notifyType: NotifyType.success);
      Get.back();
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showNotify(msg: "操作失败", notifyType: NotifyType.failure);
    }
  }

  onMediaPicker() async {
    unfoucs();
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      final res = await controller.setMedia(file.path);
      if (!res) {
        SmartDialog.showToast("音频格式错误或者其他");
      }
    } else {
      // User canceled the picker
    }
  }

  onCoverPicker() async {
    unfoucs();
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.image,
      ),
    );
    if (result != null && result.length > 0) {
      controller.coverSrc.value = (await result.first.file)?.path;
    }
  }

  unfoucs() {
    node1.unfocus();
    node2.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        unfoucs();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("创建作品"),
        ),
        body: LayoutBuilder(builder: (context, constrains) {
          logDebug(
              "max : ${constrains.maxHeight} , min : ${constrains.minHeight}");
          return SafeArea(
              child: Container(
            padding: EdgeInsets.only(
                left: AppStyle.horizontalPadding,
                right: AppStyle.horizontalPadding),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "名称",
                        style: AppTextStyle.font16.weight600(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextField(
                        onChanged: (value) => controller.name.value = value,
                        maxLength: 40,
                        focusNode: node1,
                        textDirection: TextDirection.ltr,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: '正念静坐-20分钟',
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  AppStyle.imgCornerRadius)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return _MediaAddWidget(
                          isEmpty: controller.duration.value == null,
                          durationText:
                              formatMinutes(controller.duration.value ?? 0),
                          onTap: onMediaPicker,
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "类型",
                        style: AppTextStyle.font16.weight600(),
                      ),
                      BrightnessBuilder(builder: (context, isDark) {
                        return Obx(() {
                          return Wrap(
                            spacing: 10,
                            children: MindfulnessMediaType.values
                                .map((item) => ChoiceChip(
                                    selected:
                                        controller.type.value == item.name,
                                    onSelected: (_) {
                                      controller.type.value = item.name;
                                    },
                                    label: Text(item.name),
                                    selectedColor: AppStyle.themeColor,
                                    backgroundColor:
                                        AppStyle.background1Color(isDark)))
                                .toList(),
                          );
                        });
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        return _CoverAddWidget(
                          isEmpty: controller.coverSrc.value == null,
                          onTap: onCoverPicker,
                          src: controller.coverSrc.value,
                        );
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "详情描述(可选)",
                        style: AppTextStyle.font16.weight600(),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        height: 180,
                        child: TextField(
                          onChanged: (value) => controller.description.value,
                          maxLength: 500,
                          focusNode: node2,
                          expands: true,
                          maxLines: null,
                          // minLines: 1,
                          textDirection: TextDirection.ltr,
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: '描述',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(
                                    AppStyle.imgCornerRadius)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: -(MediaQuery.of(context).size.height -
                        constrains.maxHeight -
                        120),
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      return ElevatedButton(
                          onPressed:
                              controller.isCommitEnable.value ? onCommit : null,
                          child: Text("提交"));
                    }))
              ],
            ),
          ));
        }),
      ),
    );
  }
}

class _MediaAddWidget extends StatelessWidget {
  const _MediaAddWidget(
      {super.key,
      this.durationText,
      required this.isEmpty,
      required this.onTap});
  final bool isEmpty;
  final String? durationText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isDark) {
      return GestureDetector(
        onTap: onTap,
        child: BrightnessContainer(
          height: 70,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  width: 1, color: AppStyle.borderLineColor(isDark))),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text("音频"),
              SizedBox(
                height: 5,
              ),
              isEmpty ? Icon(Icons.add) : Text(durationText ?? "")
            ],
          ),
        ),
      );
    });
  }
}

class _CoverAddWidget extends StatelessWidget {
  const _CoverAddWidget(
      {super.key, this.src, required this.isEmpty, required this.onTap});
  final bool isEmpty;
  final String? src;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, isDark) {
      return GestureDetector(
        onTap: onTap,
        child: BrightnessContainer(
          height: 160,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  width: 1, color: AppStyle.borderLineColor(isDark))),
          child: isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("封面(可选)"),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(Icons.add)
                  ],
                )
              : Image.file(
                  File(src!),
                  fit: BoxFit.cover,
                ),
        ),
      );
    });
  }
}
