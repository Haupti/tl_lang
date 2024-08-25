sealed class TLLType {
  bool matches(TLLType type) {
    switch (type) {
      case TLLFunctionType _:
        TLLType me = this;
        if (me is TLLFunctionType && me.returnType.matches(type.returnType)) {
          if (me.argumentTypes.length != type.argumentTypes.length) {
            return false;
          }
          for (int i = 0; i < me.argumentTypes.length; i++) {
            if (!me.argumentTypes[i].matches(type.argumentTypes[i])) {
              return false;
            }
          }
        } else {
          return false;
        }
        return true;
      default:
        throw Exception("not yet implemented");
    }
  }

  bool suffices(TLLType argumentTyp) {
    // TODO: check if the current type fulfils the criteria to be the argument type
    throw Exception("not yet implemented");
  }

  bool isBool() {
    return this is TLLBoolType || this is TLLBoolValueType;
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
