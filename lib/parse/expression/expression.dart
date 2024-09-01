import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/primitive_value.dart';
import 'package:tll/parse/type/type.dart';

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

  String name;
  List<String> argumentNames;
  List<Expression> body;
  TLLFunctionType get functionType => _toType();

  TLLFunctionType _toType() {
    TLLType myType = type;
    if (myType is TLLFunctionType) {
      return myType;
    } else {
      throw Exception("BUG: this should not happen");
    }
  }

  FunctionDefinitionExpr(
      this.type, this.name, this.argumentNames, this.body, this.location);
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

  StructTypeDefinitionExpr(this.type, this.location);
}

class SumTypeDefinitionExpr implements Expression, TypeDefinitionExpr {
  @override
  Location location;

  @override
  TLLType type;

  SumTypeDefinitionExpr(this.type, this.location);
}

class AccessedValueReferenceExpression implements Expression {
  @override
  Location location;

  String objectName;
  String accessedField;
  List<String> subaccessedFields;
  @override
  TLLType type;

  AccessedValueReferenceExpression(this.objectName, this.accessedField,
      this.subaccessedFields, this.type, this.location);
}

class ValueReferenceExpression implements Expression {
  @override
  Location location;

  String name;
  @override
  TLLType type;

  ValueReferenceExpression(this.name, this.type, this.location);
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

  String name;
  List<String> accessedNames;
  List<Expression> arguments;
  @override
  TLLType get type => returnType;

  FunctionCallExpression(this.returnType, this.name, this.accessedNames, this.arguments, this.location);

  @override
  set type(TLLType _) {
    throw Exception("do not call this");
  }
}

class IfExpression implements Expression {
  @override
  Location location;

  @override
  TLLType type;
  Expression conditionExpression;
  Expression thenExpression;
  Expression elseExpression;

  IfExpression(this.conditionExpression, this.thenExpression,
      this.elseExpression, this.type, this.location);
}

class CondExpression implements Expression {
  @override
  Location location;

  @override
  TLLType type;
  List<(Expression, Expression)> condResultPairs;

  CondExpression(this.condResultPairs, this.type, this.location);
}
