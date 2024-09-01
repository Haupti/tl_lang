import 'package:tll/main.dart';

final String defaultOutName = "test/resources/index.js";
final String testSrcName = "test/resources/main.tll";

void main(List<String> arguments) {
  compile(testSrcName, defaultOutName);
}
