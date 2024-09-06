import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

class TLLTypeError implements Exception {
  String message;

  @override
  String toString() {
    return message;
  }

  TLLTypeError.atTokenGroup(
      TLLType actualType, TLLType expectedType, TokenGroup mismatchingGroup)
      : message =
            "TYPE-ERROR at (${_toToken(mismatchingGroup).row},${_toToken(mismatchingGroup).col}): expected $expectedType but got $actualType.";

  TLLTypeError.atToken(
      TLLType actualType, TLLType expectedType, Token mismatchingToken)
      : message =
            "TYPE-ERROR at (${mismatchingToken.row},${mismatchingToken.col}): expected $expectedType but got $actualType.";

  TLLTypeError.objectDoesNotHave(
      TLLType actualType, String fieldName, Token mismatchingToken)
      : message =
            "TYPE-ERROR (${mismatchingToken.row}, ${mismatchingToken.col}): the type $actualType does not have field '$fieldName'";

  TLLTypeError.expectedAType(
      TLLType actualType, String expected, Token mismatchingToken)
      : message =
            "TYPE-ERROR (${mismatchingToken.row}, ${mismatchingToken.col}): expected a $expected here, but got a $actualType";

  TLLTypeError.expectedATypeAtLocation(
      TLLType actualType, String expected, Location location)
      : message =
            "TYPE-ERROR (${location.row}, ${location.col}): expected a $expected here, but got a $actualType";

  TLLTypeError.withMessage(String message, Token mismatchingToken)
      : message =
            "TYPE-ERROR at (${mismatchingToken.row}, ${mismatchingToken.col}): $message";

  TLLTypeError.withMessageAt(String message, Location location)
      : message = "TYPE-ERROR at (${location.row}, ${location.col}): $message";

  static Token _toToken(TokenGroup group) {
    switch (group) {
      case ExpressionTokenGroup _:
        return group.first.token;
      case SingleTokenGroup _:
        return group.token;
    }
  }
}
