import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/utils/token_utils.dart';
import 'package:tll/parse/expression/builder/verify/type_verifyier.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/type/type.dart';

class StructTypeExpressionBuilder {
  static Expression build(StructTypeToken start, List<TokenGroup> arguments,
      ScopeContext parentContext) {
    if (arguments.isEmpty) {
      throw ParserException.atToken("expected at least a type name", start);
    }
    NameToken name = TokenUtils.toSingleNameOrThrow(
        arguments[0], "expected a valid type name");

    Map<String, TLLType> structFields = {};

    List<(Token, NameToken)> pairs = _toPairs(arguments.sublist(1));
    for (final pair in pairs) {
      TLLType type = TypeVerifier.toTypeOrThrow(pair.$1, parentContext);
      NameToken fieldName = pair.$2;
      if (structFields[fieldName.value] != null) {
        throw ParserException.atToken(
            "field name is already taken in struct", fieldName);
      }
      structFields[fieldName.value] = type;
    }
    TLLStructType struct = TLLStructType(name.value, structFields);
    return StructTypeDefinitionExpr(struct, Location.fromToken(start));
  }

  static List<(Token, NameToken)> _toPairs(List<TokenGroup> groups) {
    List<(Token, NameToken)> pairs = [];
    if (groups.isEmpty) {
      return pairs;
    }
    if (groups.length.isOdd) {
      throw ParserException.atTokenGroup(
          "expected type and field name pairs", groups[0]);
    }
    for (int i = 0; i < groups.length; i += 2) {
      pairs.add((
        TokenUtils.toSingleOrThrow(
                groups[i], "expected a type name or value type here")
            .token,
        TokenUtils.toSingleNameOrThrow(
            groups[i + 1], "expected a field name here")
      ));
    }
    return pairs;
  }
}
