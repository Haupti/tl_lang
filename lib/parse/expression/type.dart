sealed class TLLType {
  bool suffices(TLLType argumentTyp) {
    // TODO: check if the current type fulfils the criteria to be the argument type
    throw Exception("not yet implemented");
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
