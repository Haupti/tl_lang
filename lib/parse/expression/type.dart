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
  TLLType? getTypeOfField(String accessedName) {
    throw Exception("not yet implemented");
  }
}
