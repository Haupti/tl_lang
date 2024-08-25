sealed class PrimitiveValue {}

class IntValue implements PrimitiveValue {
  int value;
  IntValue(this.value);
}

class FloatValue implements PrimitiveValue {
  double value;
  FloatValue(this.value);
}

class StringValue implements PrimitiveValue {
  String value;
  StringValue(this.value);
}

class BoolValue implements PrimitiveValue {
  bool value;
  BoolValue(this.value);
}
