import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/cond_expression_builder.dart';
import 'package:tll/parse/expression/builder/const_expression_builder.dart';
import 'package:tll/parse/expression/builder/defun_expression_builder.dart';
import 'package:tll/parse/expression/builder/function_call_expression_builder.dart';
import 'package:tll/parse/expression/builder/if_expression_builder.dart';
import 'package:tll/parse/expression/builder/let_expression_builder.dart';
import 'package:tll/parse/expression/builder/struct_type_expression_builder.dart';
import 'package:tll/parse/expression/builder/sum_type_expression_builder.dart';
import 'package:tll/parse/expression/builder/value_expression_builder.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class ExpressionBuilder {
  static List<Expression> buildAllTopLevel(List<TokenGroup> groups) {
    ScopeContext context = ModuleScopeContext();
    return groups.map((it) => _buildOneTopLevel(it, context)).toList();
  }

  static List<Expression> buildAll(List<TokenGroup> groups) {
    ScopeContext context = ModuleScopeContext();
    return groups.map((it) => buildOne(it, context)).toList();
  }

  static Expression _buildOneTopLevel(
      TokenGroup group, ScopeContext parentContext) {
    switch (group) {
      case SingleTokenGroup _:
        throw ParserException.atToken("unexpected token", group.token);
      case ExpressionTokenGroup _:
        return createExpression(group, parentContext);
    }
  }

  static Expression buildOne(TokenGroup group, ScopeContext parentContext) {
    switch (group) {
      case SingleTokenGroup _:
        return createValueExpression(group, parentContext);
      case ExpressionTokenGroup _:
        return createExpression(group, parentContext);
    }
  }

  static Expression createValueExpression(
      SingleTokenGroup expr, ScopeContext parentContext) {
    Token token = expr.token;
    switch (token) {
      case DefunToken _:
      case LetToken _:
      case ConstToken _:
      case SumTypeToken _:
      case StructTypeToken _:
      case IfToken _:
      case CondToken _:
      case T1BracesOpenToken _:
      case T2BracesOpenToken _:
      case T3BracesOpenToken _:
      case T1BracesCloseToken _:
      case T2BracesCloseToken _:
      case T3BracesCloseToken _:
        throw ParserException.atToken("unexpected token", token);
      case IntToken _:
        return ValueExpressionBuilder.buildInt(token, parentContext);
      case FloatToken _:
        return ValueExpressionBuilder.buildFloat(token, parentContext);
      case StringToken _:
        return ValueExpressionBuilder.buildString(token, parentContext);
      case BoolToken _:
        return ValueExpressionBuilder.buildBool(token, parentContext);
      case NameToken _:
        return ValueExpressionBuilder.buildFromName(token, parentContext);
      case ObjectAccessToken _:
        return ValueExpressionBuilder.buildFromAccessedValue(
            token, parentContext);
    }
  }

  static Expression createExpression(
      ExpressionTokenGroup expr, ScopeContext parentContext) {
    Token first = expr.first.token;
    switch (first) {
      case DefunToken _:
        return DefunExpressionBuilder.build(expr.arguments, parentContext);
      case LetToken _:
        return LetExpressionBuilder.build(
            Location.fromToken(first), expr.arguments, parentContext);
      case ConstToken _:
        return ConstExpressionBuilder.build(
            Location.fromToken(first), expr.arguments, parentContext);
      case SumTypeToken _:
        return SumTypeExpressionBuilder.build(
            first, expr.arguments, parentContext);
      case StructTypeToken _:
        return StructTypeExpressionBuilder.build(
            first, expr.arguments, parentContext);
      case IfToken _:
        return IfExpressionBuilder.build(first, expr.arguments, parentContext);
      case CondToken _:
        return CondExpressionBuilder.build(first, expr.arguments, parentContext);
      case NameToken _:
        return FunctionCallExpressionBuilder.build(
            first, expr.arguments, parentContext);
      case ObjectAccessToken _:
        return FunctionCallExpressionBuilder.buildAccessedCall(
            first, expr.arguments, parentContext);
      case T1BracesOpenToken _:
      case T2BracesOpenToken _:
      case T3BracesOpenToken _:
      case T1BracesCloseToken _:
      case T2BracesCloseToken _:
      case T3BracesCloseToken _:
      case IntToken _:
      case FloatToken _:
      case StringToken _:
      case BoolToken _:
        throw ParserException.atToken("unexpected token", first);
    }
  }
}
