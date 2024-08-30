import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class DefunExpressionBuilder {
  static Expression build(DefunToken start, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    if (arguments.length < 3) {
      ParserException.atToken("malformed function definition", start);
    }

    TokenGroup types = arguments[0];
    if(types is SingleTokenGroup){
      ParserException.atToken("expected a list of types here", types.token);
    }
    if(types is! ExpressionTokenGroup){
      throw Exception("BUG: this should not happen");
    }
    for(final type in types){
      
    }

  }
}
