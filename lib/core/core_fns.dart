import 'package:tll/compile/core/core_functions_creator.dart';
import 'package:tll/parse/type/type.dart';

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
  Function get compile;
}

class PlusCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.plus;
  @override
  String name = "+";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class MinusCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.minus;
  @override
  String name = "-";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class TimesCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.times;
  @override
  String name = "*";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class DividedCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.divided;
  @override
  String name = "/";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class ModuloCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.modulo;
  @override
  String name = "%";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class EqualsCoreFunction implements CoreFunction {
  @override
  Function compile = CoreFunctionCreator.equalsJS;
  @override
  String name = "=";
  @override
  TLLType type = TLLFunctionType(TLLBoolType(), [primitiveType, primitiveType]);
}
