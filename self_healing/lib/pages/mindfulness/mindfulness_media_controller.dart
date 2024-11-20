import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:self_healing/pages/mindfulness/models/mindfulness_media_model.dart';
import 'package:self_healing/pages/mindfulness/other/audio/audio.dart';
import 'package:self_healing/pages/mindfulness/other/audio/store.dart';
import 'package:self_healing/toolkit/log.dart';

abstract class MindfulnessMediaControllerDelegate {
  /// 准备播放
  void mediaControllerPreparePlay(String src);
  MindfulnessMediaModel? mediaControllerGetName(String src);
}

class MindfulnessMediaController implements AudioHandlerDelegate {
  final MindfulnessMediaControllerDelegate delegate;
  final store = MindfulessStore.shared;
  final audioPlayer = AudioPlayer();

  late Rx<_MediaMode> mode;

  var isPlaying = false.obs;

  List<String> playList = [];
  // 已经播放过的
  List<String> playedList = [];

  var secs = 0.obs;
  var totalSecs = 0.obs;

  Object? exception;
  MindfulnessMediaModel? media;

  CacheManager cacheManager = CacheManager(
    Config(
      "mindfulnessMedia",
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
    ),
  );

  MindfulnessMediaController({
    required this.delegate,
  }) {
    mode = _MediaMode.fromRaw(store.playerMode).obs;
    MyAudioHandler.shared.player = WeakReference(this);
    audioPlayer.onDurationChanged.listen((Duration d) {
      setupTotalSecs(d.inSeconds);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setupSecs(p.inSeconds);
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      isPlaying.value = s == PlayerState.playing;
      MyAudioHandler.shared.resetAudioServiceState(playing: isPlaying.value);

      if (s == PlayerState.completed) {
        playNext();
      }
    });
    audioPlayer.onPlayerComplete.listen((_) {
      log_("audioPlayer 播放完成");
    });

    audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  disposeAudio() {
    audioPlayer.dispose();
  }

  Future mediaSetup({
    int secs_ = 0,
    required String src,
    bool autoPlay = true,
  }) async {
    log_("play audio src:$src");
    // await audioPlayer.stop();

    secs.trigger(secs_);

    playHistory(src);
    delegate.mediaControllerPreparePlay(src);

    media = delegate.mediaControllerGetName(src);

    var item = MediaItem(
      id: "id$src",
      title: media?.name ?? "",
      duration: const Duration(seconds: 0),
      artUri: media?.cover != null ? Uri.parse(media!.cover!) : null,
    );

    MyAudioHandler.shared.resetItem(item);
    // MyAudioHandler.shared.playMediaItem(item);

    MyAudioHandler.shared
        .resetAudioServiceState(playing: false, controls: _getControls());

    await setSource(src);

    await audioPlayer.seek(Duration(seconds: secs.value));
    if (autoPlay) {
      await audioPlayer.resume();
    } else {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
      }
    }
  }

  Future setSource(String url) async {
    try {
      var file = await cacheManager.getSingleFile(url);
      await audioPlayer.setSourceDeviceFile(file.path);
      exception = null;
    } catch (e) {
      exception = e;
    }
  }

  setupPlayList(List<String> playList_) {
    playList = playList_;
  }

  Future playPrevious() async {
    if (playedList.length >= 2 && playList.length >= 2) {
      String src = playedList[playedList.length - 2];
      if (playList.contains(src)) {
        await mediaSetup(src: src);
      }
    }
  }

  Future playNext() async {
    String curSrc = playedList.last;
    log_("playNext curSrc :$curSrc");
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
      await mediaSetup(secs_: 0, src: nextMedia);
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
    store.playerMode = mode.value.raw;

    MyAudioHandler.shared.resetAudioServiceState(controls: _getControls());
  }

  Future setupPlay(bool play) async {
    if (play) {
      if (exception != null) {
        await setSource(playedList.last);
      }
      await audioPlayer.resume();
    } else {
      await audioPlayer.pause();
    }
  }

  // slider进度回调
  Future setupVal(double destinationVal) async {
    // 更新player
    secs.value = (destinationVal / 100.0 * totalSecs.value).toInt();
    // logDebug("setupVal secs: ${formatSeconds(secs)}");
    await audioPlayer.seek(Duration(seconds: secs.value));
  }

  // 播放器进度回调
  setupSecs(int secs_) {
    MyAudioHandler.shared
        .resetAudioServiceState(updatePosition: Duration(seconds: secs_));
    secs.trigger(secs_);
  }

  // 设置时长
  setupTotalSecs(int secs_) {
    var item = MediaItem(
      id: "id${playedList.last}",
      title: media?.name ?? "",
      duration: Duration(seconds: secs_),
      artUri: media?.cover != null ? Uri.parse(media!.cover!) : null,
    );

    MyAudioHandler.shared.resetItem(item);
    totalSecs.trigger(secs_);
  }

  /* 
    AudioHandlerDelegate
   */
  @override
  Future audioServicePause() async {
    await setupPlay(false);
  }

  @override
  Future audioServicePlay() async {
    await setupPlay(true);
  }

  @override
  Future audioServiceSeek(Duration position) async {
    if (totalSecs <= 0) {
      return;
    }
    double val = position.inSeconds / totalSecs.value * 100;
    await setupVal(val);
  }

  @override
  Future audioServiceStop() async {}
  @override
  Future audioServiceSkipToNext() async {
    return await playNext();
  }

  @override
  Future audioServiceSkipToPrevious() async {
    return await playPrevious();
  }

  @override
  Future audioServiceClick() async {
    setupPlay(!isPlaying.value);
  }

  /* 
    private
   */
  List<MediaControl> _getControls() {
    if (mode.value == _MediaMode.one || mode.value == _MediaMode.perOne) {
      return [MediaControl.pause, MediaControl.play];
    }
    if (mode.value == _MediaMode.circulation ||
        mode.value == _MediaMode.random && playList.length > 1) {
      return [
        MediaControl.pause,
        MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.skipToPrevious
      ];
    }
    return [MediaControl.pause, MediaControl.play];
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
