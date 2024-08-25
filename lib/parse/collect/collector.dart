import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/token.dart';

class Collector {
  static List<Token> _findInnerTokens(List<Token> expressionTokens) {
    List<Token> trimmedExpressionTokens = expressionTokens.sublist(1);
    trimmedExpressionTokens.removeLast();
    return trimmedExpressionTokens;
  }

  static List<TokenGroup> _findGroups(List<Token> tokens) {
    List<TokenGroup> foundGroups = [];
    Token token;
    for (int i = 0; i < tokens.length; i++) {
      token = tokens[i];
      if (Token.isBracketOpen(token)) {
        var (expressionGroup, rest) = _findFirstExpressionAndRest(tokens.sublist(i));
        if (expressionGroup == null) {
          throw ParserException.atToken("unexpected empty expression", token);
        }
        foundGroups.add(expressionGroup);
        foundGroups.addAll(_findGroups(rest));
        break; 
      } else {
        foundGroups.add(SingleTokenGroup(token));
      }
    }
    return foundGroups;
  }

  static ExpressionTokenGroup _toExpression(List<Token> tokens) {
    List<Token> innerTokens = _findInnerTokens(tokens);

    if (innerTokens.isEmpty) {
      throw ParserException.atToken(
          "empty expressions are not allowed", tokens[0]);
    }

    Token baseToken = innerTokens[0];
    if (baseToken is! ObjectAccessToken && baseToken is! NameToken) {
      throw ParserException.atToken("unexpected invalid token", baseToken);
    }
    List<TokenGroup> groups = _findGroups(innerTokens.sublist(1));

    return ExpressionTokenGroup(SingleTokenGroup(baseToken), groups);
  }

  static (ExpressionTokenGroup?, List<Token>) _findFirstExpressionAndRest(
      List<Token> tokens) {
    if (tokens.isEmpty) {
      return (null, []);
    }

    String? bracketType;
    if (tokens[0] is T1BracesOpenToken) {
      bracketType = "t1";
    } else if (tokens[0] is T2BracesOpenToken) {
      bracketType = "t2";
    } else if (tokens[0] is T3BracesOpenToken) {
      bracketType = "t3";
    } else {
      throw ParserException.atToken("expected a bracket here", tokens[0]);
    }

    ExpressionTokenGroup? tree;
    int bracketCounter = 0;
    List<Token> expressionTokens = [];
    int i = 0;
    for (i = 0; i < tokens.length; i++) {
      Token token = tokens[i];
      expressionTokens.add(token);
      switch (token) {
        case T1BracesOpenToken _:
          if (bracketType == "t1") {
            bracketCounter += 1;
          }
        case T2BracesOpenToken _:
          if (bracketType == "t2") {
            bracketCounter += 1;
          }
        case T3BracesOpenToken _:
          if (bracketType == "t3") {
            bracketCounter += 1;
          }
        case T1BracesCloseToken _:
          if (bracketType == "t1") {
            bracketCounter -= 1;
          }
        case T2BracesCloseToken _:
          if (bracketType == "t2") {
            bracketCounter -= 1;
          }
        case T3BracesCloseToken _:
          if (bracketType == "t3") {
            bracketCounter -= 1;
          }
        default:
      }
      if (bracketCounter == 0) {
        tree = _toExpression(expressionTokens);
        expressionTokens = [];
        break;
      }
    }
    List<Token> rest = [];
    if (tokens.length > i + 1) {
      rest = tokens.sublist(i + 1);
    }
    return (tree, rest);
  }

  static List<ExpressionTokenGroup> _findExpressions(List<Token> tokens) {
    if (tokens.isEmpty) {
      return [];
    }
    var (tree, rest) = _findFirstExpressionAndRest(tokens);

    if (tree == null) {
      throw ParserException.atToken(
          "could not find matching close for bracket", tokens[0]);
    }

    // recursive
    // recursive stop
    if (rest.isNotEmpty) {
      List<ExpressionTokenGroup> trees = [tree];
      trees.addAll(_findExpressions(rest));
      return trees;
    } else {
      return [tree];
    }
  }

  static List<ExpressionTokenGroup> findExpressions(String code) {
    List<Token> tokens = Lexer.tokenize(code);
    return _findExpressions(tokens);
  }
}
