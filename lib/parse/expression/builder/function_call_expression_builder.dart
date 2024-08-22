import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/expression/type_mismatch_exception.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class FunctionCallExpressionBuilder {
  static Expression build(NameToken functionName, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    TLLFunctionType type = _functionTypeOf(functionName, parentContext);
    if (type.argumentTypes.length != arguments.length) {
      throw ParserException.atToken(
          "'$functionName' expects ${type.argumentTypes.length} arguments but got ${arguments.length}",
          functionName);
    }
    List<Expression> argumentExpressions = [];
    for (int i = 0; i < type.argumentTypes.length; i++) {
      Expression argumentExpression =
          ExpressionBuilder.buildOne(arguments[i], parentContext);
      switch (argumentExpression) {
        case ReferenceExpression _:
        case FunctionCallExpression _:
        case PrimitiveValueExpression _:
          argumentExpressions.add(_typechecked(
              argumentExpression, type.argumentTypes[i], arguments[i]));
        default:
          throw ParserException.atTokenGroup(
              "this is not allowed here", arguments[i]);
      }
    }

    return FunctionCallExpression(
        type.returnType, Location.fromToken(functionName));
  }

  static Expression _typechecked(
      Expression actual, TLLType expected, TokenGroup at) {
    if (actual.type.suffices(expected)) {
      return actual;
    } else {
      throw TLLTypeError.atTokenGroup(actual.type, expected, at);
    }
  }

  static TLLFunctionType _functionTypeOf(
      NameToken name, ScopeContext parentContext) {
    TLLType? type = parentContext.getTypeOf(name.value);
    if (type == null) {
      throw ParserException.atToken("'${name.value}' is not in scope", name);
    }
    if (type is! TLLFunctionType) {
      throw ParserException.atToken("'${name.value}' is not a funciton", name);
    }
    return type;
  }

  static Expression buildAccessedCall(
      Token fullToken,
      String objectName,
      String accessedName,
      List<String> subaccessedNames,
      List<TokenGroup> arguments,
      ScopeContext parentContext) {
    throw Exception("not yet implemented");
  }
}
