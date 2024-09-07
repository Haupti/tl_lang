import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/type/type.dart';
import 'package:tll/type/type_mismatch_exception.dart';

class CondExpressionBuilder {
  static Expression build(
      CondToken start, List<TokenGroup> arguments, ScopeContext parentContext) {
    if (arguments.length.isOdd) {
      throw ParserException.atToken(
          "expected condition and value pairs", start);
    }

    List<(Expression, Expression)> conditionAndValuePairs = [];
    List<TLLType> condResultTypes = [];
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

      List<TLLType> flattend = _flattenType(valueExpression.type);
      for (final t in flattend) {
        if (!condResultTypes.contains(t)) {
          condResultTypes.add(t);
        }
      }
    }

    if (condResultTypes.isEmpty) {
      throw TLLTypeError.withMessage("BUG: no return type for cond???", start);
    }
    if (condResultTypes.length == 1) {
      return CondExpression(conditionAndValuePairs, condResultTypes[0],
          Location.fromToken(start));
    }
    return CondExpression(conditionAndValuePairs,
        TLLAnonymousSumType(condResultTypes), Location.fromToken(start));
  }

  static List<TLLType> _flattenType(TLLType type) {
    if (type is TLLSumType) {
      return type.allowedTypes;
    }
    if (type is TLLAnonymousSumType) {
      return type.allowedTypes;
    }
    return [type];
  }
}
