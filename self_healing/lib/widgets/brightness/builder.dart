import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class BrightnessBuilder extends StatefulWidget {
  const BrightnessBuilder({super.key, required this.builder});
  final Widget Function(BuildContext context , bool isDark) builder;
  @override
  State<BrightnessBuilder> createState() => _BrightnessBuilderState();
}

class _BrightnessBuilderState extends State<BrightnessBuilder>
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
    return widget.builder(context,WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark);
  }
}
