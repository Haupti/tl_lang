import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/utils/token_utils.dart';
import 'package:tll/parse/expression/builder/verify/type_verifyier.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

class ConstExpressionBuilder {
  static Expression build(Location start, List<TokenGroup> arguments, ScopeContext parentContext) {
    if (arguments.length != 3) {
      throw ParserException.at(
          "expected a type, name and value argument", start);
    }
    SingleTokenGroup typeToken = TokenUtils.toSingleOrThrow(
        arguments[0], "expected a type here");
    SingleTokenGroup nameToken = TokenUtils.toSingleOrThrow(
        arguments[1], "expected a name here");

    NameToken typeName =
        TokenUtils.toNameOrThrow(typeToken, "expected a type here");
    NameToken name =
        TokenUtils.toNameOrThrow(nameToken, "expected a name here");

    TLLType type = TypeVerifier.toTypeOrThrow(typeName, parentContext);

    TokenGroup valueGroup = arguments[2];
    Expression valueExpression;
    switch (valueGroup) {
      case SingleTokenGroup _:
        valueExpression =
            ExpressionBuilder.createValueExpression(valueGroup, parentContext);
        TypeVerifier.isExpectedTypedValueOrThrow(
            type, valueExpression, Location.fromToken(valueGroup.token));
      case ExpressionTokenGroup _:
        valueExpression =
            ExpressionBuilder.createExpression(valueGroup, parentContext);
        TypeVerifier.isExpectedTypedValueOrThrow(
            type, valueExpression, Location.fromToken(valueGroup.first.token));
    }

    parentContext.addConstant(name, type);
    return ConstantDefinitionExpr(name.value, type, valueExpression, start);
  }
}

