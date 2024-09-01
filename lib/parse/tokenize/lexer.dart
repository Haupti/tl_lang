import 'package:tll/parse/tokenize/lexer_exception.dart';
import 'package:tll/parse/tokenize/token.dart';

class Lexer {
  static Token _nameOrKeywordToken(String word, int row, int col) {
    switch (word) {
      case "let":
        return LetToken(row, col);
      case "const":
        return ConstToken(row, col);
      case "defun":
        return DefunToken(row, col);
      case "type":
        return SumTypeToken(row, col);
      case "struct":
        return StructTypeToken(row, col);
      case "if":
        return IfToken(row, col);
      case "cond":
        return CondToken(row, col);
      default:
        return NameToken(word, row, col);
    }
  }

  static List<Token> tokenize(String code) {
    int row = 0;
    int col = 0;
    bool isInString = false;
    int? wordStartCol;
    int? stringStartRow;
    String currentWord = "";

    List<Token> tokens = [];

    addWord() {
      if (currentWord == "") {
        return;
      } else if (_containsOnly(currentWord, "0123456789")) {
        tokens.add(IntToken(int.parse(currentWord), row, wordStartCol ?? col));
      } else if (_containsOnly(currentWord, "0123456789.")) {
        tokens.add(
            FloatToken(double.parse(currentWord), row, wordStartCol ?? col));
      } else if (currentWord == "true" || currentWord == "false") {
        tokens.add(BoolToken(bool.parse(currentWord), row, col));
      } else if (currentWord.contains(".")) {
        List<String> split = currentWord.split(".");
        if (split.length < 2) {
          throw LexerException(
              "this cannot start or end with '.'", row, wordStartCol ?? col);
        }
        if (_isValidName(split[0]) &&
            _isValidName(split[1]) &&
            split.sublist(2).every((it) => _isValidName(it))) {
          tokens.add(ObjectAccessToken(
              split[0], split[1], split.sublist(2), row, col));
        } else {
          throw LexerException(
              "contains invalid character for name", row, wordStartCol ?? col);
        }
      } else if (_isValidName(currentWord)) {
        tokens.add(_nameOrKeywordToken(currentWord, row, wordStartCol ?? col));
      } else {
        throw LexerException(
            "contains invalid character for name", row, wordStartCol ?? col);
      }
      currentWord = "";
      wordStartCol = null;
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
          if (isInString) {
            currentWord += char;
          }
          if (!isInString) {
            stringStartRow ??= row;
            wordStartCol ??= col;
            addWord();
          }
          col = -1;
          row++;
        case '"':
          wordStartCol ??= col;
          currentWord += char;
          isInString = !isInString;
          if (!isInString) {
            tokens.add(StringToken(
                currentWord, stringStartRow ?? row, wordStartCol ?? col));
            currentWord = "";
          } else {
            stringStartRow = row;
          }
        case ' ':
          if (!isInString) {
            addWord();
          } else {
            wordStartCol ??= col;
            currentWord += char;
          }
        default:
          wordStartCol ??= col;
          currentWord += char;
      }
      col++;
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
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_+*/?<>-");
  }
}
