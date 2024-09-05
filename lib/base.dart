import 'package:tll/base/base_fns.dart';
import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/type/type.dart';

class Base {
  static final SmartMap<TLLType> _baseTypes = SmartMap.init({
    "int": TLLIntType(),
    "float": TLLFloatType(),
    "string": TLLStringType(),
    "bool": TLLBoolType()
  });
  static final SmartMap<TLLType> _baseFunctions = _initBaseFunctions();
  static bool has(String name) {
    return _baseTypes.get(name) != null && _baseFunctions.get(name) != null;
  }

  static TLLType? getType(String name) {
    return _baseTypes.get(name);
  }

  static TLLType? getTypeOf(String name) {
    return getType(name) ?? _baseFunctions.get(name);
  }

  static SmartMap<TLLType> _initBaseFunctions() {
    SmartMap<TLLType> baseFunctionsMap = SmartMap();
    for (final fn in baseFunctions) {
      switch (fn) {
        case PlusBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case MinusBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case TimesBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case DividedBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case ModuloBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case EqualsBaseFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
      }
    }
    return baseFunctionsMap;
  }
}
