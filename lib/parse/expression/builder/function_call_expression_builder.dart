import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/type.dart';
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
    for (int i= 0; i < type.argumentTypes.lenght; i++){
      
      Expression argumentExpression =  ExpressionBuilder.buildOne(arguments[i],parentContext);
      // TODO
      // if its a value, check its type, add to expression arumgnets
      // if its a reference, check its type, add to expression arguments
      // if its a function clal, check its type, add to expression arguments
      // else throw

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
