import 'package:tll/parse/collect/token_group.dart';
import 'package:tll/parse/tokenize/token.dart';

SingleTokenGroup nameT(String name){
  return SingleTokenGroup(NameToken(name, 0,0));
}
SingleTokenGroup intT(int value){
  return SingleTokenGroup(IntToken(value, 0,0));
}
