import 'dart:math';

import 'package:test/test.dart';
import 'package:tll/parse/type/type.dart';
import 'package:tll/parse/type/type_checker.dart';

check(TLLType a, TLLType b) => TypeChecker.typeASufficesB(a, b);

TLLIntType ind() => TLLIntType();
TLLIntValueType intV(int v) => TLLIntValueType(v);
TLLFloatType float() => TLLFloatType();
TLLFloatValueType floatV(double v) => TLLFloatValueType(v);
TLLStringType string() => TLLStringType();
TLLStringValueType stringV(String v) => TLLStringValueType(v);
TLLBoolType bOOl() => TLLBoolType();
TLLBoolValueType boolV(bool v) => TLLBoolValueType(v);
TLLAnonymousSumType asum(List<TLLType> v) => TLLAnonymousSumType(v);
TLLSumType sum(List<TLLType> v) =>
    TLLSumType(Random().nextInt(10000).toString(), v);

void main() {
  test("identical types suffice each other", () {
    expect(check(ind(), ind()), true);
    expect(check(float(), float()), true);
    expect(check(string(), string()), true);
    expect(check(bOOl(), bOOl()), true);
  });
  test("value types suffice identical value types", () {
    expect(check(intV(1), intV(1)), true);
    expect(check(floatV(2.5), floatV(2.5)), true);
    expect(check(stringV("hi"), stringV("hi")), true);
    expect(check(boolV(true), boolV(true)), true);
  });
  test("value types suffice corresponding general type", () {
    expect(check(intV(1), ind()), true);
    expect(check(floatV(2.5), float()), true);
    expect(check(stringV("hi"), string()), true);
    expect(check(boolV(true), bOOl()), true);
  });
  test("value types suffice sum type", () {
    expect(check(intV(1), sum([ind(), string()])), true);
    expect(check(floatV(2.5), sum([floatV(2.5), floatV(1.5)])), true);
    expect(check(stringV("hi"), sum([stringV("hi"), stringV("mom")])), true);
    expect(check(boolV(true), sum([intV(1), boolV(true)])), true);
  });
  test("value types suffice anonymous sum type", () {
    expect(check(intV(1), asum([ind(), string()])), true);
    expect(check(floatV(2.5), asum([floatV(2.5), floatV(1.5)])), true);
    expect(check(stringV("hi"), asum([stringV("hi"), stringV("mom")])), true);
    expect(check(boolV(true), asum([intV(1), boolV(true)])), true);
  });
  test("sum types suffice each other", () {
    expect(check(asum([intV(1)]), asum([ind(), string()])), true);
    expect(
        check(asum([intV(1), stringV("hi")]), asum([ind(), string()])), true);
    expect(
        check(asum([stringV("hiI"), stringV("hi")]),
            asum([stringV("hiI"), stringV("hi"), stringV("mom")])),
        true);
  });
  test("struct types suffice each other", () {
    expect(
        check(TLLStructType("a", {"hi": string()}),
            TLLStructType("b", {"hi": string()})),
        true);
    expect(
        check(TLLStructType("a", {"hi": string(), "mom": stringV("hi")}),
            TLLStructType("b", {"hi": string(), "mom": stringV("hi")})),
        true);
  });
}
