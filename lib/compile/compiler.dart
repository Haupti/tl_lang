import 'package:tll/compile/compiler_exception.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/primitive_value.dart';

class Compiler {
  static String toJS(List<Expression> expressions) {
    String jsCode = "";
    for (int i = 0; i < expressions.length; i++) {
      Expression expression = expressions[i];
      jsCode += "\n";
      bool isReturned = i == expressions.length - 1;
      jsCode += exprToJS(expression, isReturned);
    }
    return jsCode;
  }

  static String exprToJS(Expression expression, bool isReturned) {
    switch (expression) {
      case ConstantDefinitionExpr _:
        if (isReturned) {
          throw CompilerException.atExpression("expected a value", expression);
        }
        return "const ${expression.name} = ${exprToJS(expression.value, false)};";
      case PrimitiveValueExpression _:
        return primitiveToJS(expression);
      case VariableDefinitionExpr _:
        if (isReturned) {
          throw CompilerException.atExpression("expected a value", expression);
        }
        return "let ${expression.name} = ${exprToJS(expression.value, false)};";
      case FunctionDefinitionExpr _:
        if (isReturned) {
          throw CompilerException.atExpression("expected a value", expression);
        }
        return functionDefToJS(expression);
      case StructTypeDefinitionExpr _:
        return "";
      case SumTypeDefinitionExpr _:
        return "";
      case AccessedValueReferenceExpression _:
        return "${expression.objectName}.${expression.accessedField}.${expression.subaccessedFields.join(".")}";
      case ValueReferenceExpression _:
        return expression.name;
      case FunctionCallExpression _:
        return functionCallToJS(expression);
      case IfExpression _:
        return ifToJS(expression);
      case CondExpression _:
        return condToJS(expression);
    }
  }

  static String condToJS(CondExpression cond, bool isReturned) {
    String jsCode = "";
    for (final (cond, res) in cond.condResultPairs) {
      jsCode += "if(${exprToJS(cond, isReturned)}){\n";
      jsCode += "return ${exprToJS(res, false)}";
      jsCode += "}\n";
    }
    jsCode += "return null\n";
    return jsCode;
  }

  static String ifToJS(IfExpression expr) {
    String jsCode = "if(${exprToJS(expr.conditionExpression)}){\n";
    jsCode += exprToJS(expr.thenExpression);
    jsCode += "} else {\n";
    jsCode += exprToJS(expr.elseExpression);
    jsCode += "}\n";
    return jsCode;
  }

  static String functionCallToJS(FunctionCallExpression func) {
    String accessedFields = func.accessedNames.join(".");
    if (accessedFields != "") {
      accessedFields = ".$accessedFields";
    }
    String jsCode =
        "${func.name}$accessedFields(${func.arguments.map((it) => exprToJS(it)).join(",")})";
    return jsCode;
  }

  static String functionDefToJS(FunctionDefinitionExpr func) {
    String jsCode = "function ${func.name}(${func.argumentNames.join(",")}){\n";
    for (final expr in func.body) {
      jsCode += exprToJS(expr);
    }
    jsCode += "}\n";
    return jsCode;
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
