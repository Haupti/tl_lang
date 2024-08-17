import 'package:tll/parse/tokenize/token.dart';

class ParserException implements Exception {
  final String message;
  final int row;
  final int col;
  ParserException(this.message, this.row, this.col);
  @override
  String toString() => "PARSE-ERROR at ($row|$col): $message.";

  ParserException.atToken(this.message, Token token): row = token.row, col = token.col;
}

