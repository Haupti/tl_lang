import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class ExpressionConverter {
  static SingleTokenGroup toSingleOrThrow(TokenGroup group, String message) {
    if (group is ExpressionTokenGroup) {
      throw ParserException.atToken(message, group.first.token);
    }
    if (group is! SingleTokenGroup) {
      throw Exception("BUG");
    }
    return group;
  }

  static NameToken toNameOrThrow(SingleTokenGroup group, String message) {
    Token token = group.token;
    if (token is! NameToken) {
      throw ParserException.atToken(message, token);
    }
    return token;
  }
}
