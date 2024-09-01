import 'package:tll/base.dart';
import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

sealed class ScopeContext {
  TLLType? getTypeOf(String name);
  TLLType? findType(String name);
  void addVariable(NameToken name, TLLType type);

  void addConstant(NameToken name, TLLType type);
  void addType(NameToken name, TLLType type);
  void addFunction(NameToken name, TLLType type);
}

class ModuleScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  bool _isFreeToDefine(String name) {
    return !constants.has(name) &&
        !variables.has(name) &&
        !functions.has(name) &&
        !types.has(name) &&
        !Base.has(name);
  }

  @override
  void addVariable(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  void addConstant(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  TLLType? getTypeOf(String name) {
    return constants.get(name) ??
        variables.get(name) ??
        functions.get(name) ??
        Base.getTypeOf(name);
  }

  @override
  void addType(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    types.add(name.value, type);
  }

  @override
  TLLType? findType(String name) {
    return Base.getType(name) ?? types.get(name);
  }

  @override
  void addFunction(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    functions.add(name.value, type);
  }
}

class FunctionScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> params = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  ScopeContext parentScope;
  FunctionScopeContext(this.parentScope);

  bool _isFreeToDefine(String name) {
    return !params.has(name) &&
        !constants.has(name) &&
        !variables.has(name) &&
        !functions.has(name) &&
        !types.has(name) &&
        !Base.has(name) &&
        parentScope.findType(name) == null;
  }

  @override
  void addVariable(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  void addConstant(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  TLLType? getTypeOf(String name) {
    return params.get(name) ??
        constants.get(name) ??
        variables.get(name) ??
        functions.get(name) ??
        Base.getTypeOf(name) ??
        parentScope.getTypeOf(name);
  }

  @override
  void addType(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope (types cannot be shadowed)",
          name);
    }
    types.add(name.value, type);
  }

  @override
  void addFunction(NameToken name, TLLType type) {
    if (!_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    functions.add(name.value, type);
  }

  @override
  TLLType? findType(String name) {
    return Base.getType(name) ?? types.get(name) ?? parentScope.findType(name);
  }

  void addParam(NameToken argumentName, TLLType argumentType) {
    if (params.get(argumentName.value) != null) {
      throw ParserException.atToken(
          "a parameter with this name already exists", argumentName);
    }
    params.add(argumentName.value, argumentType);
  }
}
