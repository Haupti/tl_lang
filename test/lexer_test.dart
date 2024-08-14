import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/token.dart';
import 'package:test/test.dart';

void main() {
  test('lexer throws', () {
    expect(() => Lexer.tokenize("(hi.my.name! is 123)"),
        throwsA(isA<LexerException>()));
  });
  test('lexer doesnt throw', () {
    List<Token> tokens = Lexer.tokenize("(hi.my.name is 123)");
    expect(tokens.map((it) => it.show).join(" "),
        "( access:hi.my.name name:is int:123 )");
  });
  test('lexer finds string', () {
    List<Token> tokens =
        Lexer.tokenize('(let name "steve (the) incredible")');
    expect(tokens.map((it) => it.show).join(" "),
        '( name:let name:name str:"steve (the) incredible" )');
  });
  test('lexer finds multiline string', () {
    List<Token> tokens =
        Lexer.tokenize('(let name "steve (the)\n incredible")');
    expect(tokens.map((it) => it.show).join(" "),
        '( name:let name:name str:"steve (the)\n incredible" )');
  });
}
