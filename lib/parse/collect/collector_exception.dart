import 'package:tll/parse/tokenize/token.dart';

class ParserException implements Exception {
  final String message;
  final Token savedToken;
  final int row;
  final int col;
  @override
  String toString() => "PARSE-ERROR at token '${savedToken.show}' ($row,$col): $message.";

  ParserException.atToken(this.message, Token token): row = token.row, col = token.col, savedToken = token;
}

