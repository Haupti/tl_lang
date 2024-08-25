import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_mismatch_exception.dart';

class CondExpressionBuilder {
  static Expression build(
      CondToken start, List<TokenGroup> arguments, ScopeContext parentContext) {
    if (arguments.length.isOdd) {
      throw ParserException.atToken(
          "expected condition and value pairs", start);
    }

    List<(Expression, Expression)> conditionAndValuePairs = [];
    for (int i = 0; i < arguments.length; i += 2) {
      Expression condition =
          ExpressionBuilder.buildOne(arguments[i], parentContext);
      if (!condition.type.isBool()) {
        throw TLLTypeError.atTokenGroup(
            condition.type, TLLBoolType(), arguments[i]);
      }
      Expression valueExpression =
          ExpressionBuilder.buildOne(arguments[i + 1], parentContext);
      conditionAndValuePairs.add((condition, valueExpression));
    }

    for(final pair in conditionAndValuePairs){
    }
    TLLType type;
    if (thenExpr.type.matches(elseExpr.type)) {
      type = thenExpr.type;
    } else {
      type = TLLAnonymousSumType([thenExpr.type, elseExpr.type]);
    }
    return IfExpression(
        condition, thenExpr, elseExpr, type, Location.fromToken(start));
  }
}
