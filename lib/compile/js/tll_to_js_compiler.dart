import 'package:tll/compile/compiler_exception.dart';
import 'package:tll/compile/compiler_interface.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/expression/primitive_value.dart';

class TLLtoJSCompiler implements CompilerInterface {
  static String toJS(List<Expression> expressions) {
    String jsCode = "";
    for (int i = 0; i < expressions.length; i++) {
      Expression expression = expressions[i];
      jsCode += "\n";
      jsCode += exprToJS(expression, false);
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
        return primitiveToJS(expression, isReturned);
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
        return functionCallToJS(expression, isReturned);
      case IfExpression _:
        return ifToJS(expression, isReturned);
      case CondExpression _:
        return condToJS(expression, isReturned);
    }
  }

  static String condToJS(CondExpression cond, bool isReturned) {
    String jsCode = "";
    for (final (cond, res) in cond.condResultPairs) {
      jsCode += "if(${exprToJS(cond, false)}){\n";
      jsCode += "${toReturn(isReturned)}${exprToJS(res, false)}";
      jsCode += "}\n";
    }
    jsCode += runtimeError("no condition matched", cond.location);
    return jsCode;
  }

  static String ifToJS(IfExpression expr, bool isReturned) {
    String jsCode = "if(${exprToJS(expr.conditionExpression, false)}){\n";
    jsCode += toReturn(isReturned) + exprToJS(expr.thenExpression, false);
    jsCode += "} else {\n";
    jsCode += toReturn(isReturned) + exprToJS(expr.elseExpression, false);
    jsCode += "}\n";
    return jsCode;
  }

  static String toReturn(bool isReturned) {
    if (isReturned) {
      return "return ";
    }
    return "";
  }

  static String functionCallToJS(FunctionCallExpression func, bool isReturned) {
    return throw Exception("not yet implemented");
    String accessedFields = func.accessedNames.join(".");
    if (accessedFields != "") {
      accessedFields = ".$accessedFields";
    }
    String jsCode =
        "${toReturn(isReturned)}${func.name}$accessedFields(${func.arguments.map((it) => exprToJS(it, false)).join(",")})";
    return jsCode;
  }

  static String functionDefToJS(FunctionDefinitionExpr func) {
    String jsCode = "function ${func.name}(${func.argumentNames.join(",")}){\n";
    int length = func.body.length;
    for (int i = 0; i < length; i++) {
      final expr = func.body[i];
      if (i == length - 1) {
        jsCode += exprToJS(expr, true);
      } else {
        jsCode += exprToJS(expr, false);
      }
    }
    jsCode += "}\n";
    return jsCode;
  }

  static String primitiveToJS(PrimitiveValueExpression prim, bool isReturned) {
    PrimitiveValue value = prim.value;
    switch (value) {
      case IntValue _:
        return "${toReturn(isReturned)}${value.value}";
      case FloatValue _:
        return "${toReturn(isReturned)}${value.value}";
      case StringValue _:
        return "${toReturn(isReturned)}${value.value}";
      case BoolValue _:
        if (value.value) {
          return "${toReturn(isReturned)}true";
        } else {
          return "${toReturn(isReturned)}false";
        }
    }
  }

  static String runtimeError(String message, Location location) {
    return 'throw Error("RUNTIME-ERROR at (${location.row}, ${location.col}): $message")\n';
  }
}
