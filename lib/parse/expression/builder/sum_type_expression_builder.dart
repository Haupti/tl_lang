import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/expression/builder/convert/expression_converter.dart';
import 'package:tll/parse/expression/expression.dart';
import 'package:tll/parse/expression/expression_builder_context.dart';
import 'package:tll/parse/expression/location.dart';
import 'package:tll/parse/expression/type.dart';
import 'package:tll/parse/parser_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class SumTypeExpressionBuilder {
  static Expression build(SumTypeToken start, NameToken name,
      List<TokenGroup> arguments, ScopeContext parentContext) {
    if(parentContext.hasNamedObject(name.value)){
      throw ParserException.atToken("'${name.value}' already in scope", name);
    }

    List<TLLType> types = [];

    for (final tokenGroup in arguments) {
      Token token = TokenGroupConverter.toSingleOrThrow(tokenGroup, "").token;
      switch (token) {
        case IntToken _:
          types.add(TLLIntValueType(token.value));
        case StringToken _:
          types.add(TLLStringValueType(token.value));
        case FloatToken _:
          types.add(TLLFloatValueType(token.value));
        case BoolToken _:
          types.add(TLLBoolValueType(token.value));
        case NameToken _:
          types.add(_determineType(token, parentContext));
        case ObjectAccessToken _:
        case T1BracesOpenToken _:
        case T2BracesOpenToken _:
        case T3BracesOpenToken _:
        case T1BracesCloseToken _:
        case T2BracesCloseToken _:
        case T3BracesCloseToken _:
        case ConstToken _:
        case LetToken _:
        case DefunToken _:
        case StructTypeToken _:
        case SumTypeToken _:
        case CondToken _:
        case IfToken _:
          throw ParserException.atToken("unexpected token", token);
      }
    }

    TLLSumType sumType = TLLSumType(types);
    parentContext.addType(sumType);
    return SumTypeDefinitionExpr(sumType, Location.fromToken(start));
  }

  static TLLType _determineType(NameToken token, ScopeContext context){
    throw Exception("not yet implemented");
  }
}
