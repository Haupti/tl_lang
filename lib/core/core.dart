import 'package:tll/core/core_fns.dart';
import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/type/type.dart';

class Core {
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
    for (final fn in coreFunctions) {
      switch (fn) {
        case PlusCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case MinusCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case TimesCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case DividedCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case ModuloCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
        case EqualsCoreFunction _:
          baseFunctionsMap.add(fn.name, fn.type);
      }
    }
    return baseFunctionsMap;
  }
}
