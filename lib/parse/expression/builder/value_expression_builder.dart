import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/tokenize/token.dart';

class ValueExpressionBuilder {
  static Expression build(Token token, ScopeContext parentContext) {
    throw Exception("not yet implemented");
  }

  static Expression buildAccessedValue(
      ObjectAccessToken token,
      String objectName,
      String accessedName,
      List<String> subaccessedNames,
      ScopeContext parentContext) {
    throw Exception("not yet implemented");
  }
}
