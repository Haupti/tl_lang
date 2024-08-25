import 'package:tll/parse/expression/builder/utils/token_utils.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/primitive_value.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

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

  static Expression buildInt(IntToken token, ScopeContext parentContext) {
    return PrimitiveValueExpression(IntValue(token.value), TLLIntType(), Location.fromToken(token));
  }

  static Expression buildFloat(FloatToken token, ScopeContext parentContext) {
    return PrimitiveValueExpression(FloatValue(token.value), TLLFloatType(), Location.fromToken(token));
  }

  static Expression buildString(StringToken token, ScopeContext parentContext) {
    return PrimitiveValueExpression(StringValue(token.value), TLLStringType(), Location.fromToken(token));
  }

  static Expression buildBool(BoolToken token, ScopeContext parentContext) {
    return PrimitiveValueExpression(BoolValue(token.value), TLLBoolType(), Location.fromToken(token));
  }

  static Expression buildFromName(NameToken token, ScopeContext parentContext) {
    TLLType? type = parentContext.getTypeOf(token.value);
    if(type == null){
      throw ParserException.atToken("'${token.value}' is not in scope",token);
    }
    return ValueReferenceExpression(token.value, type, Location.fromToken(token));
  }

  static Expression buildFromAccessedValue(ObjectAccessToken token, ScopeContext parentContext) {
    TLLType type = TokenUtils.toTypeOfAccessedValue(token, parentContext);
    return AccessedValueReferenceExpression(token.objectName, token.accessedName, token.subaccessedNames, type, Location.fromToken(token));
  }
}
