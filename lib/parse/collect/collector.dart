import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/token.dart';

class Collector {
  static List<Token> _findInnerTokens(List<Token> expressionTokens) {
    List<Token> trimmedExpressionTokens = expressionTokens.sublist(1);
    trimmedExpressionTokens.removeLast();
    return trimmedExpressionTokens;
  }

  static Expression _toExpression(List<Token> tokens) {
    List<Token> innerTokens = _findInnerTokens(tokens);

    if (innerTokens.isEmpty) {
      throw Exception("empty expressions are not allowed"); // TODO more info
    }
    Token token = innerTokens[0];
    Expression base;
    for (int i = 0; i < innerTokens.length; i++) {
      if (token is ObjectAccessToken) {
        base = Node();
      }
      if (token is NameToken) {
        base = Node();
      }
    }
  }

  static (Expression?, List<Token>) _findFirstExpressionAndRest(
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
      throw Exception("expected a bracket here");
    }

    Expression? tree;
    int bracketCounter = 1;
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
    List<Token> rest = tokens.sublist(i + 1);
    return (tree, rest);
  }

  static List<Expression> _findExpressions(List<Token> tokens) {
    if (tokens.isEmpty) {
      return [];
    }
    var (tree, rest) = _findFirstExpressionAndRest(tokens);

    if (tree == null) {
      // TODO add info where the initial bracket was and which bracket
      throw Exception("could not find matching close for bracket");
    }

    // recursive
    // recursive stop
    if (rest.isNotEmpty) {
      List<Expression> trees = [tree];
      trees.addAll(_findExpressions(rest));
      return trees;
    } else {
      return [tree];
    }
  }

  static List<Expression> findExpressions(String code) {
    List<Token> tokens = Lexer.tokenize(code);
    return _findExpressions(tokens);
  }
}
