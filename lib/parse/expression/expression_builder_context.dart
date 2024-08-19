import 'package:tll/parse/expression/expression.dart';

sealed class ScopeContext {
  bool hasNamedObject(String value);
}

class ModuleScopeContext implements ScopeContext {
  ExpressionContainer<ConstantDefinitionExpr> constants = ExpressionContainer();
  ExpressionContainer<VariableDefinitionExpr> variables = ExpressionContainer();
  ExpressionContainer<FunctionDefinitionExpr> functions = ExpressionContainer();
  ExpressionContainer<TypeDefinitionExpr> types = ExpressionContainer();

  @override
  bool hasNamedObject(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name);
  }
}

class FunctionScopeContext implements ScopeContext {
  ExpressionContainer<ConstantDefinitionExpr> constants = ExpressionContainer();
  ExpressionContainer<VariableDefinitionExpr> variables = ExpressionContainer();
  ExpressionContainer<FunctionDefinitionExpr> functions = ExpressionContainer();
  ExpressionContainer<TypeDefinitionExpr> types = ExpressionContainer();

  ScopeContext parentScope;
  FunctionScopeContext(this.parentScope);

  @override
  bool hasNamedObject(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name) || parentScope.hasNamedObject(name);
  }
}
