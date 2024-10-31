import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:self_healing/basic/app_style.dart';

class BrightnessContainer extends StatefulWidget {
  const BrightnessContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.decoration = const BoxDecoration(),
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxDecoration decoration;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final Widget? child;

  @override
  State<BrightnessContainer> createState() => BrightnessContainerState();
}

class BrightnessContainerState extends State<BrightnessContainer>
    with WidgetsBindingObserver {
  late Container container;

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
    final decoration = widget.decoration.copyWith(
        color: widget.decoration.color ??
            (AppStyle.background1Color(
                WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                    Brightness.dark)));
    container = Container(
      key: widget.key,
      alignment: widget.alignment,
      padding: widget.padding,
      color: widget.color,
      decoration: decoration,
      foregroundDecoration: widget.foregroundDecoration,
      width: widget.width,
      height: widget.height,
      constraints: widget.constraints,
      margin: widget.margin,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
    return container;
  }
}
