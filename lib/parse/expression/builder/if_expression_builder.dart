import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_mismatch_exception.dart';

class IfExpressionBuilder {
  static Expression build(
      IfToken start, List<TokenGroup> arguments, ScopeContext parentContext) {
    if (arguments.length != 3) {
      throw ParserException.atToken("expected three arguments", start);
    }

    Expression condition =
        ExpressionBuilder.buildOne(arguments[0], parentContext);
    if (!condition.type.isBool()) {
      throw TLLTypeError.atTokenGroup(
          condition.type, TLLBoolType(), arguments[0]);
    }

    Expression thenExpr =
        ExpressionBuilder.buildOne(arguments[1], parentContext);
    Expression elseExpr =
        ExpressionBuilder.buildOne(arguments[1], parentContext);

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
