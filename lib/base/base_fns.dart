import 'package:tll/compile/base/base_module_creator.dart';
import 'package:tll/parse/type/type.dart';

final TLLAnonymousSumType numType =
    TLLAnonymousSumType([TLLIntType(), TLLFloatType()]);
final TLLAnonymousSumType primitiveType = TLLAnonymousSumType(
    [TLLStringType(), TLLBoolType(), TLLIntType(), TLLFloatType()]);

List<BaseFunction> baseFunctions = [
  PlusBaseFunction(),
  MinusBaseFunction(),
  TimesBaseFunction(),
  DividedBaseFunction(),
  ModuloBaseFunction(),
  EqualsBaseFunction()
];

sealed class BaseFunction {
  String get name;
  TLLType get type;
  Function get compile;
}

class PlusBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.plus;
  @override
  String name = "+";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class MinusBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.minus;
  @override
  String name = "-";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class TimesBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.times;
  @override
  String name = "*";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class DividedBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.divided;
  @override
  String name = "/";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class ModuloBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.modulo;
  @override
  String name = "/";
  @override
  TLLType type = TLLFunctionType(numType, [numType, numType]);
}

class EqualsBaseFunction implements BaseFunction {
  @override
  Function compile = BaseFunctionCreator.equalsJS;
  @override
  String name = "=";
  @override
  TLLType type = TLLFunctionType(TLLBoolType(), [primitiveType, primitiveType]);
}
