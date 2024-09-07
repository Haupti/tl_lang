import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/type/type.dart';
import 'package:tll/type/type_mismatch_exception.dart';

class TokenUtils {
  static SingleTokenGroup toSingleOrThrow(TokenGroup group, String message) {
    if (group is ExpressionTokenGroup) {
      throw ParserException.atToken(message, group.first.token);
    }
    if (group is! SingleTokenGroup) {
      throw Exception("BUG");
    }
    return group;
  }

  static NameToken toNameOrThrow(SingleTokenGroup group, String message) {
    Token token = group.token;
    if (token is! NameToken) {
      throw ParserException.atToken(message, token);
    }
    return token;
  }

  static NameToken toSingleNameOrThrow(TokenGroup group, String message) {
    SingleTokenGroup single = toSingleOrThrow(group, message);
    return toNameOrThrow(single, message);
  }

  static TLLType toTypeOfAccessedValue(
      ObjectAccessToken token, ScopeContext context) {
    TLLType? type = context.getTypeOf(token.objectName);
    if (type == null) {
      throw ParserException.atToken(
          "'${token.objectName}' does not exist", token);
    }
    if (type is! TLLStructType) {
      throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
    }

    //accessed field might not exist in type
    TLLType? accessedFieldType = type.getTypeOfField(token.accessedName);
    if (accessedFieldType == null) {
      throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
    }

    // if we are not at struct type we cannot access fields of it
    if (accessedFieldType is! TLLStructType &&
        token.subaccessedNames.isNotEmpty) {
      throw TLLTypeError.objectDoesNotHave(
          accessedFieldType, token.subaccessedNames[0], token);
    }

    // find type of last accessed object
    TLLType resultType = accessedFieldType;
    for (final subName in token.subaccessedNames) {
      if (resultType is! TLLStructType) {
        throw TLLTypeError.objectDoesNotHave(resultType, subName, token);
      }
      TLLType? accessedFieldType = resultType.getTypeOfField(subName);
      if (accessedFieldType == null) {
        throw TLLTypeError.objectDoesNotHave(type, token.accessedName, token);
      }
      resultType = accessedFieldType;
    }
    return resultType;
  }
}
