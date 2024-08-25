import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/primitive_value.dart';
import 'package:tll/parse/expression/type.dart';

sealed class Expression {
  TLLType type;
  Location location;
  Expression(this.type, this.location);
}

class ConstantDefinitionExpr implements Expression {
  @override
  Location location;

  String name;
  @override
  TLLType type;
  Expression value;
  ConstantDefinitionExpr(this.name, this.type, this.value, this.location);
}

class VariableDefinitionExpr implements Expression {
  @override
  Location location;

  String name;
  @override
  TLLType type;
  Expression value;

  VariableDefinitionExpr(this.name, this.type, this.value, this.location);
}

class FunctionDefinitionExpr implements Expression {
  @override
  Location location;

  @override
  TLLType type;

  FunctionDefinitionExpr(this.type, this.location);
}

sealed class TypeDefinitionExpr implements Expression {
  @override
  Location location;

  TypeDefinitionExpr(this.location);
}

class StructTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  Location location;

  @override
  TLLType type;
  String name;

  StructTypeDefinitionExpr(this.name, this.type, this.location);
}

class SumTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  Location location;

  @override
  TLLType type;

  SumTypeDefinitionExpr(this.type, this.location);
}

class ReferenceExpression implements Expression {
  @override
  Location location;

  String name;
  @override
  TLLType type;

  ReferenceExpression(this.name, this.type, this.location);
}

class PrimitiveValueExpression implements Expression {
  @override
  Location location;

  PrimitiveValue value;
  @override
  TLLType type;

  PrimitiveValueExpression(this.value, this.type, this.location);
}

class FunctionCallExpression implements Expression {
  @override
  Location location;

  TLLType returnType;

  List<Expression> arguments;
  @override
  TLLType get type => returnType;

  FunctionCallExpression(this.returnType, this.arguments, this.location);

  @override
  set type(TLLType _) {
    throw Exception("do not call this");
  }
}
