import 'package:tll/parse/type/type_checker.dart';
import 'package:tll/parse/type/type_comparator.dart';

sealed class TLLType {
  // TODO maybe this should not be used. use suffices instead. probably always...
  bool equals(TLLType other) {
    return TypeComparator.typesIdentical(this, other);
  }

  bool suffices(TLLType argumentType) {
    return TypeChecker.typeASufficesB(this, argumentType);
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
