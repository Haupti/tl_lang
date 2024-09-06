import 'package:tll/parse/expression/primitive_value.dart';

class CoreFunctionCreator {
  static String plus(NumValue valA, NumValue valB) {
    return "${valA.value} + ${valB.value}";
  }

  static String minus(NumValue valA, NumValue valB) {
    return "${valA.value} - ${valB.value}";
  }

  static String times(NumValue valA, NumValue valB) {
    return "${valA.value} * ${valB.value}";
  }

  static String divided(NumValue valA, NumValue valB) {
    return "${valA.value} / ${valB.value}";
  }

  static String modulo(NumValue valA, NumValue valB) {
    return "${valA.value} % ${valB.value}";
  }

  static String equalsJS(PrimitiveValue valA, PrimitiveValue valB) {
    return "${valA.value} === ${valB.value}";
  }
}
