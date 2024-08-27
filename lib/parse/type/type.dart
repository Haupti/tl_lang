import 'package:tll/parse/type/type_comparator.dart';

sealed class TLLType {
  bool _typesEqual(List<TLLType> typesA, List<TLLType> typesB) {
    if (typesA.length != typesB.length) {
      return false;
    }
    for (int i = 0; i < typesB.length; i++) {
      if (typesA[i] != typesB[i]) {
        return false;
      }
    }
    return true;
  }

  bool equals(TLLType other) {
    TLLType me = this;
    switch (other) {
      case TLLBoolType _:
        return this is TLLBoolType;
      case TLLIntType _:
        return this is TLLIntType;
      case TLLFloatType _:
        return this is TLLFloatType;
      case TLLStringType _:
        return this is TLLStringType;
      case TLLIntValueType _:
        return me is TLLIntValueType && me.value == other.value;
      case TLLFloatValueType _:
        return me is TLLFloatValueType && me.value == other.value;
      case TLLStringValueType _:
        return me is TLLStringValueType && me.value == other.value;
      case TLLBoolValueType _:
        return me is TLLBoolValueType && me.value == other.value;
      case TLLFunctionType _:
        if (me is! TLLFunctionType) {
          return false;
        }
        if (other.returnType != me.returnType) {
          return false;
        }
        return _typesEqual(other.argumentTypes, me.argumentTypes);
      case TLLStructType _:
        return me is TLLStructType &&
            TypeComparator.structTypeEquals(me, other);
      case TLLAnonymousSumType _:
        if (me is TLLAnonymousSumType) {
          return _typesEqual(other.allowedTypes, me.allowedTypes);
        }
        if (me is TLLSumType) {
          return _typesEqual(other.allowedTypes, me.allowedTypes);
        }
        return false;
      case TLLSumType _:
        if (me is TLLAnonymousSumType) {
          return _typesEqual(other.allowedTypes, me.allowedTypes);
        }
        if (me is TLLSumType) {
          return _typesEqual(other.allowedTypes, me.allowedTypes);
        }
        return false;
    }
  }

  bool suffices(TLLType argumentType) {
    /*
       when does what suffice:
         X exact matches always suffice
         _ value types suffice their corresponding general type BUT NOT VICE VERSA
         _ value types suffice sum types that contain at least one type which they suffice
         _ sum types suffice other sum types if all their possible options are in the others possible options OR suffice them:
            e.g. : (type "hi" int "mom") suffices (type string int) and (type "hi" "mom" "dad" int)
         _ struct types only suffice on excat match
         _ function types suffice if their arguments are equal or more general and their return type is equal or more specific than the others 
       */
    TLLType me = this;
    switch (me) {
      case TLLBoolType _:
        return argumentType is TLLBoolType || _iSufficeSumType(argumentType);
      case TLLIntType _:
        return argumentType is TLLIntType || _iSufficeSumType(argumentType);
      case TLLFloatType _:
        return argumentType is TLLFloatType || _iSufficeSumType(argumentType);
      case TLLStringType _:
        return argumentType is TLLStringType || _iSufficeSumType(argumentType);
      case TLLIntValueType _:
        return argumentType is TLLIntType ||
            (argumentType is TLLIntValueType &&
                me.value == argumentType.value) ||
            _iSufficeSumType(argumentType);
      case TLLFloatValueType _:
        return argumentType is TLLFloatType ||
            (argumentType is TLLFloatValueType &&
                me.value == argumentType.value) ||
            _iSufficeSumType(argumentType);
      case TLLStringValueType _:
        return argumentType is TLLStringType ||
            (argumentType is TLLStringValueType &&
                me.value == argumentType.value) ||
            _iSufficeSumType(argumentType);
      case TLLBoolValueType _:
        return argumentType is TLLBoolType ||
            (argumentType is TLLBoolValueType &&
                me.value == argumentType.value) ||
            _iSufficeSumType(argumentType);
      case TLLFunctionType _:
        throw Exception("L");
      case TLLStructType _:
        return argumentType is TLLStructType &&
            TypeComparator.structTypeEquals(argumentType, me);
      case TLLAnonymousSumType _:
        return me.allowedTypes.every((it) => it.suffices(argumentType));
      case TLLSumType _:
        return me.allowedTypes.every((it) => it.suffices(argumentType));
    }
  }

  bool _iSufficeSumType(TLLType argumentType) {
    return (argumentType is TLLSumType &&
            _iSufficeOneOf(argumentType.allowedTypes)) ||
        (argumentType is TLLAnonymousSumType &&
            _iSufficeOneOf(argumentType.allowedTypes));
  }

  bool _iSufficeOneOf(List<TLLType> types) {
    for (final t in types) {
      if (suffices(t)) {
        return true;
      }
    }
    return false;
  }

  bool isBool() {
    return this is TLLBoolType || this is TLLBoolValueType;
  }

  String show() {
    TLLType type = this;
    switch (type) {
      case TLLBoolValueType _:
        return '${type.value}';
      case TLLBoolType _:
        return 'bool';
      case TLLIntValueType _:
        return '${type.value}';
      case TLLIntType _:
        return 'int';
      case TLLFloatValueType _:
        return '${type.value}';
      case TLLFloatType _:
        return 'float';
      case TLLStringValueType _:
        return type.value;
      case TLLStringType _:
        return 'string';
      case TLLFunctionType _:
        return '(${type.argumentTypes.map((it) => it.show()).join(" ")} ${type.returnType.show()})';
      case TLLStructType _:
        return '(struct ${type.name} ${type.fields.keys.map((it) => "${type.fields[it]!.show()} $it").join(" ")})';
      case TLLSumType _:
        return '(type ${type.name} ${type.allowedTypes.map((it) => it.show()).join(" ")})';
      case TLLAnonymousSumType _:
        return '(type ${type.allowedTypes.map((it) => it.show()).join(" ")})';
    }
  }
}

class TLLFunctionType extends TLLType {
  TLLType returnType;
  List<TLLType> argumentTypes;
  TLLFunctionType(this.returnType, this.argumentTypes);
}

class TLLStructType extends TLLType {
  String name;
  Map<String, TLLType> fields;

  TLLStructType(this.name, this.fields);

  TLLType? getTypeOfField(String accessedName) {
    return fields[accessedName];
  }
}

class TLLSumType extends TLLType {
  String name;
  List<TLLType> allowedTypes;
  TLLSumType(this.name, this.allowedTypes);
}

class TLLAnonymousSumType extends TLLType {
  List<TLLType> allowedTypes;
  TLLAnonymousSumType(this.allowedTypes);
}

class TLLIntValueType extends TLLType {
  int value;
  TLLIntValueType(this.value);
}

class TLLFloatValueType extends TLLType {
  double value;
  TLLFloatValueType(this.value);
}

class TLLStringValueType extends TLLType {
  String value;
  TLLStringValueType(this.value);
}

class TLLBoolValueType extends TLLType {
  bool value;
  TLLBoolValueType(this.value);
}

class TLLBoolType extends TLLType {}

class TLLIntType extends TLLType {}

class TLLFloatType extends TLLType {}

class TLLStringType extends TLLType {}
