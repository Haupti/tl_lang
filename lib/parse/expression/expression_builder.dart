import 'package:tll/parse/collect/collector_exception.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/tokenize/token.dart';

class ExpressionBuilder {
  static List<Expression> buildAll(List<TokenGroup> groups) {
    return groups.map((it)=> _buildOne(it)).toList();
  }
  static Expression _buildOne(TokenGroup group){
    switch(group){
      case SingleTokenGroup _:
        return _singleToExpression(group);
      case ExpressionTokenGroup _:
        return _manyToExpression(group);
    }
  }
  static Expression _singleToExpression(SingleTokenGroup single, ExpressionBuilderContext context){
    switch(single.token){
      case NameToken _:
        //  TODO verify that this exists in the context
        // add the others which are valid as stand-alone tokens
      default: throw ParserException.atToken("unexpected token",single.token);
    }
  }
  static Expression _manyToExpression(ExpressionTokenGroup single){
    // TODO 
    // decide which function to build
    // make single tokens to expressions (function above)
    // when necessary add stuff to context (let, const, defun, struct and type definitions)
    // on function calls or assignments verify the types
    // next step will be code generation in other language
    throw Exception("not yet implemented");
  }
}
