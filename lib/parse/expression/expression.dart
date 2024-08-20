import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';

sealed class Expression {
  Location location;
  Expression(this.location);
}

class ConstantDefinitionExpr implements Expression {
  @override
  Location location;
  ConstantDefinitionExpr(this.location);
}

class VariableDefinitionExpr implements Expression {
  @override
  Location location;

  String name;
  TLLType type;
  Expression value;

  VariableDefinitionExpr(this.name, this.type, this.value, this.location);
}

class FunctionDefinitionExpr implements Expression {
  @override
  Location location;

  FunctionDefinitionExpr(this.location);
}

sealed class TypeDefinitionExpr implements Expression {
  @override
  Location location;

  TypeDefinitionExpr(this.location);
}

class StructTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  Location location;

  StructTypeDefinitionExpr(this.location);
}

class SumTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  Location location;

  SumTypeDefinitionExpr(this.location);
}

class VariableReferenceExpression implements Expression {
  @override
  Location location;

  String name;
  TLLType type;

  VariableReferenceExpression(this.name, this.type, this.location);
}
