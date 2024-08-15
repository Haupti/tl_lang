import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/token.dart';

sealed class Tree {
  String name;
  int row;
  int col;
  Tree(this.name, this.row, this.col);
}

class Leaf implements Tree {
  @override
  int col;

  @override
  String name;

  @override
  int row;

  Leaf(this.name, this.row, this.col);
}

class Node implements Tree {
  @override
  int col;

  @override
  String name;

  @override
  int row;

  List<Tree> arguments;
  Node(this.name, this.arguments, this.row, this.col);
}

class Collector {
  static List<Token> _findInnerTokens(List<Token> expressionTokens){
        List<Token> trimmedExpressionTokens = expressionTokens.sublist(1);
        trimmedExpressionTokens.removeLast();
        return trimmedExpressionTokens;
  }
  static Tree _toTree(List<Token> tokens) {
    List<Token> innerTokens = _findInnerTokens(tokens);

    for (int i = 0; i < innerTokens.length; i++) {
      // TODO
    }
  }

  static (Tree?, List<Token>) _findFirstExpressionTreeAndRest(
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

    Tree? tree;
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
        tree = _toTree(expressionTokens);
        expressionTokens = [];
        break;
      }
    }
    List<Token> rest = tokens.sublist(i + 1);
    return (tree, rest);
  }

  static List<Tree> _findExpressionTrees(List<Token> tokens) {
    if (tokens.isEmpty) {
      return [];
    }
    var (tree, rest) = _findFirstExpressionTreeAndRest(tokens);

    if (tree == null) {
      // TODO add info where the initial bracket was and which bracket
      throw Exception("could not find matching close for bracket");
    }

    // recursive
    // recursive stop
    if (rest.isNotEmpty) {
      List<Tree> trees = [tree];
      trees.addAll(_findExpressionTrees(rest));
      return trees;
    } else {
      return [tree];
    }
  }

  static List<Tree> findTrees(String code) {
    List<Token> tokens = Lexer.tokenize(code);
    return _findExpressionTrees(tokens);
  }
}
