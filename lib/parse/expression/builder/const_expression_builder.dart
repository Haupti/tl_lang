import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/convert/expression_converter.dart';
import 'package:tll/parse/expression/builder/verify/type_verifyier.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class ConstExpressionBuilder {
  static Expression build(Location start, List<TokenGroup> arguments, ScopeContext parentContext) {
    if (arguments.length != 3) {
      throw ParserException.at(
          "expected a type, name and value argument", start);
    }
    SingleTokenGroup typeToken = TokenGroupConverter.toSingleOrThrow(
        arguments[0], "expected a type here");
    SingleTokenGroup nameToken = TokenGroupConverter.toSingleOrThrow(
        arguments[1], "expected a name here");

    NameToken typeName =
        TokenGroupConverter.toNameOrThrow(typeToken, "expected a type here");
    NameToken name =
        TokenGroupConverter.toNameOrThrow(nameToken, "expected a name here");

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
