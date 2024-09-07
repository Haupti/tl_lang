import 'package:tll/type/type.dart';
import 'package:tll/type/type_comparator.dart';

class TypeChecker {
  static bool typeASufficesB(TLLType typeA, TLLType typeB) {
    switch (typeA) {
      case TLLBoolType _:
        return typeB is TLLBoolType || _typeASufficeSumTypeB(typeA, typeB);
      case TLLIntType _:
        return typeB is TLLIntType || _typeASufficeSumTypeB(typeA, typeB);
      case TLLFloatType _:
        return typeB is TLLFloatType || _typeASufficeSumTypeB(typeA, typeB);
      case TLLStringType _:
        return typeB is TLLStringType || _typeASufficeSumTypeB(typeA, typeB);
      case TLLIntValueType _:
        return typeB is TLLIntType ||
            (typeB is TLLIntValueType && typeA.value == typeB.value) ||
            _typeASufficeSumTypeB(typeA, typeB);
      case TLLFloatValueType _:
        return typeB is TLLFloatType ||
            (typeB is TLLFloatValueType && typeA.value == typeB.value) ||
            _typeASufficeSumTypeB(typeA, typeB);
      case TLLStringValueType _:
        return typeB is TLLStringType ||
            (typeB is TLLStringValueType && typeA.value == typeB.value) ||
            _typeASufficeSumTypeB(typeA, typeB);
      case TLLBoolValueType _:
        return typeB is TLLBoolType ||
            (typeB is TLLBoolValueType && typeA.value == typeB.value) ||
            _typeASufficeSumTypeB(typeA, typeB);
      case TLLStructType _:
        return typeB is TLLStructType &&
            TypeComparator.structTypeEquals(typeB, typeA);
      case TLLAnonymousSumType _:
        return typeA.allowedTypes.every((it) => it.suffices(typeB));
      case TLLSumType _:
        return typeA.allowedTypes.every((it) => it.suffices(typeB));
      case TLLFunctionType _:
        return typeB is TLLFunctionType &&
            typeA.returnType.suffices(typeB.returnType) &&
            _typesASufficeTypesBInOrder(
                typeA.argumentTypes, typeB.argumentTypes);
    }
  }

  static bool _typesASufficeTypesBInOrder(
      List<TLLType> typesA, List<TLLType> typesB) {
    if (typesA.length != typesB.length) {
      return false;
    }
    for (int i = 0; i < typesA.length; i++) {
      if (!typeASufficesB(typesB[i], typesA[i])) {
        return false;
      }
    }
    return true;
  }

  static bool _typeASufficeSumTypeB(TLLType typeA, TLLType typeB) {
    return (typeB is TLLSumType &&
            _typeASufficeOneOfB(typeA, typeB.allowedTypes)) ||
        (typeB is TLLAnonymousSumType &&
            _typeASufficeOneOfB(typeA, typeB.allowedTypes));
  }

  static bool _typeASufficeOneOfB(TLLType typeA, List<TLLType> typesB) {
    for (final typeB in typesB) {
      if (typeASufficesB(typeA, typeB)) {
        return true;
      }
    }
    return false;
  }
}
