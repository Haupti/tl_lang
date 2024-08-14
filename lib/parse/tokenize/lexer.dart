import 'package:tll/parse/tokenize/token.dart';

class LexerException implements Exception {
  final String message;
  final int row;
  final int col;
  LexerException(this.message, this.row, this.col);
  @override
  String toString() => "ERROR at ($row|$col): $message.";
}

class Lexer {
  static List<Token> tokenize(String code) {
    int row = 0;
    int col = 0;
    bool isInString = false;
    String currentWord = "";

    List<Token> tokens = [];

    addWord() {
      if (currentWord == "") {
        return;
      } else if (_containsOnly(currentWord, "0123456789")) {
        tokens.add(IntToken(int.parse(currentWord), row, col));
      } else if (_containsOnly(currentWord, "0123456789.")) {
        tokens.add(FloatToken(double.parse(currentWord), row, col));
      } else if (currentWord == "true" || currentWord == "false") {
        tokens.add(BoolToken(bool.parse(currentWord), row, col));
      } else if (currentWord.contains(".")) {
        List<String> split = currentWord.split(".");
        if (split.length < 2) {
          throw LexerException("this cannot start or end with '.'", row, col);
        }
        if (_isValidName(split[0]) &&
            _isValidName(split[1]) &&
            split.sublist(2).every((it) => _isValidName(it))) {
          tokens.add(ObjectAccessToken(
              split[0], split[1], split.sublist(2), row, col));
        } else {
          throw LexerException("contains invalid character for name", row, col);
        }
      } else if (_isValidName(currentWord)) {
        tokens.add(NameToken(currentWord, row, col));
      }
      currentWord = "";
    }

    addToken(Token token, String char) {
      if (!isInString) {
        addWord();
        tokens.add(token);
      } else {
        currentWord += char;
      }
    }

    for (int i = 0; i < code.length; i++) {
      col++;
      String char = code[i];
      switch (char) {
        case '(':
          addToken(T1BracesOpenToken(row, col), char);
        case '[':
          addToken(T2BracesOpenToken(row, col), char);
        case '{':
          addToken(T3BracesOpenToken(row, col), char);
        case ')':
          addToken(T1BracesCloseToken(row, col), char);
        case ']':
          addToken(T2BracesCloseToken(row, col), char);
        case '}':
          addToken(T3BracesCloseToken(row, col), char);
        case '\n':
          currentWord += char;
          if (!isInString) {
            addWord();
          }
          col = 0;
          row++;
        case '"':
          currentWord += char;
          isInString = !isInString;
          if (!isInString) {
            tokens.add(StringToken(currentWord, row, col));
          }
        case ' ':
          if (!isInString) {
            addWord();
          } else {
            currentWord += char;
          }
        default:
          currentWord += char;
      }
    }
    return tokens;
  }

  static bool _containsOnly(String str, String allowedChars) {
    RegExp regex = RegExp("^[$allowedChars]+\$");
    return regex.hasMatch(str);
  }

  static bool _startsWithOneOf(String str, String allowedChars) {
    RegExp regex = RegExp("^[$allowedChars].*\$");
    return regex.hasMatch(str);
  }

  static bool _isValidName(String str) {
    return str != "" &&
        !_startsWithOneOf(str, "0123456789") &&
        _containsOnly(str,
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
  }
}
