import 'dart:io';

import 'package:tll/compile/compiler.dart';
import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';

void compile(String sourceFilename, String outFilename) {
  String content = File(sourceFilename).readAsStringSync();
  List<TokenGroup> groups = Collector.findExpressions(content);
  List<Expression> expressions = ExpressionBuilder.buildAllTopLevel(groups);
  String jsCode = Compiler.toJS(expressions);
  File(outFilename).writeAsStringSync(jsCode);
}
