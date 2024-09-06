import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/location.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_mismatch_exception.dart';

class TypeVerifier {
  static void isExpectedTypedValueOrThrow(
      TLLType type, Expression valueExpression, Location location) {
    if (!valueExpression.type.suffices(type)) {
      throw TLLTypeError.expectedATypeAtLocation(
          valueExpression.type, type.show(), location);
    }
  }

  static TLLType toTypeOrThrow(Token token, ScopeContext context) {
    switch (token) {
      case IntToken _:
        return (TLLIntValueType(token.value));
      case StringToken _:
        return (TLLStringValueType(token.value));
      case FloatToken _:
        return (TLLFloatValueType(token.value));
      case BoolToken _:
        return (TLLBoolValueType(token.value));
      case NameToken _:
        return (_determineType(token, context));
      case ObjectAccessToken _:
      case T1BracesOpenToken _:
      case T2BracesOpenToken _:
      case T3BracesOpenToken _:
      case T1BracesCloseToken _:
      case T2BracesCloseToken _:
      case T3BracesCloseToken _:
      case ConstToken _:
      case LetToken _:
      case DefunToken _:
      case StructTypeToken _:
      case SumTypeToken _:
      case CondToken _:
      case IfToken _:
        throw ParserException.atToken("unexpected token", token);
    }
  }

  static TLLType _determineType(NameToken token, ScopeContext context) {
    TLLType? type = context.findType(token.value);
    if (type == null) {
      throw ParserException.atToken("no type with this name in scope", token);
    }
    return type;
  }
}
