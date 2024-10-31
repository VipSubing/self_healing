import 'package:audioplayers/audioplayers.dart';
import 'package:self_healing/basic/app_prefference.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:tuple/tuple.dart';

abstract class MindfulnessMediaControllerDelegate {
  /// 准备播放
  void mediaControllerPreparePlay(String src);
}

class MindfulnessMediaController extends GetxController {
  final MindfulnessMediaControllerDelegate delegate;

  final audioPlayer = AudioPlayer();

  late Rx<_MediaMode> mode;

  var isPlaying = false.obs;

  List<String> playList = [];
  // 已经播放过的
  List<String> playedList = [];

  var secs = 0;
  var totalSecs = 0;

  var forceUpdate = 0.obs;

  @override
  void dispose() {
    audioPlayer.dispose();
    log_("MindfulnessMediaController dispose");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  onClose() {
    audioPlayer.dispose();
    log_("MindfulnessMediaController onClose");
    super.onClose();
  }

  MindfulnessMediaController({
    required this.delegate,
  }) {
    mode = _MediaMode.fromRaw(AppPrefference.shared.playerMode).obs;

    audioPlayer.onDurationChanged.listen((Duration d) {
      setupTotalSecs(d.inSeconds);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setupSecs(p.inSeconds);
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

  mediaSetup({
    int secs_ = 0,
    required String src,
    bool autoPlay = true,
  }) async {
    secs = secs_;
    redrawSlider();
    playHistory(src);

    await audioPlayer.setSourceUrl(src);
    await audioPlayer.seek(Duration(seconds: secs));
    if (autoPlay) {
      audioPlayer.resume();
    } else {
      if (audioPlayer.state == PlayerState.playing) {
        audioPlayer.pause();
      }
    }
  }

  setupPlayList(List<String> playList_) {
    playList = playList_;
  }

  playNext(String curSrc) {
    log_("playNext curSrc :${curSrc}");
    String? nextMedia;
    switch (mode.value) {
      case _MediaMode.one:
        // 播完即停
        break;
      case _MediaMode.perOne:
        // 一直播
        nextMedia = curSrc;
        break;
      case _MediaMode.circulation:
        // 循环
        if (playList.isEmpty) {
          nextMedia = curSrc;
        } else {
          int index = -1;
          for (var i = 0; i < playList.length; i++) {
            if (playList[i] == curSrc) {
              index = i + 1;
              break;
            }
          }
          if (index == -1) {
            index = 0;
          } else if (index >= playList.length) {
            index = 0;
          }
          nextMedia = playList[index];
        }
        break;
      case _MediaMode.random:
        // 随机循环

        if (playList.isEmpty) {
          nextMedia = curSrc;
        } else if (playList.length == 1) {
          nextMedia = playList.first;
        } else {
          var notPlayedList = [];
          for (var i = 0; i < playList.length; i++) {
            if (!playedList.contains(playList[i])) {
              notPlayedList.add(playList[i]);
            }
          }
          if (notPlayedList.isEmpty) {
            logDebug("notPlayedList isEmpty ");
            // 都播放完了
            // 清空历史
            playedList = [];
            // 把未播放列表填满
            notPlayedList = List.from(playList).where((item) {
              return item != curSrc;
            }).toList();
          }
          final random = Random();
          int randomNumber = random.nextInt(notPlayedList.length);
          logDebug(
              "notPlayedList : $notPlayedList ,randomNumber :$randomNumber");
          nextMedia = notPlayedList[randomNumber];
        }
        break;

      default:
        break;
    }
    if (nextMedia != null) {
      mediaSetup(secs_: 0, src: nextMedia);
      delegate.mediaControllerPreparePlay(nextMedia);
    }
  }

  playHistory(String src) {
    if (playedList.length == 30) {
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
  setupVal(double destinationVal) {
    // 更新player
    secs = (destinationVal / 100.0 * totalSecs).toInt();
    // logDebug("setupVal secs: ${formatSeconds(secs)}");
    audioPlayer.seek(Duration(seconds: secs));
  }

  // 播放器进度回调
  setupSecs(int secs_) {
    secs = secs_;
    redrawSlider();
  }

  setupTotalSecs(int secs_) {
    totalSecs = secs_;
    redrawSlider();
  }

  // 更新Slider
  redrawSlider() {
    forceUpdate.value = 1 + forceUpdate.value;
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
