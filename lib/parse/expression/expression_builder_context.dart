import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

sealed class ScopeContext {
  bool hasNamedValue(String value);
  TLLType? getTypeOf(String name);
  TLLType? findType(String name);
  void addVariable(NameToken name, TLLType type) {}

  void addConstant(NameToken name, TLLType type) {}
  void addType(NameToken name, TLLType type) {}
}

class ModuleScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  @override
  bool hasNamedValue(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name);
  }

  bool _isFreeToDefine(String name) {
    return !constants.has(name) &&
        !variables.has(name) &&
        !functions.has(name) &&
        !types.has(name);
  }

  @override
  void addVariable(NameToken name, TLLType type) {
    if (_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  void addConstant(NameToken name, TLLType type) {
    if (_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  TLLType? getTypeOf(String name) {
    return constants.get(name) ?? variables.get(name) ?? functions.get(name);
  }

  @override
  void addType(NameToken name, TLLType type) {
    if (hasNamedValue(name.value) || types.has(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    types.add(name.value, type);
  }

  @override
  TLLType? findType(String name) {
    return types.get(name);
  }
}

class FunctionScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  ScopeContext parentScope;
  FunctionScopeContext(this.parentScope);

  @override
  bool hasNamedValue(String name) {
    return constants.has(name) ||
        variables.has(name) ||
        functions.has(name) ||
        parentScope.hasNamedValue(name);
  }

  bool _isFreeToDefine(String name) {
    return !constants.has(name) &&
        !variables.has(name) &&
        !functions.has(name) &&
        !types.has(name) &&
        parentScope.findType(name) == null;
  }

  @override
  void addVariable(NameToken name, TLLType type) {
    if (_isFreeToDefine(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    variables.add(name.value, type);
  }

  @override
  void addConstant(NameToken name, TLLType type) {
    if (_isFreeToDefine(name.value)) {
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
        parentScope.getTypeOf(name);
  }

  @override
  void addType(NameToken name, TLLType type) {
    if (hasNamedValue(name.value) || types.has(name.value)) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken in current scope", name);
    }
    if (parentScope.findType(name.value) != null) {
      throw ParserException.atToken(
          "the name '${name.value}' is already taken. types cannot be shadowed",
          name);
    }
    types.add(name.value, type);
  }

  @override
  TLLType? findType(String name) {
    return types.get(name) ?? parentScope.findType(name);
  }
}
