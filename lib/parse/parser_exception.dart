import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/tokenize/token.dart';

class ParserException implements Exception {
  final String message;
  final Token? savedToken;
  final int row;
  final int col;
  @override
  String toString() {
    Token? token = savedToken;
    if (token == null) {
      return "PARSE-ERROR at ($row,$col): $message.";
    } else {
      return "PARSE-ERROR at token '${token.show}' ($row,$col): $message.";
    }
  }

  ParserException.atToken(this.message, Token token)
      : row = token.row,
        col = token.col,
        savedToken = token;

  ParserException.at(this.message, Location start)
      : row = start.row,
        col = start.col,
        savedToken = null;

  ParserException.atTokenGroup(this.message, TokenGroup group)
      : row = _toToken(group).row,
        col = _toToken(group).col,
        savedToken = _toToken(group);

  static Token _toToken(TokenGroup group) {
    switch (group) {
      case ExpressionTokenGroup _:
        return group.first.token;
      case SingleTokenGroup _:
        return group.token;
    }
  }
}
