import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

sealed class ScopeContext {
  bool hasNamedObject(String value);
  TLLType? getTypeOf(String name);
  void addVariable(NameToken name, TLLType type) {}

  void addConstant(NameToken name, TLLType type) {}
}

class ModuleScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  @override
  bool hasNamedObject(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name);
  }

  bool _isFreeToDefine(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name);
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
}

class FunctionScopeContext implements ScopeContext {
  SmartMap<TLLType> constants = SmartMap();
  SmartMap<TLLType> variables = SmartMap();
  SmartMap<TLLType> functions = SmartMap();
  SmartMap<TLLType> types = SmartMap();

  ScopeContext parentScope;
  FunctionScopeContext(this.parentScope);

  @override
  bool hasNamedObject(String name) {
    return constants.has(name) ||
        variables.has(name) ||
        functions.has(name) ||
        parentScope.hasNamedObject(name);
  }

  bool _isFreeToDefine(String name) {
    return constants.has(name) || variables.has(name) || functions.has(name);
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
}
