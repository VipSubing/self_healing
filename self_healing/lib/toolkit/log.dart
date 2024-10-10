import 'package:logger/logger.dart';

class CustomPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    String message = event.message;
    if (event.error != null) {
      message += '\n${event.error}';
    }
    return [message];
  }
}

log_(dynamic message) {
  var logger = Logger(
    printer: CustomPrinter(),
  );
  logger.i(message);
}

logDebug(dynamic message) {
  var logger = Logger(
    printer: CustomPrinter(),
  );
  logger.d(message);
}

logError(dynamic message) {
  var logger = Logger();
  logger.e(message);
}

logWarn(dynamic message) {
  var logger = Logger();
  logger.w(message);
}
