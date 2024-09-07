import 'package:tll/type/type.dart';

final TLLAnonymousSumType numType =
    TLLAnonymousSumType([TLLIntType(), TLLFloatType()]);
final TLLAnonymousSumType primitiveType = TLLAnonymousSumType(
    [TLLStringType(), TLLBoolType(), TLLIntType(), TLLFloatType()]);

List<CoreFunction> coreFunctions = [
  PlusCoreFunction(),
  MinusCoreFunction(),
  TimesCoreFunction(),
  DividedCoreFunction(),
  ModuloCoreFunction(),
  EqualsCoreFunction()
];

sealed class CoreFunction {
  String get name;
  TLLType get type;
}

class PlusCoreFunction implements CoreFunction {
  @override
  String name = "+";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class MinusCoreFunction implements CoreFunction {
  @override
  String name = "-";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class TimesCoreFunction implements CoreFunction {
  @override
  String name = "*";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class DividedCoreFunction implements CoreFunction {
  @override
  String name = "/";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class ModuloCoreFunction implements CoreFunction {
  @override
  String name = "%";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class EqualsCoreFunction implements CoreFunction {
  @override
  String name = "=";
  @override
  TLLType type = TLLFunctionType(TLLBoolType(), [primitiveType, primitiveType]);
}
