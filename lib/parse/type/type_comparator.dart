import 'package:tll/parse/type/type.dart';

class TypeComparator {
  static bool structTypeEquals(TLLStructType typeA, TLLStructType typeB) {
    return _structFieldsAreIdentical(typeA.fields, typeB.fields);
  }

  static bool typesIdentical(TLLType typeA, TLLType typeB) {
    switch (typeA) {
      case TLLBoolType _:
        return typeB is TLLBoolType;
      case TLLStringType _:
        return typeB is TLLStringType;
      case TLLIntType _:
        return typeB is TLLIntType;
      case TLLFloatType _:
        return typeB is TLLFloatType;
      case TLLBoolValueType _:
        return typeB is TLLBoolValueType && typeB.value == typeA.value;
      case TLLStringValueType _:
        return typeB is TLLStringValueType && typeB.value == typeA.value;
      case TLLIntValueType _:
        return typeB is TLLIntValueType && typeB.value == typeA.value;
      case TLLFloatValueType _:
        return typeB is TLLFloatValueType && typeB.value == typeA.value;
      case TLLFunctionType _:
        return typeB is TLLFunctionType &&
            typesIdentical(typeB.returnType, typeA.returnType) &&
            _listsAreIdentical(typeA.argumentTypes, typeB.argumentTypes);
      case TLLStructType _:
        return typeB is TLLStructType &&
            _structFieldsAreIdentical(typeB.fields, typeA.fields);
      case TLLSumType _:
        return (typeB is TLLSumType &&
                _listsAreIdenticalIgnoringOrder(
                    typeB.allowedTypes, typeA.allowedTypes)) ||
            (typeB is TLLAnonymousSumType &&
                _listsAreIdenticalIgnoringOrder(
                    typeB.allowedTypes, typeA.allowedTypes));
      case TLLAnonymousSumType _:
        return (typeB is TLLSumType &&
                _listsAreIdenticalIgnoringOrder(
                    typeB.allowedTypes, typeA.allowedTypes)) ||
            (typeB is TLLAnonymousSumType &&
                _listsAreIdenticalIgnoringOrder(
                    typeB.allowedTypes, typeA.allowedTypes));
    }
  }

  static bool _structFieldsAreIdentical(
      Map<String, TLLType> fieldsA, Map<String, TLLType> fieldsB) {
    if (fieldsA.keys.length != fieldsB.keys.length) {
      return false;
    }
    for (final key in fieldsA.keys) {
      TLLType? fieldBType = fieldsB[key];
      if (fieldBType == null) {
        return false;
      }
      if (!TypeComparator.typesIdentical(fieldBType, fieldsA[key]!)) {
        return false;
      }
    }
    return true;
  }

  static bool _listsAreIdentical(List<TLLType> typesA, List<TLLType> typesB) {
    if (typesA.length != typesB.length) {
      return false;
    }
    for (int i = 0; i < typesA.length; i++) {
      if (!typesIdentical(typesB[i], typesA[i])) {
        return false;
      }
    }
    return true;
  }

  static bool _listsAreIdenticalIgnoringOrder(
      List<TLLType> typesA, List<TLLType> typesB) {
    if (typesA.length != typesB.length) {
      return false;
    }
    // TODO marwin: do i also need to to compare it the other way round?
    for (final type in typesA) {
      if (!typesB.any((it) => TypeComparator.typesIdentical(it, type))) {
        return false;
      }
    }
    return true;
  }
}
