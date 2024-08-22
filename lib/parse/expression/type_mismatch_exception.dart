import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/tokenize/token.dart';

class TLLTypeError implements Exception {
  final TLLType actualType;
  final TLLType expectedType;
  final int row;
  final int col;

  @override
  String toString() {
      return "TYPE-ERROR at ($row,$col): expected $expectedType but got $actualType.";
  }

  TLLTypeError.atTokenGroup(this.actualType, this.expectedType, TokenGroup mismatchingGroup)
      : row = _toToken(mismatchingGroup).row,
        col = _toToken(mismatchingGroup).col;

  static Token _toToken(TokenGroup group){
    switch(group){
    case ExpressionTokenGroup _:
      return group.first.token;
    case SingleTokenGroup _:
      return group.token;
    }
  }
}
