import 'package:tll/parse/tokenize/token.dart';

class TLLType {
  // TODO
}

sealed class Expression {
  int row;
  int col;
  Expression(this.row, this.col);
}

class TypeExpression implements Expression {
  @override
  int col;

  @override
  int row;

  TLLType type;
  TypeExpression(this.type, this.row, this.col);
  TypeExpression.atToken(this.type, Token token)
      : row = token.row,
        col = token.col;
  // TODO add 'fromToken' which also decides type based on token
}

class TypedName {
  String name;
  TLLType type;
  TypedName(this.name, this.type);
}

class DefunExpression implements Expression {
  @override
  int col;

  @override
  int row;

  String name;
  // ignore: unused_field 
  final Map<String, TypedName> _argnames;// TODO use
  TLLType returnType;
  List<Expression> body;
  DefunExpression(this.name, this.returnType, this._argnames, this.body,
      this.row, this.col);
  DefunExpression.atToken(
      this.name, this.returnType, this._argnames, this.body, Token token)
      : row = token.row,
        col = token.col;
}
