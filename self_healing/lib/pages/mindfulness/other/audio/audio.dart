import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

abstract class AudioHandlerDelegate {
  Future audioServicePlay();
  Future audioServicePause();
  Future audioServiceStop();
  Future audioServiceSeek(Duration position);
  Future audioServiceSkipToNext();
  Future audioServiceSkipToPrevious();
  Future audioServiceClick();
  // audioServicePlay();
}

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  WeakReference<AudioHandlerDelegate>? player;

  static MyAudioHandler? _shared;
  static MyAudioHandler get shared {
    _shared ??= MyAudioHandler._internal();
    return _shared!;
  }

  MyAudioHandler._internal();
  resetItem(MediaItem item) {
    MyAudioHandler.shared.mediaItem.add(item);
  }

  resetAudioServiceState(
      {List<MediaControl>? controls, bool? playing, Duration? updatePosition}) {
    // All options shown:
    PlaybackState? state;
    if (controls != null) {
      state = playbackState.value.copyWith(
        // Which buttons should appear in the notification now
        controls: controls,
        // Which other actions should be enabled in the notification
        systemActions: const {
          MediaAction.seek,
        },
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState: AudioProcessingState.ready,
        // The current speed
        speed: 1.0,
        // The current queue position
        queueIndex: 0,
      );
      playbackState.add(state);
    }
    if (playing != null) {
      state = playbackState.value.copyWith(
        playing: playing,
        // Which other actions should be enabled in the notification
        systemActions: const {
          MediaAction.seek,
        },
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState: AudioProcessingState.ready,
        // The current speed
        speed: 1.0,
        // The current queue position
        queueIndex: 0,
      );
      playbackState.add(state);
    }
    if (updatePosition != null) {
      state = playbackState.value.copyWith(
        updatePosition: updatePosition,
        bufferedPosition: updatePosition,
        // Which other actions should be enabled in the notification
        systemActions: const {
          MediaAction.seek,
        },
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState: AudioProcessingState.ready,
        // The current speed
        speed: 1.0,
        // The current queue position
        queueIndex: 0,
      );
      playbackState.add(state);
    }
    // if (state != null) {

    // }
  }

  // The most common callbacks:
  @override
  Future<void> play() async {
    await player?.target?.audioServicePlay();
  }

  @override
  Future<void> pause() async {
    await player?.target?.audioServicePause();
  }

  @override
  Future<void> stop() async {
    await player?.target?.audioServiceStop();
  }

  @override
  Future<void> seek(Duration position) async {
    await player?.target?.audioServiceSeek(position);
  }

  @override
  Future<void> skipToNext() async {
    await player?.target?.audioServiceSkipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await player?.target?.audioServiceSkipToPrevious();
  }

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    if (button == MediaButton.media) {
      await player?.target?.audioServiceClick();
    } else if (button == MediaButton.next) {
      await player?.target?.audioServiceSkipToNext();
    } else if (button == MediaButton.previous) {
      await player?.target?.audioServiceSkipToPrevious();
    }
  }
}

Future<MyAudioHandler> initAudioService() async {
  // store this in a singleton
  return await AudioService.init<MyAudioHandler>(
    builder: () {
      return MyAudioHandler.shared;
    },
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.healing.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}
