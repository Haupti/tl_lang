import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/tokenize/token.dart';

class ValueUseExpressionBuilder {
  static Expression build(Token valueToken, ScopeContext parentContext) {
    throw Exception("not yet implemented");
  }

  static Expression buildAccessedValue(Token valueToken, String objectName, String accessedName, List<String> subaccessedNames, ScopeContext parentContext) {
    throw Exception("not yet implemented");
  }
}
