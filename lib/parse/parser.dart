import 'package:tll/parse/collect/collector.dart';
import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder.dart';
import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/token.dart';

class TLLParser {
  static List<Expression> parse(String content) {
    List<Token> tokens = Lexer.tokenize(content);
    List<TokenGroup> groups = ExpressionCollector.findExpressions(tokens);
    return ExpressionBuilder.buildAllTopLevel(groups);
  }
}
