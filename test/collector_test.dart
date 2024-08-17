import 'package:test/test.dart';
import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';

void main() {
  test('finds groups', () {
    List<ExpressionTokenGroup> expressions = Collector.findExpressions("(let mut opt int 1)");
    expect(expressions.length, 1);
    expect(expressions[0].first.token.show, "name:let");
    expect(expressions[0].arguments.length, 4);
    expect(expressions[0].arguments[0] is SingleTokenGroup, true);
    expect(expressions[0].arguments[1] is SingleTokenGroup, true);
    expect(expressions[0].arguments[2] is SingleTokenGroup, true);
    expect(expressions[0].arguments[3] is SingleTokenGroup, true);
    SingleTokenGroup firstArg = expressions[0].arguments[0] as SingleTokenGroup;
    SingleTokenGroup secondArg = expressions[0].arguments[1] as SingleTokenGroup;
    SingleTokenGroup thirdArg= expressions[0].arguments[2] as SingleTokenGroup;
    SingleTokenGroup fourthArg= expressions[0].arguments[3] as SingleTokenGroup;
    expect(firstArg.token.show, "keyword:mut");
    expect(secondArg.token.show, "keyword:opt");
    expect(thirdArg.token.show, "name:int");
    expect(fourthArg.token.show, "int:1");
  });
}
