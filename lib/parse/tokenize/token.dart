sealed class Token {
  String show;
  int row;
  int col;
  Token(this.row, this.col, this.show);
  static bool isBracketOpen(Token token) {
    switch (token) {
      case T1BracesOpenToken _:
      case T2BracesOpenToken _:
      case T3BracesOpenToken _:
        return true;
      default:
        return false;
    }
  }

  static bool isKeyword(Token token) {
    switch (token) {
      case IfToken _:
      case CondToken _:
      case SumTypeToken _:
      case StructTypeToken _:
      case DefunToken _:
      case LetToken _:
      case ConstToken _:
        return true;
      case ObjectAccessToken _:
      case NameToken _:
      case IntToken _:
      case FloatToken _:
      case StringToken _:
      case BoolToken _:
      case T1BracesOpenToken _:
      case T2BracesOpenToken _:
      case T3BracesOpenToken _:
      case T1BracesCloseToken _:
      case T2BracesCloseToken _:
      case T3BracesCloseToken _:
        return false;
    }
  }
}

class T1BracesOpenToken implements Token {
  @override
  String show = "(";

  @override
  int col;

  @override
  int row;
  T1BracesOpenToken(this.row, this.col);
}

class T2BracesOpenToken implements Token {
  @override
  String show = "[";

  @override
  int col;

  @override
  int row;
  T2BracesOpenToken(this.row, this.col);
}

class T3BracesOpenToken implements Token {
  @override
  String show = "{";

  @override
  int col;

  @override
  int row;
  T3BracesOpenToken(this.row, this.col);
}

class T1BracesCloseToken implements Token {
  @override
  String show = ")";

  @override
  int col;

  @override
  int row;
  T1BracesCloseToken(this.row, this.col);
}

class T2BracesCloseToken implements Token {
  @override
  String show = "]";

  @override
  int col;

  @override
  int row;
  T2BracesCloseToken(this.row, this.col);
}

class T3BracesCloseToken implements Token {
  @override
  String show = "}";

  @override
  int col;

  @override
  int row;
  T3BracesCloseToken(this.row, this.col);
}

class IntToken implements Token {
  @override
  String show;

  int value;
  @override
  int col;

  @override
  int row;
  IntToken(this.value, this.row, this.col) : show = "int:$value";
}

class FloatToken implements Token {
  @override
  String show;

  double value;

  @override
  int col;

  @override
  int row;
  FloatToken(this.value, this.row, this.col) : show = "float:$value";
}

class StringToken implements Token {
  @override
  String show;

  String value;

  @override
  int col;

  @override
  int row;
  StringToken(this.value, this.row, this.col) : show = "str:$value";
}

class BoolToken implements Token {
  @override
  String show;

  bool value;

  @override
  int col;

  @override
  int row;
  BoolToken(this.value, this.row, this.col) : show = "bool:$value";
}

class ConstToken implements Token {
  @override
  String show = "keyword:const";

  @override
  int col;

  @override
  int row;
  ConstToken(this.row, this.col);
}

class LetToken implements Token {
  @override
  String show = "keyword:let";

  @override
  int col;

  @override
  int row;
  LetToken(this.row, this.col);
}

class DefunToken implements Token {
  @override
  String show = "keyword:defun";

  @override
  int col;

  @override
  int row;
  DefunToken(this.row, this.col);
}

class StructTypeToken implements Token {
  @override
  String show = "keyword:struct";

  @override
  int col;

  @override
  int row;
  StructTypeToken(this.row, this.col);
}

class SumTypeToken implements Token {
  @override
  String show = "keyword:struct";

  @override
  int col;

  @override
  int row;
  SumTypeToken(this.row, this.col);
}

class CondToken implements Token {
  @override
  String show = "keyword:cond";

  @override
  int col;

  @override
  int row;
  CondToken(this.row, this.col);
}

class IfToken implements Token {
  @override
  String show = "keyword:if";

  @override
  int col;

  @override
  int row;
  IfToken(this.row, this.col);
}

class NameToken implements Token {
  @override
  String show;

  String value;

  @override
  int col;

  @override
  int row;
  NameToken(this.value, this.row, this.col) : show = "name:$value";
}

class ObjectAccessToken implements Token {
  @override
  String show;

  String objectName;
  String accessedName;
  List<String> subaccessedNames;

  @override
  int col;

  @override
  int row;
  ObjectAccessToken(this.objectName, this.accessedName, this.subaccessedNames,
      this.row, this.col)
      : show = "access:$objectName.$accessedName.${subaccessedNames.join(".")}";
}
