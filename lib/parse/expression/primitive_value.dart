sealed class PrimitiveValue {
  get value;
}

sealed class NumValue {
  get value;
}

class IntValue implements PrimitiveValue, NumValue {
  @override
  int value;
  IntValue(this.value);
}

class FloatValue implements PrimitiveValue, NumValue {
  @override
  double value;
  FloatValue(this.value);
}

class StringValue implements PrimitiveValue {
  @override
  String value;
  StringValue(this.value);
}

class BoolValue implements PrimitiveValue {
  @override
  bool value;
  BoolValue(this.value);
}
