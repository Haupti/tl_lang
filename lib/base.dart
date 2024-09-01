import 'package:tll/parse/expression/expression_container.dart';
import 'package:tll/parse/type/type.dart';

class Base {
  static final TLLAnonymousSumType _numType =
      TLLAnonymousSumType([TLLIntType(), TLLFloatType()]);
  static final SmartMap<TLLType> _baseTypes = SmartMap.init({
    "int": TLLIntType(),
    "float": TLLFloatType(),
    "string": TLLStringType(),
    "bool": TLLBoolType()
  });
  static final SmartMap<TLLType> _baseFunctions = SmartMap.init({
    "*": TLLFunctionType(_numType, [_numType, _numType]),
    "+": TLLFunctionType(_numType, [_numType, _numType]),
    "-": TLLFunctionType(_numType, [_numType, _numType]),
    "/": TLLFunctionType(_numType, [_numType, _numType]),
  });

  static bool has(String name) {
    return _baseTypes.get(name) != null && _baseFunctions.get(name) != null;
  }

  static TLLType? getType(String name) {
    return _baseTypes.get(name);
  }

  static TLLType? getTypeOf(String name) {
    return getType(name) ?? _baseFunctions.get(name);
  }
}
