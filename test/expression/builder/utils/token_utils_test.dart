import 'package:test/test.dart';
import 'package:tll/parse/expression/builder/utils/token_utils.dart';
import 'package:tll/parse/expression/scope.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:tll/parse/type/type.dart';

void main() {
  test("type of accessed object (1d)", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(NameToken("myob", 0, 0),
        TLLStructType("MYTYPE", {"field1d": TLLIntType()}));
    var objectAccessToken = ObjectAccessToken("myob", "field1d", [], 0, 0);
    TLLType result =
        TokenUtils.toTypeOfAccessedValue(objectAccessToken, moduleScopeContext);
    expect(result is TLLIntType, true);
  });

  test("type of accessed object (2d)", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(
        NameToken("myob", 0, 0),
        TLLStructType("MYTYPE", {
          "field1d": TLLStructType("MYINNERTYPE", {"subfield": TLLStringType()})
        }));
    var objectAccessToken =
        ObjectAccessToken("myob", "field1d", ["subfield"], 0, 0);
    TLLType result =
        TokenUtils.toTypeOfAccessedValue(objectAccessToken, moduleScopeContext);
    expect(result is TLLStringType, true);
  });

  test("type of accessed object (2d) does not exist throws", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(
        NameToken("myob", 0, 0),
        TLLStructType("MYTYPE", {
          "field1d":
              TLLStructType("MYINNERTYPE", {"otherfield": TLLStringType()})
        }));
    var objectAccessToken =
        ObjectAccessToken("myob", "field1d", ["subfield"], 0, 0);
    expect(
        () => TokenUtils.toTypeOfAccessedValue(
            objectAccessToken, moduleScopeContext),
        throwsException);
  });
  test("type of accessed object (1d) does not exist throws", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(NameToken("myob", 0, 0),
        TLLStructType("MYTYPE", {"fieldNAME": TLLIntType()}));
    var objectAccessToken =
        ObjectAccessToken("myob", "field1d", ["subfield"], 0, 0);
    expect(
        () => TokenUtils.toTypeOfAccessedValue(
            objectAccessToken, moduleScopeContext),
        throwsException);
  });
  test("type of accessed object (0d) incorrect type throws", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(NameToken("myob", 0, 0), TLLIntType());
    var objectAccessToken =
        ObjectAccessToken("myob", "field1d", ["subfield"], 0, 0);
    expect(
        () => TokenUtils.toTypeOfAccessedValue(
            objectAccessToken, moduleScopeContext),
        throwsException);
  });

  test("type of accessed object (0d) does not exist type throws", () {
    var moduleScopeContext = ModuleScopeContext();
    moduleScopeContext.addConstant(NameToken("OTHER", 0, 0), TLLIntType());
    var objectAccessToken = ObjectAccessToken("myob", "field1d", [], 0, 0);
    expect(
        () => TokenUtils.toTypeOfAccessedValue(
            objectAccessToken, moduleScopeContext),
        throwsException);
  });
}
