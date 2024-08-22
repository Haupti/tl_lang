import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
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
        type.returnType, argumentExpressions, Location.fromToken(functionName));
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

  static TLLType _toTypeOfAccessedValue(
      ObjectAccessToken token, ScopeContext context) {
    TLLType? type = context.getTypeOf(token.objectName);
    if (type == null) {
      throw ParserException.atToken(
          "'${token.objectName}' does not exist", token);
    }
    if (type is! TLLStructType) {
      throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
    }

    //accessed field might not exist in type
    TLLType? accessedFieldType = type.getTypeOfField(token.accessedName);
    if (accessedFieldType == null) {
      throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
    }

    // if we are not at struct type we cannot access fields of it
    if (accessedFieldType is! TLLStructType &&
        token.subaccessedNames.isNotEmpty) {
      throw TLLTypeError.objectDoesNotHave(
          accessedFieldType, token.subaccessedNames[0], token);
    }

    // find type of last accessed object
    TLLType resultType = accessedFieldType;
    for (final subName in token.subaccessedNames) {
      if (resultType is! TLLStructType) {
        throw TLLTypeError.objectDoesNotHave(resultType, subName, token);
      }
      TLLType? accessedFieldType = resultType.getTypeOfField(subName);
      if (accessedFieldType == null) {
        throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
      }
      resultType = accessedFieldType;
    }
    return resultType;
  }

  static Expression buildAccessedCall(ObjectAccessToken fullToken,
      List<TokenGroup> arguments, ScopeContext parentContext) {
    TLLType functionType = _toTypeOfAccessedValue(fullToken, parentContext);
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
        case ReferenceExpression _:
        case FunctionCallExpression _:
        case PrimitiveValueExpression _:
          argumentExpressions.add(_typechecked(
              actualExpression, functionType.argumentTypes[i], arguments[i]));
        default:
          throw ParserException.atTokenGroup(
              "this is not allowed here", arguments[i]);
      }
    }

    return FunctionCallExpression(functionType.returnType, argumentExpressions,
        Location.fromToken(fullToken));
  }
}
