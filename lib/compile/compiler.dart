import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/primitive_value.dart';

class Compiler {
  static String toJS(List<Expression> expressions) {
    String jsCode = "";
    for (final expression in expressions) {
      jsCode += "\n";
      jsCode += exprToJS(expression);
    }
    return jsCode;
  }

  static String exprToJS(Expression expression) {
    switch (expression) {
      case ConstantDefinitionExpr _:
        return "const ${expression.name} = ${exprToJS(expression.value)};";
      case PrimitiveValueExpression _:
        return primitiveToJS(expression);
      default:
        throw Exception("not yet implemented");
    }
  }

  static String primitiveToJS(PrimitiveValueExpression prim) {
    PrimitiveValue value = prim.value;
    switch (value) {
      case IntValue _:
        return "${value.value}";
      case FloatValue _:
        return "${value.value}";
      case StringValue _:
        return "'${value.value}'";
      case BoolValue _:
        if (value.value) {
          return "true";
        } else {
          return "false";
        }
    }
  }
}
