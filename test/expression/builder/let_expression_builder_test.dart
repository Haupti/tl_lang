import 'package:test/test.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/let_expression_builder.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/primitive_value.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import '../../testutils/single_token_builder.dart';

void main() {
  test("builds let expression successfully", () {
    var mod = ModuleScopeContext();
    VariableDefinitionExpr expr = LetExpressionBuilder.build(
        Location(1, 2), [nameT("int"), nameT("a"), intT(123)], mod);
    expect(expr.location.row, 1);
    expect(expr.location.col, 2);
    expect(expr.type.equals(TLLIntType()), true);
    expect(expr.name, "a");
    Expression exprValue = expr.value;
    if (exprValue is! PrimitiveValueExpression) {
      fail("expected primitive value");
    }
    expect(exprValue.type.equals(TLLIntType()), true);
    expect(exprValue.value is IntValue, true);
    expect((exprValue.value as IntValue).value, 123);
  });

  test("builds let expression successfully with expression", () {
    var mod = ModuleScopeContext();
    mod.addFunction(NameToken("+", 5, 5),
        TLLFunctionType(TLLIntType(), [TLLIntType(), TLLIntType()]));
    ExpressionTokenGroup valExpr =
        ExpressionTokenGroup(nameT("+"), [intT(1), intT(2)]);
    VariableDefinitionExpr expr = LetExpressionBuilder.build(
        Location(1, 2), [nameT("int"), nameT("a"), valExpr], mod);
    expect(expr.location.row, 1);
    expect(expr.location.col, 2);
    expect(expr.type.equals(TLLIntType()), true);
    expect(expr.name, "a");
    Expression exprValue = expr.value;
    if (exprValue is! PrimitiveValueExpression) {
      fail("expected primitive value");
    }
    expect(exprValue.type.equals(TLLIntType()), true);
    expect(exprValue.value is IntValue, true);
    expect((exprValue.value as IntValue).value, 123);
  });
}
