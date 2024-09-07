import 'dart:io';

import 'package:tll/compile/js/tll_to_js_compiler.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/parser.dart';

void compile(String sourceFilename, String outFilename) {
  String content = File(sourceFilename).readAsStringSync();
  List<Expression> expressions = TLLParser.parse(content);
  String jsCode = TLLtoJSCompiler.toJS(expressions);
  File(outFilename).writeAsStringSync(jsCode);
}
