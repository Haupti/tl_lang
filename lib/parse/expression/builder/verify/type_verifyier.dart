import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/tokenize/token.dart';

class TypeVerifier {
  static TLLType toTypeOrThrow(NameToken token, ScopeContext context){
    throw Exception("not yet implemented");
  }

  static void isExpectedTypedValueOrThrow(TLLType type, Expression valueExpression, Location location) {
    throw Exception("not yet implemented");
  }
}
