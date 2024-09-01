import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/utils/token_utils.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_mismatch_exception.dart';

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
        case ValueReferenceExpression _:
        case FunctionCallExpression _:
        case PrimitiveValueExpression _:
          argumentExpressions.add(_typechecked(
              argumentExpression, type.argumentTypes[i], arguments[i]));
        default:
          throw ParserException.atTokenGroup("unexpected token", arguments[i]);
      }
    }

    return FunctionCallExpression(type.returnType, functionName.value, [],
        argumentExpressions, Location.fromToken(functionName));
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

  static Expression buildAccessedCall(ObjectAccessToken fullToken,
      List<TokenGroup> arguments, ScopeContext parentContext) {
    TLLType functionType =
        TokenUtils.toTypeOfAccessedValue(fullToken, parentContext);
    if (functionType is! TLLFunctionType) {
      throw TLLTypeError.expectedAType(functionType, "function", fullToken);
    }
    if (arguments.length != functionType.argumentTypes.length) {
      throw TLLTypeError.withMessage(
          "expected ${functionType.argumentTypes.length} arguments but got ${arguments.length}",
          fullToken);
    }

    List<Expression> argumentExpressions = [];
    for (int i = 0; i < arguments.length; i++) {
      Expression actualExpression =
          ExpressionBuilder.buildOne(arguments[i], parentContext);
      switch (actualExpression) {
        case ValueReferenceExpression _:
        case FunctionCallExpression _:
        case PrimitiveValueExpression _:
          argumentExpressions.add(_typechecked(
              actualExpression, functionType.argumentTypes[i], arguments[i]));
        default:
          throw ParserException.atTokenGroup(
              "this is not allowed here", arguments[i]);
      }
    }

    List<String> accessedFields = [fullToken.accessedName];
    accessedFields.addAll(fullToken.subaccessedNames);
    return FunctionCallExpression(functionType.returnType, fullToken.objectName,
        accessedFields, argumentExpressions, Location.fromToken(fullToken));
  }
}
