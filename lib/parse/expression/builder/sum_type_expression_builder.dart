import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/convert/expression_converter.dart';
import 'package:tll/parse/expression/builder/verify/type_verifyier.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class SumTypeExpressionBuilder {
  static Expression build(SumTypeToken start, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    if (arguments.length < 2) {
      throw ParserException.atToken("expected at least two arguments", start);
    }
    NameToken name = TokenGroupConverter.toSingleNameOrThrow(
        arguments[1], "expected a valid type name");

    List<TLLType> types = [];

    for (final tokenGroup in arguments) {
      Token token = TokenGroupConverter.toSingleOrThrow(tokenGroup, "").token;
      types.add(TypeVerifier.toTypeOrThrow(token, parentContext));
    }

    TLLSumType sumType = TLLSumType(name.value, types);
    parentContext.addType(name, sumType);
    return SumTypeDefinitionExpr(sumType, Location.fromToken(start));
  }
}
