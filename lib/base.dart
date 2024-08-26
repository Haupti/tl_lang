import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/type/type.dart';

class Base {
  static final SmartMap<TLLType> _baseTypes = SmartMap.init({
    "int": TLLIntType(),
    "float": TLLFloatType(),
    "string": TLLStringType(),
    "bool": TLLBoolType()
  });
  static bool has(String name) {
    return _baseTypes.get(name) != null;
  }

  static TLLType? get(String name) {
    return _baseTypes.get(name);
  }
}
