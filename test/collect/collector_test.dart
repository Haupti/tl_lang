import 'package:test/test.dart';
import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';

import '../testutils/token_group_extensions.dart';

void main() {
  test('finds groups', () {
    List<ExpressionTokenGroup> expressions =
        Collector.findExpressions("(let int a 1)");
    expect(expressions.length, 1);
    ExpressionTokenGroup expr = expressions[0];

    expect(expr.first.token.show, "keyword:let");
    expect(expr.first.token.row, 0);
    expect(expr.first.token.col, 1);
    expect(expr.arguments.length, 3);

    TokenGroup fst = expr.arguments[0];
    TokenGroup snd = expr.arguments[1];
    TokenGroup trd = expr.arguments[2];
    if (fst is! SingleTokenGroup) {
      fail("expected single token");
    }
    if (snd is! SingleTokenGroup) {
      fail("expected single token");
    }
    if (trd is! SingleTokenGroup) {
      fail("expected single token");
    }
    expect(fst.token.show, "name:int");
    expect(fst.token.row, 0);
    expect(fst.token.col, 5);

    expect(snd.token.show, "name:a");
    expect(snd.token.row, 0);
    expect(snd.token.col, 9);

    expect(trd.token.show, "int:1");
    expect(trd.token.row, 0);
    expect(trd.token.col, 11);
  });
  test('finds groups with nested expression', () {
    List<ExpressionTokenGroup> expressions =
        Collector.findExpressions("(let int b\n(+ 1 2))");
    expect(expressions.length, 1);
    ExpressionTokenGroup expr = expressions[0];

    expect(expr.first.token.show, "keyword:let");
    expect(expr.first.token.row, 0);
    expect(expr.first.token.col, 1);
    expect(expr.arguments.length, 3);

    TokenGroup fst = expr.arguments[0];
    TokenGroup snd = expr.arguments[1];
    TokenGroup trd = expr.arguments[2];
    if (fst is! SingleTokenGroup) {
      fail("expected single token");
    }
    if (snd is! SingleTokenGroup) {
      fail("expected single token");
    }
    expect(fst.token.show, "name:int");
    expect(fst.token.row, 0);
    expect(fst.token.col, 5);

    expect(snd.token.show, "name:b");
    expect(snd.token.row, 0);
    expect(snd.token.col, 9);

    if (trd is! ExpressionTokenGroup) {
      fail("expected expression group");
    }
    expect(trd.first.token.show, "name:+");
    expect(trd.first.token.row, 1);
    expect(trd.first.token.col, 1);
    expect(trd.arguments.length, 2);
    TokenGroup trdfst = trd.arguments[0];
    TokenGroup trdsnd = trd.arguments[1];
    if (trdfst is! SingleTokenGroup) {
      fail("expected single token");
    }
    if (trdsnd is! SingleTokenGroup) {
      fail("expected single token");
    }
    expect(trdfst.token.show, "int:1");
    expect(trdfst.token.row, 1);
    expect(trdfst.token.col, 3);

    expect(trdsnd.token.show, "int:2");
    expect(trdsnd.token.row, 1);
    expect(trdsnd.token.col, 5);
  });
  test('finds groups with nested expressions and multiple expression', () {
    List<ExpressionTokenGroup> expressions = Collector.findExpressions(
        "(let int a (+ 1 2))\n(defun (int int string) (dosomestuff a b) (str (+ a b)))");
    expect(expressions.map((it) => it.show()).toList(), [
      "(keyword:let name:int name:a (name:+ int:1 int:2))",
      "(keyword:defun (name:int name:int name:string) (name:dosomestuff name:a name:b) (name:str (name:+ name:a name:b)))"
    ]);
  });
}
