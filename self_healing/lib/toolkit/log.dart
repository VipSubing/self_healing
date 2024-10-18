// import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// class CustomPrinter extends PrettyPrinter {
//   CustomPrinter({super.colors, super.levelColors, super.dateTimeFormat});
//   @override
//   List<String> log(LogEvent event) {
//     String message = event.message;
//     if (event.error != null) {
//       message += '\n${event.error}';
//     }
//     return [message];
//   }
// }
import 'dart:developer';

import 'package:logger/logger.dart';

class DeveloperConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final StringBuffer buffer = StringBuffer();
    event.lines.forEach(buffer.writeln);
    log(buffer.toString());
  }
}

final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      noBoxingByDefault: true,
      colors: true,
      lineLength: 50,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: MultiOutput([
      // I have a file output here
      DeveloperConsoleOutput(),
    ]),
    filter: ProductionFilter());

log_(dynamic message) {
  // var logger = Logger(
  //   printer: CustomPrinter(),
  // );
  _logger.i(message);
}

logDebug(dynamic message, {int methodCount = 1}) {
  Logger(
          printer: PrettyPrinter(
            methodCount: methodCount,
            // noBoxingByDefault: true,
            colors: true,
            lineLength: 50,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          ),
          output: MultiOutput([
            // I have a file output here
            DeveloperConsoleOutput(),
          ]),
          filter: ProductionFilter())
      .d(message);
}

logError(dynamic message) {
  _logger.e(message);
}

logWarn(dynamic message) {
  _logger.w(message);
}
