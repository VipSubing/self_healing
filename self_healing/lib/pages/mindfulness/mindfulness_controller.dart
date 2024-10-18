import 'dart:math';

import 'package:get/get.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:audioplayers/audioplayers.dart';

class MindfulnessController extends GetxController {
  MindfulnessController() {
    media = MindfulnessMediaModel(
            name: "正念Sample",
            duration: 3200,
            type: MindfulnessMediaType.breathe,
            src:
                "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-45.mp3")
        .obs;
    mediaController = MindfulnessMediaController(mediaListCallback: () {
      return mediaList.value;
    }, currentMediaCallback: () {
      return media.value;
    }, playCallback: (next) {
      media.value = next;
    });
    mediaController.mediaSetup(src: media.value.src, autoPlay: false);
  }
  late Rx<MindfulnessMediaModel> media;
  Rx<List<MindfulnessMediaModel>> mediaList = Rx<List<MindfulnessMediaModel>>([
    MindfulnessMediaModel(
        name: "正念Sample1",
        duration: 3200,
        type: MindfulnessMediaType.breathe,
        src:
            "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-45.mp3"),
    MindfulnessMediaModel(
        name: "正念Sample2",
        duration: 3200,
        type: MindfulnessMediaType.breathe,
        src:
            "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/jz-10.mp3"),
    MindfulnessMediaModel(
        name: "正念Sample3",
        duration: 3200,
        type: MindfulnessMediaType.breathe,
        src:
            "https://public-1-1309961435.cos.ap-chengdu.myqcloud.com/mbct/audios/brahmcentre/stsm-10.mp4")
  ]);
  late MindfulnessMediaController mediaController;
  //
  setup(MindfulnessMediaModel media_) {
    if (media_.src == media.value.src) {
      return;
    }
    media.value = media_;
    mediaController.mediaSetup(src: media_.src);
  }
}

class MindfulnessMediaController extends GetxController {
  final audioPlayer = AudioPlayer();
  final List<MindfulnessMediaModel> Function() mediaListCallback;
  final MindfulnessMediaModel Function() currentMediaCallback;
  final Function(MindfulnessMediaModel) playCallback;
  late Rx<_MediaMode> mode;

  var isPlaying = false.obs;

  // 已经播放过的
  List<String> playedList = [];
  /* Slider相关 */
  var _secs = 0;
  var _totalSecs = 0;

  var sliderVal = 0.0.obs;
  int playerSecs = 0;
  var timeText1 = "".obs;
  var timeText2 = "".obs;
  var isSliderDragging = false;

  @override
  onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  MindfulnessMediaController(
      {required this.mediaListCallback,
      required this.playCallback,
      required this.currentMediaCallback}) {
    mode = _MediaMode.fromRaw(AppPrefference.shared.playerMode).obs;

    audioPlayer.onDurationChanged.listen((Duration d) {
      redrawSlider(totalSecs: d.inSeconds);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      redrawSlider(secs: p.inSeconds);
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      isPlaying.value = s == PlayerState.playing;
      if (s == PlayerState.completed) {
        playNext(playedList.last);
      }
    });
    audioPlayer.onPlayerComplete.listen((_) {
      log_("audioPlayer 播放完成");
    });

    audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  mediaSetup({int secs_ = 0, required String src, bool autoPlay = true}) async {
    playerSecs = secs_;
    // isPlaying.value = false;
    redrawSlider(val: 0, secs: secs_, totalSecs: 0);
    playHistory(src);

    await audioPlayer.setSourceUrl(src);
    await audioPlayer.seek(Duration(seconds: _secs));
    if (autoPlay) {
      audioPlayer.resume();
    }
  }

  playNext(String curSrc) {
    log_("playNext curSrc :${curSrc}");
    MindfulnessMediaModel? nextMedia;
    switch (mode.value) {
      case _MediaMode.one:
        // 播完即停
        break;
      case _MediaMode.perOne:
        // 一直播
        nextMedia = currentMediaCallback();
        break;
      case _MediaMode.circulation:
        // 循环
        final list = mediaListCallback();
        if (list.isEmpty) {
          nextMedia = currentMediaCallback();
        } else {
          int index = -1;
          for (var i = 0; i < list.length; i++) {
            if (list[i].src == curSrc) {
              index = i + 1;
              break;
            }
          }
          if (index == -1) {
            index = 0;
          } else if (index == list.length - 1) {
            index = 0;
          }
          nextMedia = list[index];
        }
        break;
      case _MediaMode.random:
        // 随机循环
        final list = mediaListCallback();
        if (list.isEmpty) {
          nextMedia = currentMediaCallback();
        } else {
          var notPlayedList = [];
          for (var i = 0; i < list.length; i++) {
            if (!playedList.contains(list[i].src)) {
              notPlayedList.add(list[i]);
            }
          }
          if (notPlayedList.isEmpty) {
            // 都播放完了
            nextMedia = list.first;
          } else {
            final random = Random();
            int randomNumber = random.nextInt(notPlayedList.length);
            nextMedia = notPlayedList[randomNumber];
          }
        }
        break;

      default:
        break;
    }
    if (nextMedia != null) {
      mediaSetup(secs_: 0, src: nextMedia.src);
    }
  }

  playHistory(String src) {
    if (playedList.length == 10) {
      playedList.removeAt(0);
    }
    playedList.add(src);
  }

  /* ui */
  setupMode(int modeRaw) {
    mode.value = _MediaMode.fromRaw(modeRaw).nextMode();
    AppPrefference.shared.playerMode = mode.value.raw;
  }

  setupPlay(bool isPlaying_) {
    if (!isPlaying_) {
      audioPlayer.resume();
    } else {
      audioPlayer.pause();
    }
  }

  // slider进度回调
  setupVal({double? realTimeVal, double? destinationVal}) {
    late double val;
    if (realTimeVal != null) {
      // slider滑动中
      isSliderDragging = true;
      val = realTimeVal;
    } else if (destinationVal != null) {
//slider 滑动结果
      isSliderDragging = false;
      val = destinationVal;
      // 更新player
      playerSecs = (destinationVal / 100.0 * _totalSecs).toInt();
      audioPlayer.seek(Duration(seconds: playerSecs));
    }

    redrawSlider(val: val);
  }

  // 播放器进度回调
  setupSecs(int secs_) {
    playerSecs = secs_;
    // 拖动中不能更新UI
    if (!isSliderDragging) {
      redrawSlider(secs: secs_);
    }
  }

  // 更新Slider
  redrawSlider({double? val, int? secs, int? totalSecs}) {
    _secs = secs ?? _secs;
    _totalSecs = totalSecs ?? _totalSecs;
    if (val != null) {
      sliderVal.value = val;
      _secs = (sliderVal / 100.0 * _totalSecs).toInt();
    } else {
      sliderVal.value = (_secs / _totalSecs) * 100;
    }
    timeText1.value = formatSeconds(_secs);
    timeText2.value = formatSeconds(_totalSecs);
  }
}

enum _MediaMode {
  one(raw: 0), //播完停
  perOne(raw: 1), // 单曲循环
  circulation(raw: 2), // 循环
  random(raw: 3), // 随机
  ;

  final int raw;

  const _MediaMode({required this.raw});
  static _MediaMode fromRaw(int raw) {
    switch (raw) {
      case 0:
        return _MediaMode.one;
      case 1:
        return _MediaMode.perOne;
      case 2:
        return _MediaMode.circulation;
      case 3:
        return _MediaMode.random;
      default:
        return _MediaMode.one;
    }
  }

  _MediaMode nextMode() {
    _MediaMode mode = _MediaMode.one;
    switch (this) {
      case _MediaMode.one:
        mode = _MediaMode.perOne;
        break;
      case _MediaMode.perOne:
        mode = _MediaMode.circulation;
        break;
      case _MediaMode.circulation:
        mode = _MediaMode.random;
        break;
      case _MediaMode.random:
        mode = _MediaMode.one;
        break;
      default:
        break;
    }
    return mode;
  }
}
