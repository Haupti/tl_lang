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
        if (me is! TLLStructType) {
          return false;
        }
        if (other.fields.keys.length != me.fields.keys.length) {
          return false;
        }
        for (final key in other.fields.keys) {
          if (other.fields[key] != me.fields[key]) {
            return false;
          }
        }
        return true;
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

  bool suffices(TLLType argumentTyp) {
    throw Exception("not yet implemented");
    /*
       when does what suffice:
         * exact matches always suffice
         * value types suffice their corresponding general type BUT NOT VICE VERSA
         * value types suffice sum types that contain at least one type which they suffice
         * sum types suffice other sum types if all their possible options are in the others possible options OR suffice them:
            e.g. : (type "hi" int "mom") suffices (type string int) and (type "hi" "mom" "dad" int)
         * struct types only suffice on excat match
         * function types suffice if their arguments are equal or more general and their return type is equal or more specific than the others 
       */
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
