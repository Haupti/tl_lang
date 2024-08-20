import 'package:tll/parse/expression/location.dart';
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
}
