import 'package:logger/logger.dart';



Logger getLogger(String className) {
  Logger.level = Level.debug;
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  void log(Level level, message, error, StackTrace stackTrace) {
    var color = PrettyPrinter.levelColors[level];
    var emoji = PrettyPrinter.levelColors[level];
    println(color('$emoji $className - $message'));
  }


}