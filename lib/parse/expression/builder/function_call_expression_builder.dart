import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/tokenize/token.dart';

class FunctionCallExpressionBuilder {
  static Expression build(Token functionName, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    throw Exception("not yet implemented");
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
