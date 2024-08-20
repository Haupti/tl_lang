import 'package:tll/parse/tokenize/token.dart';

class Location {
  int row;
  int col;
  Location(this.row, this.col);
  Location.fromToken(Token token): row = token.row, col = token.col;
}
