import 'package:tll/parse/expression/type.dart';

sealed class Expression {
  int row;
  int col;
  Expression(this.row, this.col);
}

class ConstantDefinitionExpr implements Expression {
  @override
  int col;

  @override
  int row;

  ConstantDefinitionExpr(this.row, this.col);
}

class VariableDefinitionExpr implements Expression {
  @override
  int col;

  @override
  int row;

  VariableDefinitionExpr(this.row, this.col);
}

class FunctionDefinitionExpr implements Expression {
  @override
  int col;

  @override
  int row;

  FunctionDefinitionExpr(this.row, this.col);
}

sealed class TypeDefinitionExpr implements Expression {
  @override
  int col;

  @override
  int row;

  TypeDefinitionExpr(this.row, this.col);
}

class StructTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  int col;

  @override
  int row;

  StructTypeDefinitionExpr(this.row, this.col);
}

class SumTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  int col;

  @override
  int row;

  SumTypeDefinitionExpr(this.row, this.col);
}

class VariableReferenceExpression implements Expression {
  @override
  int col;

  @override
  int row;

  String name;
  TLLType type;

  VariableReferenceExpression(this.name, this.type, this.row, this.col);
}
