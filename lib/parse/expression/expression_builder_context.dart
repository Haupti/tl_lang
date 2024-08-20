import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

sealed class ScopeContext {
  bool hasNamedObject(String value);

  void addVariable(NameToken name, TLLType type) {}
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

  @override
  void addVariable(NameToken name, TLLType type) {
    switch (variables.add(name.value, type)) {
      case SmartMapActionSuccess _:
        return;
      case SmartMapActionFailure _:
        throw ParserException.atToken("variable already in scope", name);
    }
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

  @override
  void addVariable(NameToken name, TLLType type) {
    switch (variables.add(name.value, type)) {
      case SmartMapActionSuccess _:
        return;
      case SmartMapActionFailure _:
        throw ParserException.atToken("variable already in scope", name);
    }
  }
}
