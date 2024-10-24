import 'dart:core';
import 'package:flutter/material.dart';
import 'package:self_healing/basic/app_style.dart';
import 'package:self_healing/basic/globals.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:tuple/tuple.dart';

abstract class MindfulnessControlWDelegate {
  void mediaControlModeOnCallback(int currentMode);
  void mediaControlPlayOnCallback(bool currentPlaying);
  void mediaControlListOnCallback();
  void mediaControlSliderValOnCallback(double destinationVal);
}

class MindfulnessControlW extends StatelessWidget {
  MindfulnessControlW({
    super.key,
    required this.secs,
    required this.totalSecs,
    required this.mode,
    required this.playing,
    required this.delegate,
  });

  int secs;
  int totalSecs;
  // 0:播完停   1: 单曲循环  2: 循环  3:随机
  final int mode;
  // 0: 播放 1:暂停
  final bool playing;

  MindfulnessControlWDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SliderW(
          secs: secs,
          totalSecs: totalSecs,
          callback: delegate.mediaControlSliderValOnCallback,
        ),
        SizedBox(
          height: 20,
        ),
        _ButtonsBoardW(
          mode: mode,
          playing: playing,
          onListCallback: delegate.mediaControlListOnCallback,
          onModeCallback: delegate.mediaControlModeOnCallback,
          onPlayCallback: delegate.mediaControlPlayOnCallback,
        ),
      ],
    );
  }
}

class _ButtonsBoardW extends StatefulWidget {
  _ButtonsBoardW(
      {required this.mode,
      required this.playing,
      required this.onPlayCallback,
      required this.onListCallback,
      required this.onModeCallback});
  // 0: 单曲  1: 循环  2:随机
  final int mode;
  // 0: 播放 1:暂停
  final bool playing;
  final Function(int) onModeCallback;
  final Function(bool) onPlayCallback;
  final Function() onListCallback;

  @override
  State<_ButtonsBoardW> createState() => _ButtonsBoardWState();
}

class _ButtonsBoardWState extends State<_ButtonsBoardW>
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

  String _playModeIconString(int mode) {
    String icon = "";
    switch (mode) {
      case 0:
        icon = "assets/icons/player_mode_1_icon.png";
        break;
      case 1:
        icon = "assets/icons/player_mode_circulation_1_icon.png";
        break;
      case 2:
        icon = "assets/icons/player_mode_circulation_icon.png";
        break;
      case 3:
        icon = "assets/icons/player_mode_random_icon.png";
        break;

      default:
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        children: [
          _playerBtnW(
              icon: _playModeIconString(widget.mode),
              onPress: () {
                widget.onModeCallback(widget.mode);
              },
              size: Size(25, 25),
              padding: EdgeInsets.all(15)),

          Spacer(),
          // _playerBtnW(
          //     icon: "assets/icons/player_previous_icon.png",
          //     onPress: null,
          //     size: Size(20, 20),
          //     padding: EdgeInsets.all(15)),
          // SizedBox(
          //   width: 20,
          // ),
          _playerBtnW(
              icon: !widget.playing
                  ? "assets/icons/player_play_icon.png"
                  : "assets/icons/player_pause_icon.png",
              onPress: () => widget.onPlayCallback(widget.playing),
              size: Size(55, 55),
              padding: EdgeInsets.all(0)),
          // SizedBox(
          //   width: 20,
          // ),
          // _playerBtnW(
          //     icon: "assets/icons/player_next_icon.png",
          //     size: Size(20, 20),
          //     padding: EdgeInsets.all(15)),
          Spacer(),
          _playerBtnW(
              icon: "assets/icons/player_list_icon.png",
              onPress: widget.onListCallback,
              size: Size(40, 40))
        ],
      ),
    );
  }

  Widget _playerBtnW(
      {required String icon,
      Function()? onPress,
      required Size size,
      EdgeInsets? padding}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: padding ?? EdgeInsets.all(5),
        child: Image.asset(
          icon,
          width: size.width,
          height: size.height,
          color:
              WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black, //目标颜色
          colorBlendMode: BlendMode.srcIn, //颜色混合模式
        ),
      ),
    );
  }
}

class _SliderW extends StatefulWidget {
  _SliderW(
      {super.key,
      required this.callback,
      required this.secs,
      required this.totalSecs});
  int secs;
  int totalSecs;

  final void Function(double destinationVal) callback;

  @override
  State<_SliderW> createState() => _SliderWState();
}

class _SliderWState extends State<_SliderW> {
  double _val = 0.0;
  int _secs = 0;
  int _totalSecs = 0;
  bool _isDragging = false;
  int _lastDragTime = 0;

  @override
  void didUpdateWidget(_SliderW oldWidget) {
    bool shouldUpdate = true;
    if (!_isDragging) {
      if (_lastDragTime != 0) {
        final nowtime = DateTime.now().millisecondsSinceEpoch;
        // logDebug("_lastDragTime :$_lastDragTime , nowtime :$nowtime");
        if (nowtime - _lastDragTime >= 1000) {
          _lastDragTime = 0;
        } else {
          shouldUpdate = false;
        }
      }
    } else {
      shouldUpdate = false;
    }
    if (shouldUpdate) {
      setState(() {
        _secs = widget.secs;
        _totalSecs = widget.totalSecs;
        if (_totalSecs < 0) {
          _totalSecs = 0;
        }
        if (_secs > _totalSecs) {
          _secs = _totalSecs;
        }
        if (_secs < 0) {
          _secs = 0;
        }
        _val = _totalSecs == 0 ? 0 : (_secs / _totalSecs) * 100;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 1, // 轨道高度
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 10, // 滑块外圈大小
              ),
            ),
            child: Slider(
              value: _val,
              min: 0,
              max: 100,
              onChanged: (val) {
                
                if (_totalSecs > 0) {
                  setState(() {
                    _val = val;
                    _secs = (val / 100.0 * _totalSecs).toInt();
                  });
                }
              },
              onChangeStart: (value) {
                _isDragging = true;
              },
              onChangeEnd: (value) {
                
                _isDragging = false;
                _lastDragTime = DateTime.now().millisecondsSinceEpoch;
                widget.callback(value);
              },
              activeColor: Theme.of(context).primaryColor,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // width: 10,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                formatSeconds(_secs),
                style: AppTextStyle.font12,
              ),
            ),
            Container(
              // width: 10,
              padding: EdgeInsets.only(right: 10),
              child: Text(
                formatSeconds(_totalSecs),
                style: AppTextStyle.font12,
              ),
            ),
          ],
        )
      ],
    );
  }
}
