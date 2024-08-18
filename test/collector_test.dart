import 'package:test/test.dart';
import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';

import 'testextension/token_group_extensions.dart';

void main() {
  test('finds groups', () {
    List<ExpressionTokenGroup> expressions =
        Collector.findExpressions("(let mut opt int 1)");
    expect(expressions.length, 1);
    expect(expressions[0].first.token.show, "name:let");
    expect(expressions[0].arguments.length, 4);
    expect(expressions[0].arguments[0] is SingleTokenGroup, true);
    expect(expressions[0].arguments[1] is SingleTokenGroup, true);
    expect(expressions[0].arguments[2] is SingleTokenGroup, true);
    expect(expressions[0].arguments[3] is SingleTokenGroup, true);
    SingleTokenGroup firstArg = expressions[0].arguments[0] as SingleTokenGroup;
    SingleTokenGroup secondArg =
        expressions[0].arguments[1] as SingleTokenGroup;
    SingleTokenGroup thirdArg = expressions[0].arguments[2] as SingleTokenGroup;
    SingleTokenGroup fourthArg =
        expressions[0].arguments[3] as SingleTokenGroup;
    expect(firstArg.token.show, "keyword:mut");
    expect(secondArg.token.show, "keyword:opt");
    expect(thirdArg.token.show, "name:int");
    expect(fourthArg.token.show, "int:1");
  });
  test('finds groups with nested expressions', () {
    List<ExpressionTokenGroup> expressions =
        Collector.findExpressions("(let mut opt int (+ 1 2))");
    expect(expressions.length, 1);
    expect(expressions[0].first.token.show, "name:let");
    expect(expressions[0].arguments.length, 4);
    expect(expressions[0].arguments[0] is SingleTokenGroup, true);
    expect(expressions[0].arguments[1] is SingleTokenGroup, true);
    expect(expressions[0].arguments[2] is SingleTokenGroup, true);
    expect(expressions[0].arguments[3] is ExpressionTokenGroup, true);
    SingleTokenGroup firstArg = expressions[0].arguments[0] as SingleTokenGroup;
    SingleTokenGroup secondArg =
        expressions[0].arguments[1] as SingleTokenGroup;
    SingleTokenGroup thirdArg = expressions[0].arguments[2] as SingleTokenGroup;
    ExpressionTokenGroup fourthArg =
        expressions[0].arguments[3] as ExpressionTokenGroup;
    expect(firstArg.token.show, "keyword:mut");
    expect(secondArg.token.show, "keyword:opt");
    expect(thirdArg.token.show, "name:int");
    expect(fourthArg.first.token.show, "name:+");
    expect((fourthArg.arguments[0] as SingleTokenGroup).token.show, "int:1");
    expect((fourthArg.arguments[1] as SingleTokenGroup).token.show, "int:2");
  });
  test('finds groups with nested expressions and multiple expression', () {
    List<ExpressionTokenGroup> expressions = Collector.findExpressions(
        "(let mut opt int (+ 1 2))\n(defun (int int string) (a b) (str (+ a b)))");
    expect(expressions.map((it) => it.show()).toList(), [
      "(name:let keyword:mut keyword:opt name:int (name:+ int:1 int:2))",
      "(name:defun (name:int name:int name:string) (name:a name:b) (name:str (name:+ name:a name:b)))"
    ]);
  });
}
