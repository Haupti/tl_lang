import 'package:tll/parse/collect/collector_exception.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/tokenize/token.dart';

class ExpressionBuilder {

  static List<Expression> buildAll(List<TokenGroup> groups) {
    ScopeContext context = ModuleScopeContext();
    return groups.map((it)=> _buildOne(it, context)).toList();
  }

  static Expression _buildOne(TokenGroup group, ScopeContext parentContext){
    switch(group){
      case SingleTokenGroup _:
        return _singleToExpression(group, parentContext);
      case ExpressionTokenGroup _:
        return _manyToExpression(group, parentContext);
    }
  }

  static Expression _singleToExpression(SingleTokenGroup single, ScopeContext context){
    Token token = single.token;
    switch(token){
      case NameToken _:
        if(context.hasNamedObject(token.value)){
          // TODO should return something that tells the user what it is (Variable, Const, Function, Struct)
          // and what type it has
        }
        
      default: throw ParserException.atToken("unexpected token",single.token);
    }
  }

  static Expression _manyToExpression(ExpressionTokenGroup single, ScopeContext parentContext){
    // TODO 
    // decide which function to build
    // make single tokens to expressions (function above)
    // when necessary add stuff to context (let, const, defun, struct and type definitions)
    // on function calls or assignments verify the types
    // next step will be code generation in other language
    throw Exception("not yet implemented");
  }
}
