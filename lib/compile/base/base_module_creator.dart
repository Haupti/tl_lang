import 'package:tll/parse/expression/primitive_value.dart';

class BaseFunctionCreator {
  static String _plus(NumValue valA, NumValue valB) {
    return "${valA.value} + ${valB.value}";
  }

  static String _minus(NumValue valA, NumValue valB) {
    return "${valA.value} - ${valB.value}";
  }

  static String _times(NumValue valA, NumValue valB) {
    return "${valA.value} * ${valB.value}";
  }

  static String _divided(NumValue valA, NumValue valB) {
    return "${valA.value} / ${valB.value}";
  }

  static String _modulo(NumValue valA, NumValue valB) {
    return "${valA.value} % ${valB.value}";
  }

  static String _equalsJS(PrimitiveValue valA, PrimitiveValue valB) {
    return "${valA.value} === ${valB.value}";
  }

  static Map<String, Function> baseFns = {
    "+": _plus,
    "-": _minus,
    "*": _times,
    "/": _divided,
    "%": _modulo,
    "=": _equalsJS,
  };
}
