import 'package:tll/parse/tokenize/token.dart';

sealed class TokenGroup {}

class SingleTokenGroup implements TokenGroup {
  Token token;
  SingleTokenGroup(this.token);
}

class ExpressionTokenGroup implements TokenGroup {
  SingleTokenGroup first;
  List<TokenGroup> arguments;
  ExpressionTokenGroup(this.first, this.arguments);
}
