import 'package:test/test.dart';
import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/type/type.dart';

void main() {
  test("builds a struct type", () {
    String code = """
(struct Person 
  int age
)
      """;
    List<TokenGroup> groups = Collector.findExpressions(code);
    List<Expression> expressions = ExpressionBuilder.buildAllTopLevel(groups);
    expect(expressions.length, 1);
    var expression = expressions[0];
    expect(expression is StructTypeDefinitionExpr, true);
    expect(expression.location.row, 0);
    expect(expression.location.col, 1);
    TLLType structType = expression.type;
    expect(structType is TLLStructType, true);
    expect((structType as TLLStructType).name, "Person");
    expect(structType.fields.keys.length, 1);
    expect(structType.fields["age"] is TLLIntType, true);
  });
}
