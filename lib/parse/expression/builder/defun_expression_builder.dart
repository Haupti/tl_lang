import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_mismatch_exception.dart';

class DefunExpressionBuilder {
  static Expression build(DefunToken start, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    if (arguments.length < 3) {
      throw ParserException.atToken("malformed function definition", start);
    }

    TokenGroup typesGroup = arguments[0];
    switch (typesGroup) {
      case SingleTokenGroup _:
        throw ParserException.atToken(
            "expected a list of types here", typesGroup.token);
      case ExpressionTokenGroup _:
        break;
    }

    TLLType returnType = _findReturnType(typesGroup, parentContext);
    List<TLLType> argumentTypes = _findArgumentTypes(typesGroup, parentContext);

    var (functionNameToken, argumentNames) =
        _findFunctionNameAndArgumentNames(arguments[1]);

    FunctionScopeContext myContext = FunctionScopeContext(parentContext);
    if (argumentNames.length != argumentTypes.length) {
      throw ParserException.at("argument types and arguments do not add up",
          Location(arguments[1].row, arguments[1].col));
    }
    for (int i = 0; i < argumentNames.length; i++) {
      myContext.addParam(argumentNames[i], argumentTypes[i]);
    }

    List<Expression> body =
        _findBody(arguments.sublist(2), returnType, myContext);

    TLLFunctionType functionType = TLLFunctionType(returnType, argumentTypes);
    FunctionDefinitionExpr definitionExpression = FunctionDefinitionExpr(
        functionType,
        functionNameToken.value,
        argumentNames.map((it) => it.value).toList(),
        body,
        Location.fromToken(start));
    parentContext.addFunction(functionNameToken, functionType);
    return definitionExpression;
  }

  static (NameToken, List<NameToken>) _findFunctionNameAndArgumentNames(
      TokenGroup callSignature) {
    switch (callSignature) {
      case ExpressionTokenGroup _:
        break;
      case SingleTokenGroup _:
        throw ParserException.atToken(
            "malformed function definition, expected a call signature here",
            callSignature.token);
    }
    Token functionNameToken = callSignature.first.token;
    if (functionNameToken is! NameToken) {
      throw ParserException.atToken(
          "expected a valid function name here", functionNameToken);
    }

    List<NameToken> argumentNames = [];
    List<TokenGroup> argumentGroups = callSignature.arguments;
    for (final argument in argumentGroups) {
      if (argument is! SingleTokenGroup) {
        throw ParserException.at(
            "unexpected expression", Location(argument.row, argument.col));
      }
      Token argToken = argument.token;
      if (argToken is! NameToken) {
        throw ParserException.atToken(
            "expected a valid function argument name here", argToken);
      }
      argumentNames.add(argToken);
    }
    return (functionNameToken, argumentNames);
  }

  static List<Expression> _findBody(List<TokenGroup> bodyExpressions,
      TLLType returnType, ScopeContext context) {
    List<Expression> body =
        ExpressionBuilder.buildAllInScope(bodyExpressions, context);

    if (!body.last.type.suffices(returnType)) {
      throw TLLTypeError.withMessageAt(
          "type ${body.last.type.show} does not suffice expected ${returnType.show}",
          body.last.location);
    }
    return body;
  }

  static List<TLLType> _findArgumentTypes(
      ExpressionTokenGroup typesGroup, ScopeContext context) {
    List<TLLType> argumentTypes = [];
    for (int i = 0; i < typesGroup.arguments.length - 1; i++) {
      argumentTypes.add(_findTypeOrThrow(typesGroup.arguments[i], context));
    }
    return argumentTypes;
  }

  static TLLType _findReturnType(
      ExpressionTokenGroup types, ScopeContext context) {
    TLLType returnType;
    if (types.arguments.isEmpty) {
      returnType = _findTypeOrThrow(types.first, context);
    } else {
      returnType = _findTypeOrThrow(types.arguments.last, context);
    }
    return returnType;
  }

  static TLLType _findTypeOrThrow(TokenGroup typeGroup, ScopeContext context) {
    TokenGroup returnTypeGroup = typeGroup;
    if (returnTypeGroup is SingleTokenGroup) {
      Token returnTypeToken = returnTypeGroup.token;
      if (returnTypeToken is! NameToken) {
        throw ParserException.atToken(
            "expected a type name here", returnTypeToken);
      }
      TLLType? returnType = context.findType(returnTypeToken.value);
      if (returnType == null) {
        throw ParserException.atToken(
            "name is not referring to a type", returnTypeToken);
      }
      return returnType;
    } else if (returnTypeGroup is ExpressionTokenGroup) {
      TLLType firstType = _findTypeOrThrow(returnTypeGroup.first, context);
      List<TLLType> rest = [];
      for (final tokenGroup in returnTypeGroup.arguments) {
        rest.add(_findTypeOrThrow(tokenGroup, context));
      }
      List<TLLType> all = [firstType];
      all.addAll(rest);
      return TLLAnonymousSumType(all);
    } else {
      throw Exception("BUG: this should not happen");
    }
  }
}
