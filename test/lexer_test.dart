import 'package:tll/parse/tokenize/lexer.dart';
import 'package:tll/parse/tokenize/lexer_exception.dart';
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
    expect(tokens.map((it) => it.show).toList(),
        ['(','name:let','name:name', 'str:"steve (the)\n incredible"',')']);
  });
  test('lexer finds multiline string token positions', () {
    List<Token> tokens =
        Lexer.tokenize('(let name "steve (the)\n incredible")');
    String pos = tokens.map((it) => "(${it.row}/${it.col})").join("");

    expect(pos, "(0/0)(0/1)(0/5)(0/10)(1/12)");
  });
  test('lexer finds float token positions', () {
    List<Token> tokens =
        Lexer.tokenize('(defun () fnname\n (print 123.1))');
    String pos = tokens.map((it) => "(${it.row}/${it.col})").join("");

    expect(tokens.map((it) => it.show).toList(),
        ['(','name:defun','(',')','name:fnname', '(', 'name:print', 'float:123.1',')',')']);
    expect(pos, "(0/0)(0/1)(0/7)(0/8)(0/10)(1/1)(1/2)(1/8)(1/13)(1/14)");
  });
}
