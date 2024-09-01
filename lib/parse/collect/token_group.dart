import 'package:tll/parse/tokenize/token.dart';

sealed class TokenGroup {
  int get row;
  int get col;
}

class SingleTokenGroup implements TokenGroup {
  Token token;
  SingleTokenGroup(this.token);

  @override
  int get row => token.row;
  @override
  int get col => token.col;
}

class ExpressionTokenGroup implements TokenGroup {
  SingleTokenGroup first;
  List<TokenGroup> arguments;
  ExpressionTokenGroup(this.first, this.arguments);

  @override
  int get row => first.token.row;
  @override
  int get col => first.token.col;
}
